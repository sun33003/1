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
# sed -i "/helloworld/d" "feeds.conf.default"  # 
# echo "src-git helloworld https://github.com/fw876/helloworld.git" >> "feeds.conf.default"  # 
# echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default


#!/bin/bash
set -e

echo "=========================================="
echo " JCG Q30 / MT7981 LEDE 精简稳定版"
echo " LuCI + SSR Plus + Xray + Trojan + Hysteria2"
echo " IPv6 + Wi-Fi"
echo "=========================================="

# 1. Do NOT independently replace the latest mt76/mac80211.
# Keep them version-matched with the selected LEDE tree.
test -d package/kernel/mac80211
test -d package/kernel/mt76

# 2. Clear stale backport/mt76 build artifacts.
echo "[1/5] Cleaning stale mac80211 / mt76 state..."
rm -rf staging_dir/target-*/usr/include/mac80211-backport
rm -rf build_dir/target-*/linux-*/mt76-*
rm -rf build_dir/target-*/linux-*/mac80211-*
rm -rf build_dir/target-*/linux-*/backports-*

rm -f tmp/.packageinfo
rm -f tmp/.config-package.in
rm -f tmp/.targetinfo

# 3. Add SSR Plus feed only when it is not already present.
echo "[2/5] Checking SSR Plus feed..."
if ! grep -qE '(^|[[:space:]])src-git[[:space:]]+helloworld[[:space:]]' feeds.conf.default 2>/dev/null; then
    echo 'src-git helloworld https://github.com/fw876/helloworld.git' >> feeds.conf.default
fi

# 4. Update/install feeds.
echo "[3/5] Updating feeds..."
./scripts/feeds update -a
./scripts/feeds install -a -f -p helloworld

# 5. Re-resolve Kconfig and verify target.
echo "[4/5] Running defconfig..."
make defconfig

echo "[5/5] Verifying JCG Q30 target..."
grep -q '^CONFIG_TARGET_mediatek_mt7981_DEVICE_jcg_q30=y$' .config

echo "=========================================="
echo " Q30 LEDE 精简稳定版配置完成"
echo " SSR Plus: Xray / Trojan / Hysteria2"
echo " IPv6: enabled"
echo " Wi-Fi: MT7981"
echo "=========================================="
