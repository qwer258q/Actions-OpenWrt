#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Modify default IP
sed -i 's/192.168.1.1/192.168.31.1/g' package/base-files/files/bin/config_generate

# Modify default theme
#sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# Modify hostname
#sed -i 's/OpenWrt/P3TERX-Router/g' package/base-files/files/bin/config_generate

# 2. 【核心步骤】删除所有可能冲突的 feeds 索引
# 这能确保编译系统不会因为“发现两个同名插件”而困惑
rm -rf feeds/small/mosdns
rm -rf feeds/small/luci-app-mosdns
rm -rf feeds/small/netspeedtest
rm -rf feeds/small/luci-app-netspeedtest
rm -rf feeds/luci/applications/luci-app-mosdns
rm -rf feeds/packages/net/mosdns

# 3. 【核心步骤】删除已经存在的物理文件夹
# 这一步彻底解决你图片里的 Exit code 128 报错
rm -rf package/mosdns
rm -rf package/v2ray-geodata
rm -rf package/netspeedtest

# 4. 重新拉取你指定的精准源码
git clone https://github.com/sbwml/luci-app-mosdns -b v5 package/mosdns
git clone https://github.com/sbwml/v2ray-geodata package/v2ray-geodata
git clone https://github.com/muink/luci-app-netspeedtest.git package/netspeedtest

# 6. 额外建议：针对 24.10 的 Firewall4 优化
# 确保在编译时默认开启一些网络加速特性
echo "CONFIG_PACKAGE_luci-app-turboacc=y" >> .config
echo "CONFIG_PACKAGE_luci-app-turboacc_INCLUDE_OFFLOADING=y" >> .config

# 5. 设置编译时间标识 (显示在后台页面)
sed -i "s/OpenWrt /Lian-Liu-Build-$(date +%Y-%m-%d) /g" package/base-files/files/etc/banner
git clone https://github.com/muink/luci-app-netspeedtest.git package/netspeedtest
