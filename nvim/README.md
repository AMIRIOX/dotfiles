
## Install lazy.nvim

lazy.nvim 会在首次启动时自动克隆安装(见 init.lua 开头的 bootstrap 代码),无需手动操作。

## Install plugins

```
$ nvim
```
Then, run `:Lazy sync`(首次启动也会自动安装 spec 中声明的插件)。

常用命令:
- `:Lazy` 打开插件管理界面
- `:Lazy sync` 同步/更新插件
- `:Lazy update` 更新插件
- `:Lazy check` 检查插件更新

It is recommended to use a proxy if necessary.

## Requirements

- Neovim **0.12+**(treesitter 高亮/折叠/选中是内置功能,需显式启用)
- `tree-sitter-cli`(nvim-treesitter 编译 parser 用;brew 里是独立 formula
  `tree-sitter-cli`,不是只含库的 `tree-sitter`)+ C 编译器

## Treesitter

parser 与查询由 `nvim-treesitter`(main 分支)提供,装在 `stdpath('data')/site/`
(即 `~/.local/share/nvim/site/parser` 和 `~/.local/share/nvim/site/queries`)。

- 安装新语言:`:TSInstall <lang>`
- 更新已装语言:`:TSUpdate`

高亮/折叠/选中是 Neovim 内置功能,启用方式见 `lua/plugin-config/treesitter.lua`
(通过 `FileType` autocmd 调 `vim.treesitter.start()`);语法对象由
`nvim-treesitter-textobjects` 提供。
