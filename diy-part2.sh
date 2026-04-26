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

# 2. 彻底禁用/清理 small 源及官方 feeds 中的冲突插件
# 这样做是为了确保系统“看不见”这些地方的 MosDNS
rm -rf feeds/small/mosdns
rm -rf feeds/small/luci-app-mosdns
rm -rf feeds/packages/net/mosdns
rm -rf feeds/luci/applications/luci-app-mosdns
rm -rf feeds/packages/net/v2ray-geodata

# 3. 强制删除 package 目录下的旧目录（解决之前 Exit 128 的报错）
rm -rf package/mosdns
rm -rf package/v2ray-geodata
rm -rf package/netspeedtest

# --- 1. 物理删除：清理订阅源和 feeds 里的同名项 ---
rm -rf feeds/small/luci-app-netspeedtest
rm -rf feeds/small/netspeedtest
rm -rf feeds/luci/applications/luci-app-netspeedtest
rm -rf package/netspeedtest

# 4. 重新下载你指定的精准源码
# 这里下载的源码会存放在 package/ 目录下，优先级最高
git clone https://github.com/sbwml/luci-app-mosdns -b v5 package/mosdns
git clone https://github.com/sbwml/v2ray-geodata package/v2ray-geodata
git clone https://github.com/muink/luci-app-netspeedtest.git package/netspeedtest

# 5. 额外建议：如果 mosdns 报错，通常是因为 golang 版本不对
# 可以尝试屏蔽掉 feeds 里的 golang，强制编译使用最新版（可选）
# rm -rf feeds/packages/lang/golang

# 6. 额外建议：针对 24.10 的 Firewall4 优化
# 确保在编译时默认开启一些网络加速特性
echo "CONFIG_PACKAGE_luci-app-turboacc=y" >> .config
echo "CONFIG_PACKAGE_luci-app-turboacc_INCLUDE_OFFLOADING=y" >> .config

# 5. 设置编译时间标识 (显示在后台页面)
sed -i "s/OpenWrt /Lian-Liu-Build-$(date +%Y-%m-%d) /g" package/base-files/files/etc/banner
git clone https://github.com/muink/luci-app-netspeedtest.git package/netspeedtest
