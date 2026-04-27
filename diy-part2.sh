#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# 1. 【核心修复】强制升级 Golang 环境到 1.24+
# 这是解决 "requires go >= 1.24" 的根本办法
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang feeds/packages/lang/golang

# 2. 【核心修复】彻底物理删除 small 源里的 v2dat (防止它干扰编译)
# 因为 sbwml 的 mosdns 依赖会自动处理相关的数据文件，不需要 small 源里的旧包
rm -rf feeds/small/v2dat
rm -rf feeds/small/luci-app-mosdns
rm -rf feeds/small/mosdns

# 3. 清理残留的物理文件夹，防止 Exit 128
rm -rf package/mosdns
rm -rf package/v2ray-geodata
rm -rf package/netspeedtest

# 4. 重新拉取你指定的精准源码
git clone https://github.com/sbwml/luci-app-mosdns -b v5 package/mosdns
git clone https://github.com/sbwml/v2ray-geodata package/v2ray-geodata
git clone https://github.com/muink/luci-app-netspeedtest.git package/netspeedtest

# 5. 注入编译配置
echo "CONFIG_PACKAGE_luci-app-turboacc=y" >> .config
echo "CONFIG_PACKAGE_luci-app-turboacc_INCLUDE_OFFLOADING=y" >> .config

# 6. 设置编译时间标识
sed -i "s/OpenWrt /Lian-Liu-Build-$(date +%Y-%m-%d) /g" package/base-files/files/etc/banner
