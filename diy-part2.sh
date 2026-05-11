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
# 下载主题源码
git clone --depth=1 --single-branch --branch openwrt-24.10 \
  https://github.com/immortalwrt/luci.git temp_luci_design
cp -r temp_luci_design/themes/luci-theme-design/* $THEME_DIR/
# 修正 Makefile 中的路径引用
sed -i 's|../../luci.mk|$(TOPDIR)/feeds/luci/luci.mk|g' $THEME_DIR/Makefile 2>/dev/null || true
rm -rf temp_luci_design
echo "Design 主题已植入"

# =====================================================
# ★ 2. 修改路由器主机名
# =====================================================
sed -i 's/OpenWrt/WH3000/g' package/base-files/files/bin/config_generate

# =====================================================
# ★ 3. 修正默认主题为 Design
# =====================================================
if [ -f "feeds/luci/collections/luci/Makefile" ]; then
    sed -i 's/luci-theme-bootstrap/luci-theme-design/g' feeds/luci/collections/luci/Makefile
fi

# =====================================================
# ★ 4. uhttpd 配置：Lua 后端 + 性能优化
# =====================================================
mkdir -p files/etc/config
cat > files/etc/config/uhttpd << 'EOF'
config uhttpd main
    list listen_http  0.0.0.0:80
    list listen_http  [::]:80
    list listen_https 0.0.0.0:443
    list listen_https [::]:443

    option max_requests     10
    option max_connections  100

    option cert           /etc/uhttpd.crt
    option key            /etc/uhttpd.key

    option http_keepalive 20
    option script_timeout 60
    option network_timeout 30
    option tcp_fastopen   1

    option ubus_prefix    /ubus

    # 使用稳定 Lua 后端
    list lua_prefix        /cgi-bin/luci
    option lua_handler     /usr/lib/lua/luci/uvcgi.lua
EOF

# =====================================================
# ★ 5. 提升 rpcd 超时
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

echo "✅ DIY 设置完成"
echo "   - 已植入 luci-theme-design"
echo "   - Web 管理使用 Lua 后端，稳定秒开"
echo "   - 栋仔专属 Banner 已就绪"
