include $(TOPDIR)/rules.mk

PKG_NAME:=gluon-ffp-easy-reconf
PKG_VERSION:=22.10
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(TOPDIR)/../package/gluon.mk

define Package/gluon-ffp-easy-reconf
  SECTION:=Admin
  CATEGORY:=Admin Tools
  TITLE:=Freifunk Potsdam Gluon reconfiguration script
  URL:=http://github.com/freifunk-potsdam/gluon-ffp-packages
  PKGARCH:=all
endef

define Package/gluon-ffp-easy-reconf/description
  Freifunk Potsdam Gluon reconfiguration script provides the command reconfigure to re-enter config mode
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/gluon-ffp-easy-reconf/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) ./files/reconfigure $(1)/usr/sbin/reconfigure
endef

$(eval $(call BuildPackage,gluon-ffp-easy-reconf))
