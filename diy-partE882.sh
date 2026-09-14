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
sed -i 's/192.168.1.1/192.168.222.1/g' package/base-files/files/bin/config_generate


# 1. 隐藏 usteer 前端 Status 和 Map 标签页
find feeds/package/ package/ -path "*/luci-app-usteer/*" \( -name "*.js" -o -name "*.htm" -o -name "*.lua" \) -exec sed -i \
  -e "s/m.tab('status'/\\/\\/ m.tab('status'/g" \
  -e "s/m.tab('map'/\\/\\/ m.tab('map'/g" \
  -e "s/m.tab('overview'/\\/\\/ m.tab('overview'/g" \
  -e "s/s.tab('status'/-- s.tab('status'/g" \
  -e "s/s.tab('map'/-- s.tab('map'/g" {} +

# 2. 预设 usteer 的默认漫游参数（踢出值、入值、引导策略）
mkdir -p package/base-files/files/etc/uci-defaults
cat << 'EOF' > package/base-files/files/etc/uci-defaults/99-usteer-custom
#!/bin/sh

uci batch <<UCI_EOF
set usteer.@usteer[0].enabled='1'
set usteer.@usteer[0].network='lan'

# 信号阈值配置 (SNR 增益值)
set usteer.@usteer[0].min_snr='15'
set usteer.@usteer[0].roam_trigger_snr='20'
set usteer.@usteer[0].roam_kick_snr='12'

# 漫游引导与响应控制
set usteer.@usteer[0].roam_scan_snr='22'
set usteer.@usteer[0].load_kick_enabled='0'
set usteer.@usteer[0].steer_response_timeout='5000'

commit usteer
UCI_EOF

exit 0
EOF

chmod +x package/base-files/files/etc/uci-defaults/99-usteer-custom
