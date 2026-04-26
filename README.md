# luci-app-fail2ban

OpenWrt LuCI 管理界面 for Fail2ban

## 功能特性

- **状态**: 查看 fail2ban 服务状态和监狱信息
- **封禁列表**: 查看所有被封禁的 IP，一键解封
- **封禁IP**: 手动封禁指定 IP 地址
- **日志**: 实时查看 fail2ban 日志
- **配置**: 编辑配置文件，服务控制（启动/停止/重载/重启）

## 截图预览

### 状态页面
- 服务运行状态
- 监狱统计信息
- 快捷操作（启动/停止/重载）

### 封禁列表
- 显示所有被封禁的 IP（红色下划线高亮）
- 一键解封单个 IP
- 一键解封所有 IP

### 封禁 IP
- 输入 IP 地址和选择监狱
- 手动封禁指定的 IP

### 日志页面
- 实时显示最近 50 条日志

### 配置页面
- 配置文件编辑器
- 服务控制按钮
- 重要路径信息

## 系统要求

- OpenWrt 21.02+ 或 LEDE 17.01+
- fail2ban 已安装
- luci-base

## 安装方式

### 方式一：OpenWrt 编译

```bash
# 克隆到 OpenWrt package 目录
cd openwrt/package
git clone https://github.com/diciky/luci-app-fail2ban.git

# 编译
cd openwrt
make menuconfig  # 选择 LuCI > Applications > luci-app-fail2ban
make package/luci-app-fail2ban/compile
```

### 方式二：手动安装

```bash
# 上传所有文件
scp -P 38438 -r root/* root@your-router://
chmod +x /www/cgi-bin/fail2ban

# 重启 LuCI
/etc/init.d/uhttpd restart
```

## 访问地址

安装后通过 LuCI Web 界面访问:

```
http://your-router-ip → 服务 → Fail2ban
```

## 配置说明

### 白名单设置

编辑 `/etc/fail2ban/jail.local` 添加 IP 白名单:

```ini
[DEFAULT]
ignoreip = 127.0.0.1/8 10.10.0.0/16 你的公网IP
```

### 监狱说明

- **dropbear**: SSH 登录保护
- **luci**: LuCI Web 界面保护

## 文件结构

```
root/
├── etc/
│   ├── config/fail2ban          # UCI 配置文件
│   └── fail2ban/jail.local      # Fail2ban 主配置
├── usr/
│   └── lib/lua/luci/
│       ├── controller/fail2ban.lua  # LuCI 控制器
│       └── view/fail2ban/          # 视图模板
│           ├── status.htm
│           ├── bans.htm
│           ├── ban.htm
│           ├── log.htm
│           └── config.htm
└── www/
    └── cgi-bin/fail2ban         # CGI 处理脚本
```

## 开源协议

GPL-3.0

## 作者

[diciky](https://github.com/diciky)
