#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh

# 1. 修改默认 IP
sed -i 's/192.168.1.1/192.168.31.1/g' package/base-files/files/bin/config_generate

# 2. 暴力清理：不管有没有，先通通删一遍
rm -rf feeds/small/mosdns feeds/small/luci-app-mosdns feeds/small/netspeedtest feeds/small/luci-app-netspeedtest
rm -rf feeds/luci/applications/luci-app-mosdns feeds/packages/net/mosdns
rm -rf feeds/luci/applications/luci-app-netspeedtest

# 3. 物理抹除 package 目录 (解决 Exit 128 的核心)
rm -rf package/mosdns
rm -rf package/v2ray-geodata
rm -rf package/netspeedtest

# 4. 重新拉取精准源码 (注意：每样只拉一次！)
git clone https://github.com/sbwml/luci-app-mosdns -b v5 package/mosdns
git clone https://github.com/sbwml/v2ray-geodata package/v2ray-geodata
git clone https://github.com/muink/luci-app-netspeedtest.git package/netspeedtest

# 5. 注入编译配置
echo "CONFIG_PACKAGE_luci-app-turboacc=y" >> .config
echo "CONFIG_PACKAGE_luci-app-turboacc_INCLUDE_OFFLOADING=y" >> .config

# 6. 设置编译时间标识
sed -i "s/OpenWrt /Lian-Liu-Build-$(date +%Y-%m-%d) /g" package/base-files/files/etc/banner
