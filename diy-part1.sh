#!/bin/bash
# =====================================================
# DIY 脚本第一部分：添加自定义软件源 (适用于 Lean's LEDE)
# =====================================================

# 添加 Lucky 软件源
echo "src-git lucky https://github.com/gdy666/luci-app-lucky.git" >> feeds.conf.default

# 添加 Qmodem 软件源
echo "src-git qmodem https://github.com/FUjr/modem_feeds.git;main" >> feeds.conf.default

# 添加 rtp2httpd 软件源（IPTV 组播转单播）
echo "src-git rtp2httpd https://github.com/stackia/rtp2httpd.git" >> feeds.conf.default

# LEDE 自带源丰富，Design 主题将在 diy-part2 手动植入

echo "✅ 软件源添加完成"
