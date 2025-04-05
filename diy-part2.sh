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
sed -i 's/"ShadowSocksR Plus+"/"SSR Plus"/g' `egrep "ShadowSocksR Plus+" -rl ./`
sed -i 's/"DDNSTO 远程控制"/"远程控制"/g' `egrep "DDNSTO 远程控制" -rl ./`
sed -i 's/"上网时间控制"/"上网管理"/g' `egrep "上网时间控制" -rl ./`
sed -i 's/"Lucky大吉"/"端口转发' `egrep "Lucky大吉" -rl ./`
sed -i 's/"KMS 服务器"/"激活服务"/g' `egrep "KMS 服务器" -rl ./`
sed -i 's/"Mwol"/"物联后台"/g' `egrep "Mwol" -rl ./`
sed -i 's/"udpxy"/"组播中继"/g' `egrep "udpxy" -rl ./`
sed -i 's/"QoS"/"数据包排序"/g' `egrep "QoS" -rl ./`
sed -i 's/"Turbo ACC 网络加速"/"网络加速器"/g' `egrep "Turbo ACC 网络加速" -rl ./`
sed -i 's/"终端"/"TTYD终端"/g' `egrep "终端" -rl ./`
sed -i 's/"服务质量(QoS)"/"服务质量"/g' `egrep "服务质量(QoS)" -rl ./`
sed -i 's/"ADBYBY Plus +"/"广告拦截"/g' `egrep "ADBYBY Plus +" -rl ./`
sed -i 's/"MWAN3 Helper"/"分流助手"/g' `egrep "MWAN3 Helper" -rl ./`
sed -i 's/"udpxy"/"电视组播"/g' `egrep "udpxy" -rl ./`
sed -i 's/"UPnP"/"即插即用"/g' `egrep "UPnP" -rl ./`

# 修改TTYD界面
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
