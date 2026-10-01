-- temporary
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- utf8
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
vim.o.softtabstop = 4
vim.o.shiftround = true

-- >> << indent
vim.o.shiftwidth = 4

-- Space tab
vim.o.expandtab = true

-- auto indent
vim.o.autoindent = true
vim.o.smartindent = true

-- ignore case
vim.o.ignorecase = true
vim.o.smartcase = true

-- search
vim.o.hlsearch = false
vim.o.incsearch = true

-- auto read if modified
vim.o.autoread = true

-- no wrap
-- vim.wo.wrap = false

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
vim.opt.completeopt = "menu,menuone,noselect,noinsert"
vim.o.pumheight = 10

-- style
vim.o.background = "dark"

-- invisable
vim.o.list = true
vim.opt.listchars = {
    tab = '|—',
    space = '·',
}

-- fold
vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.wo.foldlevel = 99

vim.filetype.add({
    extension = {
        scheme = "scheme",
        scm = "scheme",
        rkt = "racket",
    },
})
