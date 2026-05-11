#!/bin/bash
# =====================================================
# DIY 脚本第二部分：自定义路由器默认设置 (适用于 Lean's LEDE)
# =====================================================

# =====================================================
# ★ 1. 从 ImmortalWrt 移植 luci-theme-design 主题
# =====================================================
echo "正在添加 Design 主题..."
THEME_DIR="package/luci-theme-design"
mkdir -p $THEME_DIR
git clone --depth=1 --single-branch --branch openwrt-24.10 \
  https://github.com/immortalwrt/luci.git temp_luci_design
cp -r temp_luci_design/themes/luci-theme-design/* $THEME_DIR/
sed -i 's|../../luci.mk|$(TOPDIR)/feeds/luci/luci.mk|g' $THEME_DIR/Makefile 2>/dev/null || true
rm -rf temp_luci_design
echo "Design 主题已植入"

# =====================================================
# ★ 2. 修改路由器主机名
# =====================================================
sed -i 's/OpenWrt/WH3000/g' package/base-files/files/bin/config_generate

# =====================================================
# ★ 3. 修改默认主题为 Design（LEDE 标准 luci 集合包）
# =====================================================
if [ -f "feeds/luci/collections/luci/Makefile" ]; then
    sed -i 's/luci-theme-bootstrap/luci-theme-design/g' feeds/luci/collections/luci/Makefile
fi

# =====================================================
# ★ 4. 创建默认无线配置（确保刷机后 Wi-Fi 自动开启）
# =====================================================
mkdir -p files/etc/config
cat > files/etc/config/wireless << 'EOF'
config wifi-device 'radio0'
        option type 'mac80211'
        option channel 'auto'
        option band '2g'
        option htmode 'HT20'
        option disabled '0'

config wifi-iface 'default_radio0'
        option device 'radio0'
        option network 'lan'
        option mode 'ap'
        option ssid 'WH3000-栋仔'
        option encryption 'psk2'
        option key '1234567890'
EOF

# =====================================================
# ★ 5. 提升 rpcd 超时（防止管理界面操作超时）
# =====================================================
mkdir -p files/etc/config
if [ ! -f files/etc/config/rpcd ]; then
cat > files/etc/config/rpcd << 'EOF'
config rpcd
    option socket /var/run/ubus/ubus.sock
    option timeout 60
EOF
fi

# =====================================================
# ★ 6. 栋仔专属 Banner
# =====================================================
cat > files/etc/banner << 'EOF'
██╗██████╗  █████╗ ███╗   ██╗  ██████╗
██║██╔══██╗██╔══██╗████╗  ██║ ██╔════╝
██║██║  ██║███████║██╔██╗ ██║ ██║
██║██║  ██║██╔══██║██║╚██╗██║ ██║
██║██████╔╝██║  ██║██║ ╚████║ ╚██████╗
╚═╝╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝  ╚═════╝

      栋仔·路由器 | LEDE | $(date +%Y)
-------------------------------------------------
EOF

# ★ 注意：不再手动生成 uhttpd 配置，交给 LEDE 的 luci-base 自动处理
echo "✅ DIY 设置完成"
echo "   - Design 主题已植入并设为默认"
echo "   - 无线默认开启 (SSID: WH3000-栋仔)"
echo "   - uhttpd 使用 LEDE 标准配置，杜绝 Web 404"
