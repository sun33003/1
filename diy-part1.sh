#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
sed -i "/helloworld/d" "feeds.conf.default"  # 
echo "src-git helloworld https://github.com/fw876/helloworld.git" >> "feeds.conf.default"  # 
# echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default


#!/bin/bash

set -e

echo "========================================="
echo " DIY PART1 - Fix mac80211 / mt76"
echo "========================================="

# --------------------------------------------------
# 1. 禁止 diy-part1.sh 单独覆盖 mac80211 / mt76
# --------------------------------------------------
# 不要在这里 git clone 最新 mt76
# 不要单独替换 package/kernel/mac80211
#
# 必须使用当前 OpenWrt/ImmortalWrt 源码匹配的版本，
# 避免 mt76 与 mac80211-backport 版本不一致。
# --------------------------------------------------

echo "[1/4] Checking mac80211 / mt76 source..."

if [ -d package/kernel/mac80211 ]; then
    echo "mac80211 package exists."
else
    echo "ERROR: package/kernel/mac80211 not found!"
    exit 1
fi

if [ -d package/kernel/mt76 ]; then
    echo "mt76 package exists."
else
    echo "ERROR: package/kernel/mt76 not found!"
    exit 1
fi


# --------------------------------------------------
# 2. 清理旧的 mac80211-backport / mt76 编译残留
# --------------------------------------------------
echo "[2/4] Cleaning stale mac80211-backport files..."

rm -rf staging_dir/target-*/usr/include/mac80211-backport
rm -rf build_dir/target-*/linux-*/mt76-*
rm -rf build_dir/target-*/linux-*/mac80211-*
rm -rf build_dir/target-*/linux-*/backports-*

# 清除旧 package 状态
rm -f tmp/.packageinfo
rm -f tmp/.config-package.in
rm -f tmp/.targetinfo


# --------------------------------------------------
# 3. 确保 feeds/package 状态重新同步
# --------------------------------------------------
echo "[3/4] Updating package feeds..."

./scripts/feeds update -a
./scripts/feeds install -a


# --------------------------------------------------
# 4. 重新生成配置
# --------------------------------------------------
echo "[4/4] Regenerating OpenWrt configuration..."

make defconfig

echo "========================================="
echo " mac80211 / mt76 cleanup completed"
echo "========================================="
