--[[
Fail2ban LuCI Interface
For OpenWrt
Author: diciky
Version: 1.0.0
]]--

module("luci.controller.fail2ban", package.seeall)

function index()
	entry({"admin", "services", "fail2ban"}, firstchild(), _("Fail2ban"), 60)
	entry({"admin", "services", "fail2ban", "status"}, view("fail2ban/status.htm"), _("Status"), 1).dependent = false
	entry({"admin", "services", "fail2ban", "config"}, view("fail2ban/config.htm"), _("Configuration"), 2).dependent = false
	entry({"admin", "services", "fail2ban", "bans"}, view("fail2ban/bans.htm"), _("Banned IPs"), 3).dependent = false
	entry({"admin", "services", "fail2ban", "log"}, view("fail2ban/log.htm"), _("Log"), 4).dependent = false

	entry({"admin", "services", "fail2ban", "action", "unban"}, call("action_unban"))
	entry({"admin", "services", "fail2ban", "action", "reload"}, call("action_reload"))
	entry({"admin", "services", "fail2ban", "action", "start"}, call("action_start"))
	entry({"admin", "services", "fail2ban", "action", "stop"}, call("action_stop"))
	entry({"admin", "services", "fail2ban", "action", "unban_all"}, call("action_unban_all"))
end

local function exec(cmd)
	local f = io.popen(cmd)
	local output = f:read("*a")
	f:close()
	return output
end

function get_status()
	local status = {}
	status.running = (exec("pgrep -x fail2ban-server > /dev/null 2>&1 && echo 1 || echo 0") == "1")
	status.jail_raw = exec("fail2ban-client status sshd 2>/dev/null")
	status.banned_raw = exec("fail2ban-client banned 2>/dev/null")
	return status
end

function get_banned_ips()
	local ips = {}
	local output = exec("fail2ban-client banned 2>/dev/null")
	for ip in output:gmatch("[%d%.%-:a-f]+") do
		if ip:match("^%d+%.") then
			table.insert(ips, {ip = ip})
		end
	end
	return ips
end

function action_unban()
	local ip = luci.http.formvalue("ip")
	if ip and ip ~= "" then
		exec("fail2ban-client set sshd unbanip " .. ip .. " 2>/dev/null")
	end
	luci.http.redirect(luci.dispatcher.build_url("admin/services/fail2ban/bans"))
end

function action_unban_all()
	exec("fail2ban-client unban --all 2>/dev/null")
	luci.http.redirect(luci.dispatcher.build_url("admin/services/fail2ban/bans"))
end

function action_reload()
	exec("/etc/init.d/fail2ban reload 2>/dev/null")
	luci.http.redirect(luci.dispatcher.build_url("admin/services/fail2ban/status"))
end

function action_start()
	exec("/etc/init.d/fail2ban start 2>/dev/null")
	luci.http.redirect(luci.dispatcher.build_url("admin/services/fail2ban/status"))
end

function action_stop()
	exec("/etc/init.d/fail2ban stop 2>/dev/null")
	luci.http.redirect(luci.dispatcher.build_url("admin/services/fail2ban/status"))
end

function save_config()
	local enabled = luci.http.formvalue("enabled")
	local bantime = luci.http.formvalue("bantime")
	local findtime = luci.http.formvalue("findtime")
	local maxretry = luci.http.formvalue("maxretry")

	if enabled == "1" then
		exec("uci set fail2ban.config.enabled=1")
	else
		exec("uci set fail2ban.config.enabled=0")
	end

	if bantime and bantime ~= "" then
		exec("uci set fail2ban.Defaults.bantime=" .. bantime)
	end

	if findtime and findtime ~= "" then
		exec("uci set fail2ban.Defaults.findtime=" .. findtime)
	end

	if maxretry and maxretry ~= "" then
		exec("uci set fail2ban.Defaults.maxretry=" .. maxretry)
	end

	exec("uci commit fail2ban")
end
