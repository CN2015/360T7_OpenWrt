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

# iStore
git_sparse_clone main https://github.com/linkease/istore-ui app-store-ui
git_sparse_clone main https://github.com/linkease/istore luci

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

# 修改TTYD终端界面
cat > package/base-files/files/etc/banner << EOF
  _______                     ________        __
 |       |.-----.-----.-----.|  |  |  |.----.|  |_
 |   -   ||  _  |  -__|     ||  |  |  ||   _||   _|
 |_______||   __|_____|__|__||________||__|  |____|
          |__| W I R E L E S S   F R E E D O M
 -----------------------------------------------------
 %D %V, %C
 -----------------------------------------------------
EOF

 # 自定义WIFI名称
cat > package/kernel/mac80211/files/lib/wifi/mac80211.sh << EOF
#!/bin/sh

append DRIVERS "mac80211"

lookup_phy() {
	[ -n "$phy" ] && {
		[ -d /sys/class/ieee80211/$phy ] && return
	}

	local devpath
	config_get devpath "$device" path
	[ -n "$devpath" ] && {
		phy="$(iwinfo nl80211 phyname "path=$devpath")"
		[ -n "$phy" ] && return
	}

	local macaddr="$(config_get "$device" macaddr | tr 'A-Z' 'a-z')"
	[ -n "$macaddr" ] && {
		for _phy in /sys/class/ieee80211/*; do
			[ -e "$_phy" ] || continue

			[ "$macaddr" = "$(cat ${_phy}/macaddress)" ] || continue
			phy="${_phy##*/}"
			return
		done
	}
	phy=
	return
}

find_mac80211_phy() {
	local device="$1"

	config_get phy "$device" phy
	lookup_phy
	[ -n "$phy" -a -d "/sys/class/ieee80211/$phy" ] || {
		echo "PHY for wifi device $1 not found"
		return 1
	}
	config_set "$device" phy "$phy"

	config_get macaddr "$device" macaddr
	[ -z "$macaddr" ] && {
		config_set "$device" macaddr "$(cat /sys/class/ieee80211/${phy}/macaddress)"
	}

	return 0
}

check_mac80211_device() {
	config_get phy "$1" phy
	[ -z "$phy" ] && {
		find_mac80211_phy "$1" >/dev/null || return 0
		config_get phy "$1" phy
	}
	[ "$phy" = "$dev" ] && found=1
}


__get_band_defaults() {
	local phy="$1"

	( iw phy "$phy" info; echo ) | awk '
BEGIN {
        bands = ""
}

($1 == "Band" || $1 == "") && band {
        if (channel) {
		mode="NOHT"
		if (ht) mode="HT20"
		if (vht && band != "1:") mode="VHT80"
		if (he) mode="HE80"
		if (he && band == "1:") mode="HE20"
                sub("\\[", "", channel)
                sub("\\]", "", channel)
                bands = bands band channel ":" mode " "
        }
        band=""
}

$1 == "Band" {
        band = $2
        channel = ""
	vht = ""
	ht = ""
	he = ""
}

$0 ~ "Capabilities:" {
	ht=1
}

$0 ~ "VHT Capabilities" {
	vht=1
}

$0 ~ "HE Iftypes" {
	he=1
}

$1 == "*" && $3 == "MHz" && $0 !~ /disabled/ && band && !channel {
        channel = $4
}

END {
        print bands
}'
}

get_band_defaults() {
	local phy="$1"

	for c in $(__get_band_defaults "$phy"); do
		local band="${c%%:*}"
		c="${c#*:}"
		local chan="${c%%:*}"
		c="${c#*:}"
		local mode="${c%%:*}"

		case "$band" in
			1) band=2g;;
			2) band=5g;;
			3) band=60g;;
			4) band=6g;;
			*) band="";;
		esac

		[ -n "$band" ] || continue
		[ -n "$mode_band" -a "$band" = "6g" ] && return

		mode_band="$band"
		channel="$chan"
		htmode="$mode"
	done
}

detect_mac80211() {
	devidx=0
	config_load wireless
	while :; do
		config_get type "radio$devidx" type
		[ -n "$type" ] || break
		devidx=$(($devidx + 1))
	done

	for _dev in /sys/class/ieee80211/*; do
		[ -e "$_dev" ] || continue

		dev="${_dev##*/}"

		found=0
		config_foreach check_mac80211_device wifi-device
		[ "$found" -gt 0 ] && continue

		mode_band=""
		channel=""
		htmode=""
		ht_capab=""

		get_band_defaults "$dev"

		path="$(iwinfo nl80211 path "$dev")"
		if [ -n "$path" ]; then
			dev_id="set wireless.radio${devidx}.path='$path'"
		else
			dev_id="set wireless.radio${devidx}.macaddr=$(cat /sys/class/ieee80211/${dev}/macaddress)"
		fi
		
        if [ "$mode_band" = "5g" ]; then
        ssid_5ghz="_5G"
        else
        ssid_5ghz="_2G"
        fi

		uci -q batch <<-EOF
			set wireless.radio${devidx}=wifi-device
			set wireless.radio${devidx}.type=mac80211
			${dev_id}
			set wireless.radio${devidx}.channel=${channel}
			set wireless.radio${devidx}.band=${mode_band}
			set wireless.radio${devidx}.htmode=$htmode
			set wireless.radio${devidx}.disabled=0
			set wireless.radio${devidx}.country=US

			set wireless.default_radio${devidx}=wifi-iface
			set wireless.default_radio${devidx}.device=radio${devidx}
			set wireless.default_radio${devidx}.network=lan
			set wireless.default_radio${devidx}.mode=ap
			set wireless.default_radio${devidx}.ssid=Redmi_$(cat /sys/class/ieee80211/${dev}/macaddress|awk -F ":" '{print $5""$6 }'| tr a-z A-Z)${ssid_5ghz} 
			set wireless.default_radio${devidx}.encryption=none
EOF
		uci -q commit wireless

		devidx=$(($devidx + 1))
	done
}
EOF

