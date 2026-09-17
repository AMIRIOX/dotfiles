
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

## Configure your custom

In `init.lua`:
`/home/amiriox/` -> `/home/${username}` (2 fix)

## Treesitter parsers

parser 安装在 `stdpath('data')/parser`(即 `~/.local/share/nvim/parser`),
需要新语言时执行 `:TSInstall <lang>`。

It is recommended to use a proxy if necessary.
