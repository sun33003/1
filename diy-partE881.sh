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
# ❗ 修复 default-settings 冲突（通用）
rm -rf package/lean/default-settings
rm -rf package/emortal/default-settings 2>/dev/null

# Add a feed source
sed -i "/helloworld/d" "feeds.conf.default"  
echo "src-git helloworld https://github.com/fw876/helloworld.git" >> "feeds.conf.default" 
