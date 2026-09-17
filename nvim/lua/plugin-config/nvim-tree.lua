local status, nvim_tree = pcall(require, "nvim-tree")
if not status then
    vim.notify("没有找到 nvim-tree")
    return
end

-- local list_keys = require("keybindings").nvimTreeList
nvim_tree.setup({

    git = {
        enable = true,
    },
    update_cwd = false,
    update_focused_file = {
        enable = true,
        update_cwd = false,
    },
    filters = {
        dotfiles = false,
        custom = { "node_modules" },
    },
    view = {
        width = 30,
        side = "left",
        -- hide_root_folder = false,
        -- mappings = {
        --    custom_only = false,
        --    list = list_keys,
        -- },
        number = false,
        relativenumber = false,
        -- show icons
        signcolumn = "yes",
    },
    actions = {
        open_file = {
            resize_window = true,
            quit_on_open = true,
        },
    },
    -- system_open 已在新版 nvim-tree 移除,统一使用内置 vim.ui.open()
    -- (macOS: open / WSL: wslview、explorer.exe;WSL 如需 wsl-open 见 init.lua 的 WSL 配置块)
})

-- auto closed
vim.cmd([[
  autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif
]])

-- transparency
vim.cmd([[
  hi NvimTreeNormal guibg=NONE ctermbg=NONE
  hi NvimTreeNormalNC guibg=NONE ctermbg=NONE
]])
