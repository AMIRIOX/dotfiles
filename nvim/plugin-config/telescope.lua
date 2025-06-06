local telescope = require("telescope")
vim.cmd("packadd telescope.nvim")
local telescope = require("telescope")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local sorters = require("telescope.sorters")
local previewers = require("telescope.previewers")

telescope.setup({
    defaults = {
        mappings = {
            i = {
                ["<C-n>"] = actions.move_selection_next,
                ["<C-p>"] = actions.move_selection_previous,
            },
        },
        file_sorter = sorters.get_fuzzy_file,
        prompt_prefix = "> ",
        selection_caret = "> ",
        entry_prefix = "  ",
        initial_mode = "insert",
        selection_strategy = "reset",
        sorting_strategy = "descending",
        layout_strategy = "horizontal",
        layout_config = {
            prompt_position = "bottom",
            horizontal = {
                mirror = false,
                preview_width = 0.5,
            },
            vertical = {
                mirror = false,
            },
            width = 0.9,
            height = 0.9,
            preview_cutoff = 0,
        },
        file_ignore_patterns = {},
        generic_sorter = sorters.get_generic_fuzzy_sorter,
        path_display = {},
        winblend = 0,
        border = {},
        borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        color_devicons = true,
        use_less = true,
        set_env = { ["COLORTERM"] = "truecolor" }, -- default { }, currently unsupported for shells like cmd.exe / powershell.exe
        file_previewer = previewers.vim_buffer_cat.new,
        grep_previewer = previewers.vim_buffer_vimgrep.new,
        qflist_previewer = previewers.vim_buffer_qflist.new,

        project = {
            base_dirs = {
                "/home/amiriox/",
            },
        },
    },
})

vim.cmd([[
  hi TelescopeNormal guibg=NONE ctermbg=NONE
  hi TelescopeBorder guibg=NONE ctermbg=NONE
  hi TelescopePromptNormal guibg=NONE ctermbg=NONE
  hi TelescopePromptBorder guibg=NONE ctermbg=NONE
  hi TelescopeResultsNormal guibg=NONE ctermbg=NONE
  hi TelescopeResultsBorder guibg=NONE ctermbg=NONE
  hi TelescopePreviewNormal guibg=NONE ctermbg=NONE
  hi TelescopePreviewBorder guibg=NONE ctermbg=NONE
]])
