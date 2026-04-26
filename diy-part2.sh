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

# 3. 暴力清理：不管有没有，先通通删一遍
# 增加 -f 强制删除，不提示错误
rm -rf feeds/small/mosdns feeds/small/luci-app-mosdns feeds/small/netspeedtest feeds/small/luci-app-netspeedtest
rm -rf feeds/luci/applications/luci-app-mosdns feeds/packages/net/mosdns
rm -rf feeds/luci/applications/luci-app-netspeedtest

# 4. 解决 Exit 128 的核心：物理抹除 package 目录
# 确保在 git clone 前，这三个文件夹绝对不存在
rm -rf package/mosdns
rm -rf package/v2ray-geodata
rm -rf package/netspeedtest

# 5. 重新拉取
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
