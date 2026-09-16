#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# Modify default IP
sed -i 's/192.168.1.1/192.168.88.1/g' package/base-files/files/bin/config_generate



# =========================================================
# 修复 mt76 编译缺失 mac80211/autoconf.h 的依赖问题
# =========================================================

# 1. 强制在 mt76 的 Makefile 中追加对 mac80211 的显式编译依赖
MT76_MAKEFILE="package/kernel/mt76/Makefile"
if [ -f "$MT76_MAKEFILE" ]; then
    echo "Fixing mt76 compilation order dependency..."
    # 确保 PKG_BUILD_DEPENDS 包含 mac80211
    if grep -q "PKG_BUILD_DEPENDS" "$MT76_MAKEFILE"; then
        sed -i 's/PKG_BUILD_DEPENDS:=/PKG_BUILD_DEPENDS:=mac80211 /g' "$MT76_MAKEFILE"
    else
        sed -i '/define KernelPackage\/mt76/a \  PKG_BUILD_DEPENDS:=mac80211' "$MT76_MAKEFILE"
    fi
fi
