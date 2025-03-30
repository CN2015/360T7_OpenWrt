#!/bin/bash
#============================================================
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#============================================================

# 修改默认IP
sed -i 's/192.168.1.1/192.168.6.1/g' package/base-files/files/bin/config_generate
sed -i "s/hostname='ImmortalWrt'/hostname='OpenWrt'/g" package/base-files/files/bin/config_generate

# Modify hostname
#sed -i 's/OpenWrt/Redmi_AX6000/g' package/base-files/files/bin/config_generate

# 修改时区 UTF-8
sed -i 's/UTC/CST-8/g'  package/base-files/files/bin/config_generate

# 时区
sed -i 's/time1.apple.com/time1.cloud.tencent.com/g'  package/base-files/files/bin/config_generate
sed -i 's/time1.google.com/ntp.aliyun.com/g'  package/base-files/files/bin/config_generate
sed -i 's/time.cloudflare.com/cn.ntp.org.cn/g'  package/base-files/files/bin/config_generate
sed -i 's/pool.ntp.org/cn.pool.ntp.org/g'  package/base-files/files/bin/config_generate

# 替换源 
sed -i 's,mirrors.vsean.net/openwrt,mirrors.pku.edu.cn/immortalwrt,g'  package/emortal/default-settings/files/99-default-settings-chinese

# 修改插件名字
sed -i 's/"Argon 主题设置"/"主题设置"/g' `egrep "Argon 主题设置" -rl ./`
sed -i 's/"Release Ram"/"内存释放"/g' `egrep "Release Ram" -rl ./`
sed -i 's/"ShadowSocksR Plus+"/"SSR Plus"/g' `egrep "ShadowSocksR Plus+" -rl ./`
sed -i 's/"Custom Commands"/"命令脚本"/g' `egrep "Custom Commands" -rl ./`
sed -i 's/"Scheduled Reboot"/"定时重启"/g' `egrep "Scheduled Reboot" -rl ./`
sed -i 's/"UU游戏加速器"/"游戏加速"/g' `egrep "UU游戏加速器" -rl ./`
sed -i 's/"Argon Config"/"主题设置"/g' `egrep "Argon Config" -rl ./`
sed -i 's/"Wake on LAN"/"网络唤醒"/g' `egrep "Wake on LAN" -rl ./`
sed -i 's/"v2rayA"/"v2ray"/g' `egrep "v2rayA" -rl ./`
sed -i 's/"DDNS-Go"/"动态域名"/g' `egrep "DDNS-Go" -rl ./`
sed -i 's/"备份与升级"/"系统升级"/g' `egrep "备份与升级" -rl ./`
sed -i 's/"Terminal"/"终端"/g' `egrep "Terminal" -rl ./`
sed -i 's/"AList"/"文件搜刮"/g' `egrep "AList" -rl ./`
sed -i 's/"AliDDNS"/"阿里DDNS"/g' `egrep "AliDDNS" -rl ./`
sed -i 's/"frp Client"/"Frp客户端"/g' `egrep "frp Client" -rl ./`
sed -i 's/"Multi Stream daemon Lite"/"MSD_lite"/g' `egrep "Multi Stream daemon Lite" -rl ./`
sed -i 's/"IPTV Helper"/"IPTV助手"/g' `egrep "IPTV Helper" -rl ./`
sed -i 's/"MWAN3 分流助手"/"分流助手"/g' `egrep "MWAN3 分流助手" -rl ./`
sed -i 's/"服务质量(QoS)"/"服务质量"/g' `egrep "服务质量(QoS)" -rl ./`
sed -i 's/"ADBYBY Plus +"/"广告拦截"/g' `egrep "ADBYBY Plus +" -rl ./`
sed -i 's/"MWAN3 Helper"/"分流助手"/g' `egrep "MWAN3 Helper" -rl ./`
sed -i 's/"udpxy"/"电视组播"/g' `egrep "udpxy" -rl ./`
sed -i 's/"UPnP"/"即插即用"/g' `egrep "UPnP" -rl ./`

cat > package/base-files/files/etc/banner << EOF
  _______                     ________        __
 |       |.-----.-----.-----.|  |  |  |.----.|  |_
 |   -   ||  _  |  -__|     ||  |  |  ||   _||   _|
 |_______||   __|_____|__|__||________||__|  |____|
          |__| W I R E L E S S   F R E E D O M
 -----------------------------------------------------
 %D %V, %C
 -----------------------------------------------------
