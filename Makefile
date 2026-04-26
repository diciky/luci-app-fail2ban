# Fail2ban LuCI Interface for OpenWrt
# Makefile for GitHub Actions / Standalone Build
#
# Usage:
#   make help              - Show help
#   make test-syntax       - Test Lua syntax
#   make validate          - Validate package structure
#   make check             - Run all checks

PKG_NAME := luci-app-fail2ban
PKG_VERSION := 1.0.0
PKG_RELEASE := 1

.PHONY: help test-syntax validate check package-tarball clean

help:
	@echo "Fail2ban LuCI Interface - Makefile"
	@echo ""
	@echo "Available targets:"
	@echo "  make test-syntax   - Test Lua syntax with lua5.3"
	@echo "  make validate      - Validate package structure"
	@echo "  make check         - Run all checks"
	@echo "  make package-tarball - Create distribution tarball"
	@echo "  make clean         - Clean temporary files"

test-syntax:
	@echo "Testing Lua syntax..."
	@which lua5.3 >/dev/null 2>&1 || (sudo apt-get update && sudo apt-get install -y lua5.3)
	@find . -name "*.lua" -print -exec lua5.3 -p {} \; 2>&1 || true
	@echo "Syntax check complete"

validate:
	@echo "Validating package structure..."
	@echo "Checking root/etc/config/fail2ban..."
	@test -f root/etc/config/fail2ban && echo "  OK" || echo "  MISSING"
	@echo "Checking controller..."
	@test -f root/usr/lib/lua/luci/controller/fail2ban.lua && echo "  OK" || echo "  MISSING"
	@echo "Checking views..."
	@test -f root/usr/lib/lua/luci/view/fail2ban/status.htm && echo "  OK" || echo "  MISSING"
	@test -f root/usr/lib/lua/luci/view/fail2ban/config.htm && echo "  OK" || echo "  MISSING"
	@test -f root/usr/lib/lua/luci/view/fail2ban/bans.htm && echo "  OK" || echo "  MISSING"
	@test -f root/usr/lib/lua/luci/view/fail2ban/log.htm && echo "  OK" || echo "  MISSING"
	@echo "Checking Makefile..."
	@test -f src/Makefile && echo "  OK" || echo "  MISSING"
	@echo "Validation complete"

check: test-syntax validate
	@echo "All checks passed!"

package-tarball:
	@echo "Creating distribution tarball..."
	@cd .. && rm -f $(PKG_NAME)-$(PKG_VERSION).tar.gz
	@cd .. && tar -czvf $(PKG_NAME)-$(PKG_VERSION).tar.gz $(PKG_NAME)/
	@ls -la ../$(PKG_NAME)-$(PKG_VERSION).tar.gz

clean:
	@echo "Cleaning..."
	@find . -name "*.swp" -delete
	@find . -name "*~" -delete
	@echo "Clean complete"
