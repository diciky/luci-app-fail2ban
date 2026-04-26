--[[
Fail2ban LuCI Interface
For OpenWrt
Author: diciky
]]--

module("luci.controller.fail2ban", package.seeall)

function index()
	entry({"admin", "services", "fail2ban"}, template("fail2ban/status"), _("Fail2ban"), 60).dependent = true
	entry({"admin", "services", "fail2ban", "status"}, template("fail2ban/status"), _("Status"), 1).leaf = true
	entry({"admin", "services", "fail2ban", "bans"}, template("fail2ban/bans"), _("Banned IPs"), 2).leaf = true
	entry({"admin", "services", "fail2ban", "ban"}, template("fail2ban/ban"), _("Ban IP"), 3).leaf = true
	entry({"admin", "services", "fail2ban", "log"}, template("fail2ban/log"), _("Log"), 4).leaf = true
	entry({"admin", "services", "fail2ban", "config"}, template("fail2ban/config"), _("Config"), 5).leaf = true
end
