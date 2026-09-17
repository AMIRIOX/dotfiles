# VSCode 配置 —— Neovim 等价方案

本目录包含模仿现有 Neovim 配置的 VSCode 等价配置。由于插件生态完全不同，部分功能通过不同机制实现，少数功能无法完全复刻。

## 使用方式

**macOS**: 复制到 `~/Library/Application Support/Code/User/`
**Windows**: 复制到 `%APPDATA%\Code\User\`
**Linux**: 复制到 `~/.config/Code/User/``extensions.json` 中的推荐扩展需要逐一手动安装或通过 "Extensions: Show Recommended Extensions" 命令安装。

## 插件映射对照表

### 完全可替代

| Neovim 插件              | VSCode 替代方案                               | 说明                                           |
| ------------------------ | --------------------------------------------- | ---------------------------------------------- |
| `catppuccin/tokyonight`  | Catppuccin VSCode 主题                         | 支持 latte/mocha 自动切换                       |
| `nvim-lspconfig`         | VSCode 内建 LSP                                | 通过扩展安装各语言服务器                         |
| `mason/mason-lspconfig`  | VSCode 扩展市场                                | 手动安装或推荐列表                               |
| `nvim-cmp`               | VSCode IntelliSense                            | 内建补全引擎，配置项见 settings.json            |
| `LuaSnip`                | VSCode 内建 Snippets                           | 支持自定义 snippet 文件                          |
| `telescope.nvim`         | `Ctrl+P` / `Ctrl+Shift+F`                     | 模糊文件查找 + 全局搜索                          |
| `trouble.nvim`           | Problems 面板 (`Cmd+Shift+M`)                  | 诊断列表，类似 workspace_diagnostics 模式        |
| `nvim-tree.lua`          | VSCode 内建 Explorer                           | 文件树 + 图标                                    |
| `bufferline.nvim`        | VSCode 内建 Tabs                               | 支持关闭、排序                                   |
| `lualine.nvim`           | VSCode 内建 Status Bar                         | 文件类型、编码、换行符                           |
| `indent-blankline.nvim`  | `editor.guides.indentation` + indent-rainbow   | 缩进参考线                                       |
| `lsp_signature.nvim`     | VSCode 内建 Signature Help                     | 函数签名浮动窗口                                 |
| `fidget.nvim`            | VSCode 状态栏 LSP 进度                          | 原生 LSP 进度指示                                |
| `FTerm.nvim`             | VSCode 内建 Terminal (`Ctrl+backtick`)         | 浮动/分屏终端                                    |
| `dashboard-nvim`         | VSCode Start Page / Project Manager             | 启动页 + 最近项目                                |
| `project.nvim`           | Project Manager 扩展                            | 基于 .git 等标记的项目检测                       |
| `wakatime`               | WakaTime VSCode 扩展                            | 完全一致                                         |
| `nvim-jdtls`             | Red Hat Java (Extension Pack for Java)          | JDTLS 完整支持，有专门的 VSCode 配置              |
| `treesitter`             | VSCode Semantic Tokens + TextMate Grammars       | 语法高亮和增量选择 (Smart Select)                 |
| `none-ls (stylua/clang)` | stylua + clang-format 扩展                       | 独立格式化扩展                                   |
| `render-markdown.nvim`   | VSCode 内建 Markdown Preview                     | 支持预览面板                                     |
| `sidekick.nvim`          | GitHub Copilot + Copilot Chat                    | AI 代码补全和对话                                |

### 部分可替代

| Neovim 插件     | VSCode 替代方案               | 差距                                             |
| --------------- | ----------------------------- | ------------------------------------------------ |
| `leap.nvim`     | 无直接替代                    | VSCode 有 vim 扩展但 leap 无等价; 可用 `Cmd+G` 跳行 |
| `telescope-fzf` | Quick Open (`Ctrl+P`)         | fzf 的模糊排序算法与 VSCode 不同, 但功能等价      |
| `lspkind.nvim`  | VSCode 内建补全图标           | Codicons 图标集与 lspkind 预设不完全一致          |

### 无法替代 / 需额外说明

| Neovim 特性               | 原因                                                       | 建议                    |
| ------------------------- | ---------------------------------------------------------- | ----------------------- |
| **透明背景**              | VSCode Electron 窗口不原生支持透明                          | 可用第三方修改如 `vscode-transparent` 但不稳定 |
| **自定义 Lualine 主题**    | VSCode 状态栏主题由 Color Theme 统一控制, 不可按模式变色    | 选择一个完整的 Color Theme |
| **Pmenu 透明**            | 补全菜单背景色由主题控制, 不支持 guibg=NONE                 | 主题 CSS 自定义 |
| **Telescope 透明背景**    | VSCode Quick Open 样式受限                                  | 主题插件可有限定制 |
| **`:!` 命令**             | VSCode 无 Ex 命令行                                         | 用终端面板替代 |
| **vim-repeat**            | 无等价                                                      | VSCode vim 扩展部分覆盖 |
| **Treesitter 折叠表达式** | VSCode 折叠策略不同, 不支持 `foldexpr` 表达式               | 使用缩进折叠或手动标记 |

## CMP 补全来源映射

| nvim-cmp source  | VSCode 等价                     |
| ---------------- | ------------------------------- |
| `nvim_lsp`       | IntelliSense LSP                |
| `luasnip`        | User Snippets                   |
| `buffer`         | `editor.wordBasedSuggestions`    |
| `path`           | `editor.suggest.showFiles`       |
| `cmdline`        | VSCode 命令面板自动补全          |

## Neovim 特有概念如何处理

- **Leader 键**: VSCode 无 leader 概念, 使用 `Ctrl+K` 作为前缀模拟 Space leader 的组合键。
- **`s` 键 (Leap)**: 使用 VSCode vim 扩展时, `s` 的行为取决于 vim 模拟模式。
- **`:terminal`**: VSCode 终端是独立面板, 支持分屏, 但不能像 Neovim 那样在编辑窗口内精确放置。
- **JDTLS 自定义命令** (`JdtCompile` 等): 映射到 VSCode Java 扩展的命令 ID, 见 keybindings.json。
- **WSL 剪贴板**: VSCode 原生支持 WSL, 无需额外配置。

## 推荐额外安装 (增强体验)

以下扩展在 extensions.json 中已列出:

- **vim** 扩展 — 如果你需要在 VSCode 中保留 vim 键位习惯
- **Error Lens** — 行内显示诊断, 体验接近 vim.diagnostic 的 virtual_text
- **GitLens** — 替代 Telescope git_status 的部分功能
- **Project Manager** — 独立项目管理, 功能比 project.nvim 更强
- **todo-tree** — TODO/FIXME 高亮与导航

## 配置文件结构

```
vsc_compatible/
├── README.md           ← 本文件
├── settings.json        ← 等价 basic.lua + colorscheme.lua + 各 LSP 配置
├── keybindings.json     ← 等价 keybindings.lua + lsp.lua 键位 + JDTLS 键位
├── extensions.json      ← 等价 init.lua 中所有 use() 声明
└── snippets/            ← 等价 LuaSnip snippet (按需添加)
```
