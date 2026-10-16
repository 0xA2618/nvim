# ndev (Neovim IDE Workspace)

基于 Neovim v0.11+ 打造的现代化、AI 增强型极速开发工作区（IDE）。

原生融合：
- **左侧全高目录树**（NvimTree，固定 30 列，带当前路径实时预览与一键复制）；
- **右上方代码编辑区**（全功能 LSP 代码补全、定义跳转、格式化、Buffer 智能标签管理）；
- **右下方 AI 对话终端**（OpenCode 终端对话流，随启动自动就绪，不干扰主代码编辑）；
- **全场景 Markdown 预览与思维导图**（支持当前 Buffer 原地富文本渲染、Markmap 思维导图、以及具备左侧层级大纲可折叠展开并自适应 macOS 深浅色外观的浏览器实时预览）。

---

## 目录结构 (Architecture)

```text
+-------------------+-----------------------------------+
|                   |                                   |
|                   |          文件编辑主体              |
|                   |          (Buffer / Code)          |
|     左侧目录树     |                                   |
|   (自顶向下贯通)   +-----------------------------------+
|   (nvim-tree)     |      opencode 对话窗口             |
|   (固定 30 列)    |      (右下 32% 终端交互区)         |
+-------------------+-----------------------------------+
```

项目配置树：
```text
~/.config/nvim
├── init.lua                          # 入口文件
├── lua
│   ├── basic.lua                     # 基础系统配置 (编码、缩进、剪贴板等)
│   ├── colorscheme.lua               # 主题方案 (Gruvbox + 渲染背景自动同步)
│   ├── keymappings.lua               # 统一键盘快捷键映射与导航
│   ├── layout.lua                    # 三栏自动布局引擎、智能分屏与窗口防破坏保护
│   ├── plugins.lua                   # 插件清单与包管理器启动配置
│   ├── lsp
│   │   ├── cmp.lua                   # 代码补全引擎与源扩展
│   │   ├── dap.lua                   # 调试适配器基础配置
│   │   ├── setup.lua                 # 现代 LSP 服务配置 (基于 Neovim 0.11 vim.lsp.config)
│   │   └── ui.lua                    # LSP 视觉弹窗样式
│   └── plugin-config
│       ├── autopairs.lua             # 括号与引号自动闭合
│       ├── browser_preview.js        # 浏览器端实时 Markdown 预览服务 (内置可折叠 TOC 大纲)
│       ├── bufferline.lua            # 顶部优雅 Buffer 标签栏
│       ├── dashboard.lua             # 欢迎仪表盘面板
│       ├── git-signs.lua             # Git 状态行边栏指示器
│       ├── highlight.lua             # 高亮辅助配置
│       ├── lspsaga.lua               # 现代 LSP 弹窗与动作优化
│       ├── lualine.lua               # 底部状态栏 (自适应主题)
│       ├── markdown.lua              # Markdown 专属选择器与原地渲染引擎
│       ├── markdown_toc.css          # 浏览器预览大纲层级样式
│       ├── nvim-tree.lua             # 目录树强化 (Window Picker 排除终端、路径复制)
│       ├── nvim-treesitter.lua       # 现代语法高亮解析树
│       ├── python.lua                # Python 专用配置与调试
│       ├── rust_analyzer.lua         # Rust 分析器配置
│       └── telescope.lua             # 模糊搜索文件与代码
└── plugin
    └── packer_compiled.lua           # 编译后的高性能加载缓存
```

---

## 核心新特性 (Key Features)

### 1. 三栏智能工作区自启动 (`layout.lua`)
- 执行 `nvim .` 打开目录，光标**直接落在左侧目录树的第一个项目上**，右下角已准备好 `opencode`，右上角预留清晰编辑区；
- 执行 `nvim <filename>`，光标直接落入右上方正文编辑；
- **智能防挤压保护**：关闭当前最后一个打开的文件时，右上编辑窗口保留空白占位，**底部的 `opencode` 绝不会向上膨胀占满屏幕**。

### 2. 目录树路径感知与复制 (`nvim-tree.lua`)
- **底部实时路径**：在左侧树移动光标，屏幕最底部实时显示当前文件/文件夹的完整绝对路径；
- **`yyp` 一键复制**：光标停在任意文件/文件夹上按 `yyp`，路径立刻存入系统剪贴板（`+` 寄存器），外部软件直接 `Cmd+V` 粘贴。

### 3. 多 Buffer 标签页智能关闭与流转
- 按 **`qq`** 或 **`q`**：关闭当前文件并**彻底移除顶部对应的标签页**，当前窗口自动展示上一个已打开的文件；
- 避免了普通 `:q` 造成的“只关窗口留存 Buffer”或打乱三栏分屏布局的问题。

### 4. 专属 Markdown 打开模式 (`Shift + M`)
在左侧目录树中的任意 `.md` 文件上按 **`Shift+M`**（或键入 `M`），居中弹出高亮菜单（支持 `j`/`k` 移动、回车选择）：
```text
╭────────── 打开方式: README.md ──────────╮
│  1. Markdown Preview Enhanced           │
│  2. Markmap                             │
│  3. Browser                             │
╰─────────────────────────────────────────╯
```
- **1. Markdown Preview Enhanced**：
  - 直接在 Neovim **当前 Buffer 内原地完成富文本美化**（标题前缀、代码块框线、表格对齐框、复选框）；
  - **各级标题背景色严格与标题文字长度一致**，不拖沓多余色带；
  - **支持无缝编辑**：随时按 `i` / `o` / `a` 原地编辑，光标离开后自动重新渲染。
