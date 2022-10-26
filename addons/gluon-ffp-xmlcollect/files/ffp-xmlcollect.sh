#!/bin/sh

EXCLUDE_DEVICES=""
UPLOADHOST="monitor.freifunk-potsdam.de"
UPLOADPORT=17485
SENDCONTACT=1

COLLDIR=/tmp/ffp_coll

export LC_ALL=C

## script variables
SCRIPTVERSION='22.10'
SCRIPTNAME=`basename $0`

if [ ! -d "$COLLDIR" ]; then
	mkdir "$COLLDIR"
fi
EXCLUDE_DEVICES=`echo $EXCLUDE_DEVICES | sed 's/\./_/g'`
hostname=`uci get system.@system[0].hostname`
time=`date +%s`

xuptime() {
	echo "<uptime>"
	uptime
	echo "</uptime>"
}

xifconfig() {
	echo "<ifconfig>"
	for dev in `ls /sys/class/net/` ; do
		ndev=`echo $dev | sed 's/\./_/g'`
		if [ "`echo $EXCLUDE_DEVICES | grep -w $ndev`" = "" ] ; then
			echo "<$ndev>"
			ifconfig $dev
			echo "</$ndev>"
		fi
	done
	echo "</ifconfig>"
}


xtop() {
	echo "<top>"
	sleep 3
	top -b -n1 | head -n2
	echo "</top>"
}

xdf() {
	echo "<df>"
	df
	echo "</df>"
}

xconn() {
	echo "<conn>"
	cut -c12-20 /proc/net/nf_conntrack | sort | uniq -c
	echo "</conn>"
}

xiwinfo() {
	echo "<iwinfo>"
	iwinfo | grep "^[a-z]" | while read line ; do
		dev=`echo $line | cut -d' ' -f1`
		ndev=`echo $dev | sed 's/\./_/g'`
		if [ "`echo $EXCLUDE_DEVICES | grep -w $ndev`" = "" ] ; then
			echo "<$ndev>"
			iwinfo $dev info
			cnt=`iwinfo $dev assoclist | grep -E "^[0-9A-F]{2}:" | wc -l`
			echo -e "\tAssoc: $cnt"
			echo "</$ndev>"
		fi
	done
	echo "</iwinfo>"
}

xbrctl() {
	echo "<brctl>"
	brctl show
	echo "</brctl>"
}

xroutes() {
	echo "<tunnel>"
	ip tunnel show
	echo "</tunnel>"
	echo "<routes>"
	ip route show table main | grep default
	ip route show table ffuplink 2> /dev/null | grep default
	ip route show table olsr-default | grep default
	ip route show table olsr-tunnel | grep default
	echo "</routes>"
}

xoptions() {
	echo "<options>"
	grep 'latitude' /etc/config/system
	grep 'longitude' /etc/config/system
	grep 'location' /etc/config/system
	if [ "$SENDCONTACT" == "1" ]; then
		grep 'mail' /etc/config/freifunk
		grep 'note' /etc/config/freifunk
		grep 'phone' /etc/config/freifunk
	fi
	echo "</options>"
}

xsystem() {
	echo "<system>"
	echo -n "firmware : "
	cat /etc/openwrt_version
	grep 'machine' /proc/cpuinfo
	grep 'system type' /proc/cpuinfo
	echo "</system>"
}

echocrlf() {
	echo -n "$1"
}

fupload() {
	if [ -f "$1" ]; then
		len=`ls -al "$1" | sed 's/ \+/\t/g' | cut -f5`
		(
			echo "$len $1 $hostname"
			cat "$1"
		) | nc $2 $3
		p=$!
		sleep 10 && kill $p 2> /dev/null
	fi
}

plog() {
	MSG="$*"
	echo ${MSG}
	logger -t ${SCRIPTNAME} ${MSG}
}
upload_rm() {
	if [ -f "$1" ]; then
		plog "uploading $1..."
		res=`fupload $1 $UPLOADHOST $UPLOADPORT | tail -n1`
		if [ "$res" = "success" ]; then
			rm $1
		fi
	fi
}

upload_rm_or_gzip() {
	if [ -f "$1" ]; then
		plog "uploading $1..."
		res=`fupload $1 $UPLOADHOST $UPLOADPORT | tail -n1`
		if [ "$res" = "success" ]; then
			rm $1
		else
			plog "uploading $1 failed, zipping..."
			gzip $1 2> /dev/null
		fi
	fi
}

if [ "$1" = "collect" ]; then
	m=`date +%M`
	f=$COLLDIR/$time.cff
	echo "<ffstat host='$hostname' time='$time' ver='$SCRIPTVERSION'>" > $f
	(
		xtop
		xuptime
		xconn
		xroutes
		if [ $(( $m % 5 )) -eq 0 ]; then
			xsystem
			xoptions
			xdf
			xbrctl
			xiwinfo
			xifconfig
		fi
	) >> $f
	echo "</ffstat>" >> $f
	mv $f $f.xml
	rm -r $COLLDIR/*.cff 2> /dev/null
elif [ "$1" = "upload" ]; then
	if [ "$2" != "--now" ]; then
		# wait a random time
		WAIT=$(awk 'BEGIN{srand();print int(rand()*300)}')
		plog "sleeping $WAIT seconds before upload..."
		sleep $WAIT
	fi
	for f in $COLLDIR/*.cff.xml.gz; do
		upload_rm $f &
		sleep 1
	done
	for f in $COLLDIR/*.cff.xml; do
		upload_rm_or_gzip $f &
		sleep 1
	done
	wait
	filled=`df $COLLDIR | tail -n1 | sed -E 's/^.*([0-9]+)%.*$/\1/g'`
	while [ $filled -gt 50 ]; do
		f=`ls -lrc $COLLDIR | sed 's/ \+/\t/g' | cut -f9 | head -n1`
		if [ "$f" != "" ]; then
			rm "$COLLDIR/$f"
		else
			break
		fi
	done
fi
