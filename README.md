# 🦅 Thunderbird Better Unread (Readable Cards)

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Thunderbird: 115+ (Supernova)](https://img.shields.io/badge/Thunderbird-115%2B%20(Supernova)-orange.svg)](https://www.thunderbird.net/)
[![Platform](https://img.shields.io/badge/Platform-Windows%20%7C%20macOS%20%7C%20Linux-lightgrey.svg)]()

> **Fix unread email visibility in Mozilla Thunderbird Cards View.**  
> 拯救 Mozilla Thunderbird（Supernova 及更新版本）卡片视图中“已读未读傻傻分不清”的糟糕默认体验。

---

[English](#english-overview) | [中文说明](#中文介绍)

---

## 📸 Preview / 效果对比

![Thunderbird Better Unread Preview](assets/preview.png)

| 状态 | 默认体验 (Default) | 打上补丁后 (With Better Unread) |
| :--- | :--- | :--- |
| **已读邮件 (Read)** | 同样粗黑，充斥整个视野 | 优雅降噪，半透明浅灰，去加粗 (`opacity: 0.68`) |
| **未读邮件 (Unread)** | 对比度不足，不易察觉 | 纯黑/高亮纯白，超粗体突出 (`font-weight: 800`) |

---

<a name="english-overview"></a>
## 🇬🇧 English Overview

### 💡 Why this exists
Since the release of **Mozilla Thunderbird 115 (Supernova)**, the default **Cards View** displays both unread and read emails with identical heavy fonts, dark colors, and visual weights. When scanning through dozens of emails, it's exhausting to tell which ones still need attention.

**Thunderbird Better Unread** provides an ultra-lightweight, zero-overhead CSS theme patch via `userChrome.css` that instantly restores intuitive visual hierarchy:
- **Unread emails**: Highlighted with heavy bold weight and crisp high contrast.
- **Read emails**: Subtly dimmed with soft gray tones and gentle opacity.
- **Dark Mode & Light Mode**: Seamlessly adapts to your OS theme.
- **Table View Compatible**: Also optimizes the classic table view.

---

### 🚀 Quick Start (Automated Installation)

#### Windows
1. Download or clone this repository.
2. Double-click **`scripts/install.bat`**.
3. Restart Thunderbird.

#### macOS / Linux
1. Clone this repository:
   ```bash
   git clone https://github.com/santiago0071/thunderbird-better-unread.git
   cd thunderbird-better-unread
   ```
2. Run the install script:
   ```bash
   chmod +x scripts/install.sh
   ./scripts/install.sh
   ```
3. Restart Thunderbird.

---

### 🛠️ Manual Installation

If you prefer not to use scripts:

1. In Thunderbird, open **Settings** (`≡` menu -> **Settings**) -> **General**.
2. Scroll to the bottom and click **Config Editor...** (or search for `about:config`).
3. Search for:
   ```text
   toolkit.legacyUserProfileCustomizations.stylesheets
   ```
   Toggle it to **`true`**.
4. Go to **Help** -> **Troubleshooting Information**.
5. Under the **Application Basics** section, find **Profile Folder** (or Profile Directory) and click **Open Folder** / **Show in Finder**.
6. Inside your profile folder, create a new folder named `chrome` (all lowercase) if it doesn't already exist.
7. Copy [`chrome/userChrome.css`](chrome/userChrome.css) from this repo into that `chrome` folder.
8. Restart Thunderbird.

---

<a name="中文介绍"></a>
## 🇨🇳 中文介绍

### 💡 痛点背景
Mozilla Thunderbird 升级至 115（Supernova 架构）并采用全新的**卡片视图（Cards View）**后，许多用户面临一个共同的视觉折磨：**已读和未读邮件的发件人、主题文字粗细与颜色几乎无差，满屏都是大粗体，扫一眼极难快速定位未读邮件**。

本项目通过极简纯净的 `userChrome.css` 样式规则，重塑直观的层级分界：
- **未读邮件**：加粗高对比度（800 字重），一眼直达；
- **已读邮件**：柔和灰阶 + 适度半透明降噪，弱化视觉干扰；
- **自适应深浅色**：原生兼容系统浅色模式（Light Mode）与深色模式（Dark Mode）；
- **全兼容**：同时优化卡片视图（Cards View）与经典表格视图（Table View）。

---

### 🚀 一键极速安装

#### Windows 用户
1. 下载或克隆本项目压缩包并解压。
2. 双击运行 **`scripts/install.bat`**。
3. 按照提示重启 Thunderbird 即可！
   *(脚本会自动探测你的配置目录，拷贝 CSS 并写入 `user.js` 启用样式支持)*

#### macOS / Linux 用户
1. 打开终端克隆本项目：
   ```bash
   git clone https://github.com/santiago0071/thunderbird-better-unread.git
   cd thunderbird-better-unread
   ```
2. 执行安装脚本：
   ```bash
   chmod +x scripts/install.sh
   ./scripts/install.sh
   ```
3. 重启 Thunderbird 即可享受清晰舒适的邮件列表！

---

### 🛠️ 手动安装指南

如果你想手动把控配置：

1. 打开 Thunderbird，点击右上角菜单 `≡` -> **设置 (Settings)** -> **常规 (General)**；
2. 滑到最底部，点击 **配置编辑器... (Config Editor...)**；
3. 搜索首选项：
   ```text
   toolkit.legacyUserProfileCustomizations.stylesheets
   ```
   双击将其切换为 **`true`**；
4. 点击顶部菜单 **帮助 (Help)** -> **故障排除信息 (Troubleshooting Information)**；
5. 在“应用程序基本信息”表格中找到 **配置文件夹 (Profile Folder)**，点击其右侧的 **打开文件夹**；
6. 在弹出的配置文件夹内，新建一个名为 `chrome` 的文件夹（注意全小写）；
7. 将本项目中的 [`chrome/userChrome.css`](chrome/userChrome.css) 放入 `chrome` 文件夹中；
8. 重启 Thunderbird 即可生效。

---

### ❓ 常见问题排查 (FAQ)

<details>
<summary><b>1. 重启后样式没有发生任何变化？</b></summary>

- **检查首选项**：确保 `toolkit.legacyUserProfileCustomizations.stylesheets` 的值确实为 `true`。
- **检查文件路径**：确认 `userChrome.css` 放置在正确的 Profile 目录下的 `chrome/` 子文件夹内。
- **Windows 扩展名陷阱**：在 Windows 下如果开启了“隐藏已知文件扩展名”，新建文件很容易变成 `userChrome.css.txt`。请务必确认后缀名为 `.css`。
</details>

<details>
<summary><b>2. 如何卸载或恢复默认样式？</b></summary>

只需进入你的 Profile 文件夹，删除 `chrome/userChrome.css`（或删除整个 `chrome` 目录），然后重启 Thunderbird 即可立刻恢复官方默认外观。
</details>

---

## 📄 License

本项目采用 [MIT License](LICENSE) 开源许可证。
欢迎 Star ⭐️ 与 PR 贡献！
