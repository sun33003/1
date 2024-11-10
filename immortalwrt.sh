#!/bin/bash
#=================================================
# File name: immortalwrt.sh
# System Required: Linux
# Version: 1.0
# Lisence: MIT
# Author: SuLingGG
# Blog: https://mlapp.cn
#=================================================
# Clone community packages to package/community
mkdir package/community
pushd package/community

# Add openwrt-packages
git clone --depth=1 https://github.com/xuanranran/openwrt-package openwrt-package
git clone --depth=1 https://github.com/xuanranran/rely openwrt-rely
git clone --depth=1 https://github.com/immortalwrt/wwan-packages wwan-packages
# rm -rf openwrt-package/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg
# rm -rf openwrt-package/luci-theme-design/htdocs/luci-static/design/favicon.ico
# cp -f $GITHUB_WORKSPACE/data/bg1.jpg openwrt-package/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg
# cp -f $GITHUB_WORKSPACE/data/favicon.ico openwrt-package/luci-theme-design/htdocs/luci-static/design/favicon.ico
chmod 755 openwrt-package/luci-app-onliner/root/usr/share/onliner/setnlbw.sh
popd

# Mod zzz-default-settings
# pushd package/emortal/default-settings/default
# sed -i '$i uci set nlbwmon.@nlbwmon[0].refresh_interval=1s' zzz-default-settings
# sed -i '$i uci commit nlbwmon' zzz-default-settings
# export orig_version=$(cat "zzz-default-settings" | grep DISTRIB_REVISION= | awk -F "'" '{print $2}')
# export date_version=$(date -d "$(rdate -n -4 -p ntp.aliyun.com)" +'%Y-%m-%d')
# sed -i "s/${orig_version}/${orig_version} (${date_version})/g" zzz-default-settings
# popd

# fix sysupgrade
rm -rf package/base-files/files/sbin/sysupgrade
cp -f $GITHUB_WORKSPACE/data/sysupgrade package/base-files/files/sbin/sysupgrade
chmod 755 package/base-files/files/sbin/sysupgrade

# Change default shell to zsh
sed -i 's/\/bin\/ash/\/usr\/bin\/zsh/g' package/base-files/files/etc/passwd

# Modify default IP
sed -i 's/192.168.1.1/192.168.11.1/g' package/base-files/files/bin/config_generate

# x86 型号只显示 CPU 型号
# sed -i 's/${g}.*/${a}${b}${c}${d}${e}${f}${hydrid}/g' package/lean/autocore/files/x86/autocore

# 修改开源站地址
sed -i '/@OPENWRT/a\\t\t"https://source.cooluc.com",' scripts/projectsmirrors.json

# 修改本地时间格式
# sed -i 's/os.date()/os.date("%F %T %a")/g' package/lean/autocore/files/*/index.htm

sed -i 's/services/network/g' customfeeds/luci/applications/luci-app-upnp/root/usr/share/luci/menu.d/luci-app-upnp.json

# Test kernel 6.6
rm -rf target/linux/x86/base-files/etc/board.d/02_network
rm -rf package/base-files/files/etc/banner
cp -f $GITHUB_WORKSPACE/data/banner package/base-files/files/etc/banner
cp -f $GITHUB_WORKSPACE/data/02_network target/linux/x86/base-files/etc/board.d/02_network