- **2. Markmap**：
  - 临时沙盒运行并在浏览器弹出交互式折叠/展开思维导图，**项目目录绝不残留任何 `.html` 文件**。
- **3. Browser**：
  - 自动感应 **macOS 白天/黑夜外观模式**，背景色与高亮瞬间自动匹配；
  - **左侧附带层级目录大纲（TOC）**，支持多级折叠展开与点击平滑定位，左上角支持一键隐藏侧边栏；
  - **刷新绝无 404**：按 `Cmd+R` 永远秒速重载，且在 Neovim 保存文件时浏览器通过 SSE 自动热重载。

---

## 常用快捷键速查 (Cheatsheet)

| 快捷键 | 作用区域 | 功能说明 |
| :--- | :--- | :--- |
| **`j` / `k`** | 全局 | 光标上下移动 |
| **`<C-h>`** / **`<Tab>h`** | 编辑区 / 目录树 | 切换至左侧窗口（目录树） |
| **`<C-l>`** | 全局 | **全屏重绘刷新**（误按 Cmd+R 屏幕变空后，按此瞬间恢复整屏） |
| **`<Tab>l`** | 目录树 / 编辑区 | 切换至右侧窗口（编辑区） |
| **`<C-j>`** / **`<Tab>j`** | 编辑区 | 跳入右下方 `opencode` 终端 |
| **`<Esc><Esc>`** | 终端模式 | 退出终端输入模式，随后按 `<C-k>` 跳回代码区 |
| **`<Space>dl`** | 全局 | 一键重建标准三栏工作区布局 |
| **`tr`** | 全局 | 一键隐藏 / 打开左侧目录树结构 |
| **`<Space>oc`** | 全局 | 一键隐藏 / 重新唤起右下方 `opencode` 窗口（保持会话历史） |
| **`<C-~>`** | 全局 | VS Code 同款终端快速收起/展开快捷键 |
| **`<F1>`** / **`<Space>p`** | 全局 | VS Code 风格命令面板（含 Window: Reload Window 瞬间恢复） |
| **`<Space>th`** | 全局 | 动态交互式主题选择器（光标 j/k 移动实时联动全屏变色） |
| **`M`** | 左侧目录树 | 打开 Markdown 模式选择菜单 (MPE / Markmap / Browser) |
| **`yyp`** | 左侧目录树 | 复制当前文件或文件夹的完整绝对路径至系统剪贴板 |
| **`ww`** | 编辑区 | 保存当前文件 (`:w`) |
| **`rl`** | 编辑区 | 安全重新加载当前文件 (`:e`) |
| **`qq`** / **`q`** | 编辑区 | 关闭当前文件，销毁顶层标签并自动切到上一个打开的文件 |
| **`<C-p>`** | 全局 | Telescope 快速模糊查找文件名 |
| **`<C-f>`** | 全局 | Telescope 全局文本内容搜索 (`live_grep`) |
| **`gd`** | 代码区 | LSP 跳转到函数/变量定义处 |
| **`gr`** | 代码区 | LSP 查看所有引用列表 |
| **`<C-A-l>`** | 代码区 | LSP 自动格式化代码 |

---

## 环境准备与部署流程 (Installation & Deployment)

### 1. 系统基础环境安装

#### macOS (推荐使用 Homebrew)
```bash
# 1. 基础包与环境依赖
brew install neovim node git ripgrep fd

# 2. 编程语言工具链 (根据需要选用)
brew install rustc go python@3.11

# 3. 字体安装 (防止目录树图标或终端符号乱码)
brew install --cask font-hack-nerd-font
```

#### Linux (Debian / Ubuntu)
```bash
sudo apt update
sudo apt install -y neovim nodejs npm git ripgrep curl
```

---

### 2. 获取配置与插件管理器安装

```bash
# 1. 克隆配置文件到用户 Neovim 配置目录
git clone https://github.com/0xA2618/nvim.git ~/.config/nvim

# 2. 安装 packer.nvim (插件管理器)
git clone --depth 1 https://github.com/wbthomason/packer.nvim \
  ~/.local/share/nvim/site/pack/packer/start/packer.nvim
```

---

### 3. 安装依赖与插件同步

进入 Neovim 执行安装命令：
```bash
nvim
```
在 Neovim 内部命令行输入：
```vim
:PackerSync
```
或者在终端中一行命令免交互完成安装编译：
```bash
nvim --headless -c "autocmd User PackerComplete quitall" -c "PackerSync"
```

---

### 4. 构建与扩展能力配置

#### A. Markdown 增强组件构建
进入 `markdown-preview` 插件运行环境安装内部服务（仅需执行一次）：
```bash
cd ~/.local/share/nvim/site/pack/packer/opt/markdown-preview.nvim/app
npm install
```

#### B. OpenCode 终端 CLI 工具
确保你的机器上安装了 `opencode`（或放置在 `~/.opencode/bin/opencode`），系统启动三栏布局时会自动连接并启动对话终端。

#### C. Markmap 思维导图能力
由于通过 Node.js 原生驱动，系统使用 `npx markmap-cli` 按需执行，无需常驻守护进程。

---

## 卸载与清理 (Uninstall)

如需彻底移除本配置，执行以下命令即可：
```bash
rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim
rm -rf ~/.cache/nvim
```
