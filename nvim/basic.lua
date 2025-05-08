-- utf8
vim.g.encoding = "UTF-8"
vim.o.fileencoding = "utf-8"

-- keep content in center
vim.o.scrolloff = 8
vim.o.sidescrolloff = 8

-- relative ln
vim.wo.number = true
vim.wo.relativenumber = true

-- highlight
vim.wo.cursorline = true

-- line tips
vim.wo.signcolumn = "yes"
vim.wo.colorcolumn = "80"

-- indent
vim.o.tabstop = 4
vim.bo.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftround = true

-- >> << indent
vim.o.shiftwidth = 4
vim.bo.shiftwidth = 4

-- Space tab
vim.o.expandtab = true
vim.bo.expandtab = true

-- auto indent
vim.o.autoindent = true
vim.bo.autoindent = true
vim.o.smartindent = true

-- ignore case
vim.o.ignorecase = true
vim.o.smartcase = true

-- search
vim.o.hlsearch = false
vim.o.incsearch = true

-- cmd high enough
vim.o.cmdheight = 2

-- auto read if modified
vim.o.autoread = true
vim.bo.autoread = true

-- no wrap
vim.wo.wrap = false

-- first-end moving
vim.o.whichwrap = "<,>,[,]"

-- others
vim.o.hidden = true
vim.o.mouse = "a"
vim.o.shortmess = vim.o.shortmess .. "c"
vim.o.showtabline = 2
vim.o.showmode = false

-- backup
vim.o.backup = false
vim.o.writebackup = false
vim.o.swapfile = false

-- smaller updatetime
vim.o.updatetime = 300

-- prefix timeout
vim.o.timeoutlen = 500

-- split window
vim.o.splitbelow = true
vim.o.splitright = true

-- comp
vim.g.completeopt = "menu,menuone,noselect,noinsert"
vim.o.wildmenu = true
vim.o.pumheight = 10

-- style
vim.o.background = "dark"
vim.o.termguicolors = true
vim.opt.termguicolors = true

-- invisable
vim.o.list = true
vim.o.listchars = "space:·"

-- fold
vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
vim.wo.foldlevel = 99

vim.filetype.add({
  extension = {
    scheme = "scheme",
    scm = "scheme",
    rkt = "racket"
  }
})

--[[
require('nvim-treesitter.configs').setup({                                               
    ensure_installed = {"rust", "java", "html", "css", "vim", "lua", "javascript", "typescript", "c", "cpp", "python"},
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = '<CR>',
            node_incremental = '<CR>',
            node_decremental = '<BS>',
            scope_incremental = '<TAB>'
        }
    },
    indent = {
        enable = true
    },
})
--]]
