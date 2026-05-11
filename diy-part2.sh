#!/bin/bash
# =====================================================
# DIY 脚本第二部分：只做三件事
# 1. 植入 Design 主题
# 2. 修改主机名、默认主题
# 3. 栋仔 Banner
# 其余全部使用 LEDE 默认，确保固件绝对稳定
# =====================================================

# 1. 植入主题
echo "正在添加 Design 主题..."
THEME_DIR="package/luci-theme-design"
mkdir -p $THEME_DIR
git clone --depth=1 --single-branch --branch openwrt-24.10 \
  https://github.com/immortalwrt/luci.git temp_luci_design
cp -r temp_luci_design/themes/luci-theme-design/* $THEME_DIR/
sed -i 's|../../luci.mk|$(TOPDIR)/feeds/luci/luci.mk|g' $THEME_DIR/Makefile 2>/dev/null || true
rm -rf temp_luci_design
echo "Design 主题已植入"

# 2. 修改主机名
sed -i 's/OpenWrt/WH3000/g' package/base-files/files/bin/config_generate

# 3. 修改默认主题为 Design
if [ -f "feeds/luci/collections/luci/Makefile" ]; then
    sed -i 's/luci-theme-bootstrap/luci-theme-design/g' feeds/luci/collections/luci/Makefile
fi

# 4. 栋仔 Banner（仅此个性化）
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

echo "✅ DIY 设置完成（最小化干预，固件稳定优先）"
