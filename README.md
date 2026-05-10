# 🚀 华思飞 WH3000 路由器固件自动编译教程

> 小白友好版 · 一步一步跟着做就能成功 ✅

---

## 📋 目录结构说明

```
你的仓库/
├── .github/
│   └── workflows/
│       └── build-openwrt.yml   ← GitHub Actions 自动化脚本
├── optimized.config             ← 路由器编译配置文件（已优化）
├── diy-part1.sh                 ← 自定义脚本1（添加软件源）
├── diy-part2.sh                 ← 自定义脚本2（修改默认设置）
└── README.md                    ← 本教程
```

---

## 🔧 第一步：创建 GitHub 账号

1. 打开 https://github.com
2. 点击右上角 **Sign up**
3. 按提示注册账号（需要邮箱）
4. 完成邮箱验证

---

## 📁 第二步：创建你的仓库

1. 登录 GitHub 后，点击右上角 **"+"** 号
2. 选择 **"New repository"**（新仓库）
3. 填写信息：
   - **Repository name**（仓库名）：填 `openwrt-wh3000`（随意起名）
   - **Description**：可以填 `WH3000路由器固件`
   - 选择 **Public**（公开，免费用户必须选公开才能使用Actions）
   - ✅ 勾选 **"Add a README file"**
4. 点击绿色的 **"Create repository"** 按钮

---

## 📤 第三步：上传配置文件

把以下文件上传到你的仓库：

### 方法A：网页直接上传（推荐小白）

1. 在你的仓库页面，点击 **"Add file"** → **"Upload files"**
2. 把这几个文件拖进去：
   - `optimized.config`
   - `diy-part1.sh`  
   - `diy-part2.sh`
3. 点击 **"Commit changes"**（提交）

### 上传 GitHub Actions 工作流文件

这个文件需要放在特定目录：

1. 点击 **"Add file"** → **"Create new file"**
2. 在文件名框里输入：`.github/workflows/build-openwrt.yml`
   （注意：输入 `.github/` 后会自动创建目录）
3. 把 `build-openwrt.yml` 文件的**全部内容**粘贴进去
4. 点击 **"Commit new file"**

---

## ▶️ 第四步：手动触发编译

1. 在你的仓库页面，点击顶部的 **"Actions"** 标签
2. 左侧列表会看到 **"编译 OpenWrt 固件 (华思飞 WH3000)"**
3. 点击它，然后点右边的 **"Run workflow"**（运行工作流）
4. 弹出小框，直接点绿色 **"Run workflow"** 按钮
5. 页面刷新后会看到一个橙色圆圈 → 表示正在编译

> ⏰ **编译需要 1.5~3 小时**，请耐心等待！可以关闭网页，GitHub 在云端帮你编译。

---

## 📥 第五步：下载固件

编译成功后（绿色✅），有两种方式下载：

### 方式1：从 Releases 下载（推荐）
1. 仓库页面右侧找到 **"Releases"**
2. 点击最新的 Release
3. 下载 `.bin` 结尾的固件文件

### 方式2：从 Actions 下载
1. 点击 **"Actions"** → 点击已完成的那次编译
2. 下滑到底部 **"Artifacts"** 区域
3. 点击下载

---

## ❌ 常见问题

### Q: 编译失败，红色 ✗ 是怎么回事？
**A：** 点击失败的编译任务 → 展开 "编译固件" 步骤 → 查看错误信息。  
常见原因：软件源地址失效、磁盘空间不足（Actions免费空间有限）。

**快速解决：** 减少 `optimized.config` 里的包，特别是 Docker 相关包占用空间最大。

### Q: Actions 没有 Run workflow 按钮？
**A：** 确认仓库是 **Public**（公开），并且 `.github/workflows/` 目录结构正确。

### Q: 编译成功但固件刷不进去？
**A：** 确认下载了正确的文件（不是 `packages` 里的 `.ipk` 文件），
要下载 `targets` 目录下的 `.bin` 文件。

### Q: 管理页面还是不够快怎么办？
**A：** 登录路由器后，进入 **系统 → 启动项**，关闭你不用的服务。

---

## ✏️ 如何修改配置？

如果你想添加或删除功能包：

1. 在 GitHub 仓库页面点击 `optimized.config`
2. 点击右上角铅笔图标（编辑）
3. 找到对应的行修改：
   - `=y` → 表示启用
   - `# CONFIG_PACKAGE_xxx=y` → 表示禁用（注释掉）
4. 点击 **"Commit changes"** 保存
5. 再次手动触发 Actions 重新编译

---

## 🔔 已包含的功能清单

| 功能 | 说明 |
|------|------|
| ✅ Docker | 容器化应用（占空间大但保留） |
| ✅ Lucky | 内网穿透 + DDNS |
| ✅ Qmodem | 4G/5G 模块管理 |
| ✅ OpenVPN | VPN 服务端 |
| ✅ DDNS | 阿里云/DNSPod 动态域名 |
| ✅ Samba4 | Windows 网络共享 |
| ✅ 带宽监控 | 流量统计 |
| ✅ UPnP | 自动端口映射 |
| ✅ 磁盘管理 | 硬盘分区管理 |
| ✅ WOL | 网络唤醒电脑 |
| ❌ SSR-Plus | 已删除（减小体积，可后续安装） |
| ❌ Bootstrap主题 | 已删除（保留Design主题） |
| ❌ 英文语言包 | 已删除（保留中文） |

---

## 💡 提示

- 每次编译产生的固件都会保存在 **Releases** 里，方便回退版本
- 默认只保留最新 **5个** Release，旧的会自动删除
- GitHub Actions 每月有 **2000分钟** 免费额度（公开仓库无限制）
