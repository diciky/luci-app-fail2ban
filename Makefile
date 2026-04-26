# Fail2ban LuCI Interface for OpenWrt

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-fail2ban
PKG_VERSION:=1.0.0
PKG_RELEASE:=1
PKG_LICENSE:=GPL-3.0
PKG_MAINTAINER:=diciky
PKG_ARCH:=all

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-fail2ban
  SECTION:=luci
  CATEGORY:=LuCI
  SUBMENU:=Services
  TITLE:=Fail2ban LuCI Interface
  URL:=https://github.com/diciky/luci-app-fail2ban
  PKGARCH:=all
  DEPENDS:=+fail2ban +luci-base +luci-compat
endef

define Package/luci-app-fail2ban/description
  Fail2ban LuCI Interface for OpenWrt
  Provides web UI to manage fail2ban service
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/luci-app-fail2ban/install
	$(CP) -p ./root/* $(1)/
endef

$(eval $(call BuildPackage,luci-app-fail2ban))
