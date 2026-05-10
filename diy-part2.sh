#!/bin/bash
# =====================================================
# DIY 脚本第二部分：在 feeds install 之后执行
# 主要用途：自定义路由器默认设置
# =====================================================

# =====================================================
# ★ 修改路由器默认 IP 地址
# 默认是 192.168.1.1，如果你的主路由也是 192.168.1.1
# 建议改成 192.168.2.1 避免冲突
# =====================================================
sed -i 's/192.168.1.1/192.168.1.1/g' package/base-files/files/bin/config_generate
# 如需修改，取消注释下面这行（改成你想要的IP）：
# sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate

# =====================================================
# ★ 修改路由器主机名
# =====================================================
sed -i 's/OpenWrt/WH3000/g' package/base-files/files/bin/config_generate

# =====================================================
# ★ 修改默认主题为 Design
# =====================================================
# 设置 LuCI 默认主题
if [ -f "feeds/luci/collections/luci/Makefile" ]; then
    sed -i 's/luci-theme-bootstrap/luci-theme-design/g' feeds/luci/collections/luci/Makefile
fi

# =====================================================
# ★ uhttpd Web服务器优化（让管理页面秒开的关键）
# =====================================================
# 这部分通过修改 uhttpd 配置文件实现
mkdir -p files/etc/config
cat > files/etc/config/uhttpd << 'EOF'
config uhttpd main
    # 监听地址和端口
    list listen_http  0.0.0.0:80
    list listen_http  [::]:80
    list listen_https 0.0.0.0:443
    list listen_https [::]:443

    # ★ 关键优化：增加工作进程数，提升并发处理能力
    option max_requests     10
    option max_connections  100

    # SSL 证书（自签名）
    option cert           /etc/uhttpd.crt
    option key            /etc/uhttpd.key

    # 开启 HTTP/1.1 keep-alive
    option http_keepalive 20

    # Lua 脚本超时时间（秒）
    option script_timeout 60

    # 网络超时
    option network_timeout 30

    # 开启 TCP_FASTOPEN（更快的TCP连接）
    option tcp_fastopen   1

    # ubus API 路径
    option ubus_prefix    /ubus
EOF

# =====================================================
# ★ 提升 rpcd 超时（避免管理界面超时）
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
# 修改默认 Banner（可选，好玩）
# =====================================================
cat > files/etc/banner << 'EOF'
  ___        _____  __  ___  ___  ___  ___ 
 / _ \ _ __ | __\ \/ / / _ \| _ \/ _ \| _ \
| (_) | '_ \| _| >  < | (_) |  _/  __/|   /
 \___/| .__/|___/_/\_\ \___/|_|  \___||_|_\
      |_|
 华思飞 WH3000 | ImmortalWrt | $(date +%Y)
-------------------------------------------------
EOF

echo "✅ DIY 设置完成"
echo "   - 主机名: WH3000"
echo "   - 默认主题: luci-theme-design"
echo "   - uhttpd 已优化"
