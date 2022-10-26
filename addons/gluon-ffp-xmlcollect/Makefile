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

define Package/gluon-ffp-xmlcollect/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) ./files/ffp-xmlcollect.sh $(1)/usr/bin/ffp-xmlcollect.sh
	$(INSTALL_DIR) $(1)/usr/lib/micron.d
	$(CP) ./files/ffp-xmlcollect.cron $(1)/usr/lib/micron.d/ffp-xmlcollect
endef

$(eval $(call BuildPackage,gluon-ffp-xmlcollect))
