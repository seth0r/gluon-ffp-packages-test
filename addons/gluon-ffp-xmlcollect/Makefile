include $(TOPDIR)/rules.mk

PKG_NAME:=gluon-ffp-xmlcollect
PKG_VERSION:=22.10
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(TOPDIR)/../package/gluon.mk

define Package/gluon-ffp-xmlcollect
  SECTION:=addons
  CATEGORY:=Addons
  TITLE:=Freifunk Potsdam Gluon XMLcollect
  URL:=http://github.com/freifunk-potsdam/gluon-ffp-packages
  PKGARCH:=all
endef

define Package/gluon-ffp-xmlcollect/description
  Freifunk Potsdam Gluon StatusXML collect script
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/gluon-ffp-ollect/install
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/ffp-collect.init $(1)/etc/init.d/ffp-collect
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) ./files/ffp-xmlcollect.sh $(1)/usr/bin/ffp-xmlcollect.sh
#	$(INSTALL_DIR) $(1)/etc/uci-defaults
#	$(CP) ./files/ffp-z95_ffp-collect $(1)/etc/uci-defaults/
endef

define Package/gluon-ffp-xmlcollect/postinst
#!/bin/sh
#if [ -f /lib/functions.sh ] ; then
#	$${IPKG_INSTROOT}/etc/init.d/ffp-collect start
#	$${IPKG_INSTROOT}/etc/init.d/ffp-collect enable
#fi
endef

$(eval $(call BuildPackage,gluon-ffp-collect))
