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
# 可选：设置默认IP
sed -i 's/192.168.6.1/192.168.222.1/g' package/base-files/files/bin/config_generate

# ❗ 修复 default-settings 冲突（通用）
rm -rf package/lean/default-settings
rm -rf package/emortal/default-settings 2>/dev/null

# Add a feed source
sed -i "/helloworld/d" "feeds.conf.default"   # 
echo "src-git helloworld https://github.com/fw876/helloworld.git" >> "feeds.conf.default"   # 

# 1. 移除当前源码中存在兼容性问题的 mac80211 包
rm -rf package/kernel/mac80211

# 2. 从已知稳定的分支/仓库拉取兼容的 mac80211 包（替换为稳定版本）
# 例如：从 immortalwrt/immortalwrt 的 23.05 或特定分支提取 mac80211
git clone --depth 1 -b openwrt-23.05 https://github.com/immortalwrt/immortalwrt.git temp_repo
cp -r temp_repo/package/kernel/mac80211 package/kernel/
rm -rf temp_repo
