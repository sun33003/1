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
echo " JCG Q30 / MT7981 LEDE DIY PART1"
echo " mac80211 / mt76 cleanup + feeds sync"
echo "========================================="

# 不要在这里单独 git clone 最新 mt76/mac80211。
# 必须保持当前 LEDE 源码中 mac80211 与 mt76 的版本匹配。

echo "[1/5] Check target packages..."
test -d package/kernel/mac80211
test -d package/kernel/mt76

echo "[2/5] Clean stale mac80211/mt76 build state..."
rm -rf staging_dir/target-*/usr/include/mac80211-backport
rm -rf build_dir/target-*/linux-*/mt76-*
rm -rf build_dir/target-*/linux-*/mac80211-*
rm -rf build_dir/target-*/linux-*/backports-*

# 清理旧 package index，避免旧状态影响重新生成
rm -f tmp/.packageinfo
rm -f tmp/.config-package.in
rm -f tmp/.targetinfo

echo "[3/5] Update feeds..."
./scripts/feeds update -a
./scripts/feeds install -a

echo "[4/5] Rebuild target configuration..."
make defconfig

echo "[5/5] Verify Q30 target..."
grep -q '^CONFIG_TARGET_mediatek_mt7981_DEVICE_jcg_q30=y$' .config

echo "========================================="
echo " DIY PART1 completed successfully"
echo " Target: JCG Q30 / MT7981"
echo "========================================="

