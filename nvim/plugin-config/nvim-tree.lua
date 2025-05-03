local status, nvim_tree = pcall(require, "nvim-tree")
if not status then
    vim.notify("没有找到 nvim-tree")
    return
end

-- local list_keys = require("keybindings").nvimTreeList
nvim_tree.setup({

    git = {
        enable = false,
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

    -- wsl install -g wsl-open
    -- https://github.com/4U6U57/wsl-open/
    system_open = {
        cmd = "wsl-open", -- todo!("mac: open")
    },
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
