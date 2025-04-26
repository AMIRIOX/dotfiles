vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.api.nvim_set_keymap
local opt = { noremap = true, silent = true }

-- Terminal
map("n", "<C-Space>", '<CMD>lua require("FTerm").toggle()<CR>', opt)
map("t", "<C-Space>", '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>', opt)

-- Format code
map("n", "<A-S-f>", ":lua vim.lsp.buf.format { async = true }<CR>", opt)

-- Split window
map("n", "s", "", opt)
map("n", "sv", ":vsp<CR>", opt)
map("n", "sh", ":sp<CR>", opt)
map("n", "sc", "<C-w>c", opt)
map("n", "so", "<C-w>o", opt)
map("n", "<A-h>", "<C-w>h", opt)
map("n", "<A-j>", "<C-w>j", opt)
map("n", "<A-k>", "<C-w>k", opt)
map("n", "<A-l>", "<C-w>l", opt)

map("n", "<C-Left>", ":vertical resize -2<CR>", opt)
map("n", "<C-Right>", ":vertical resize +2<CR>", opt)
map("n", "s,", ":vertical resize -20<CR>", opt)
map("n", "s.", ":vertical resize +20<CR>", opt)

map("n", "sj", ":resize +10<CR>", opt)
map("n", "sk", ":resize -10<CR>", opt)
map("n", "<C-Down>", ":resize +2<CR>", opt)
map("n", "<C-Up>", ":resize -2<CR>", opt)

map("n", "s=", "<C-w>=", opt)

-- Terminal mode
map("n", "<leader>t", ":sp | terminal<CR>", opt)
map("n", "<leader>vt", ":vsp | terminal<CR>", opt)
map("t", "<Esc>", "<C-\\><C-n>", opt)
map("t", "<A-h>", [[ <C-\><C-N><C-w>h ]], opt)
map("t", "<A-j>", [[ <C-\><C-N><C-w>j ]], opt)
map("t", "<A-k>", [[ <C-\><C-N><C-w>k ]], opt)
map("t", "<A-l>", [[ <C-\><C-N><C-w>l ]], opt)

-- Visual indent
map("v", "<", "<gv", opt)
map("v", ">", ">gv", opt)
map("v", "J", ":move '>+1<CR>gv-gv", opt)
map("v", "K", ":move '<-2<CR>gv-gv", opt)

-- Scrolling navigate
-- unessential
-- map("n", "<C-j>", "4j", opt)
-- map("n", "<C-k>", "4k", opt)
-- map("n", "<C-u>", "9k", opt)
-- map("n", "<C-d>", "9j", opt)

-- Paste with copying in v-mode
map("v", "p", '"_dP', opt)

-- Jump in i-mode
map("i", "<C-h>", "<ESC>I", opt)
map("i", "<C-l>", "<ESC>A", opt)

-- bufferline
-- Tab to switch
map("n", "<Tab>", ":BufferLineCycleNext<CR>", opt)
map("n", "<C-h>", ":BufferLineCyclePrev<CR>", opt)
map("n", "<C-l>", ":BufferLineCycleNext<CR>", opt)
map("n", "<leader>d", ":Bdelete!<CR>", opt)
map("n", "<leader>bl", ":BufferLineCloseRight<CR>", opt)
map("n", "<leader>bh", ":BufferLineCloseLeft<CR>", opt)
map("n", "<leader>bc", ":BufferLinePickClose<CR>", opt)

-- trouble
map("n", "<leader>xx", ":Trouble diagnostics toggle<CR>", opt)
map("n", "<leader>xX", ":Trouble diagnostics toggle filter.buf=0<CR>", opt)
map("n", "<leader>cs", ":Trouble symbols toggle focus=false<CR>", opt)
map(
    "n",
    "<leader>cl",
    ":Trouble lsp toggle focus=false win.position=right<CR>",
    opt
)
map("n", "<leader>xL", ":Trouble loclist toggle<CR>", opt)
map("n", "<leader>xQ", ":Trouble qflist toggle<CR>", opt)

-- leap
map("n", "s", "<Plug>(leap-forward-to)", opt)
map("n", "S", "<Plug>(leap-backward-to)", opt)
map("n", "t", "<Plug>(leap-forward-till)", opt)
map("n", "T", "<Plug>(leap-backward-till)", opt)

-- management
map("n", "<A-m>", ":NvimTreeToggle<CR>", opt)
map("n", "<leader>fg", "<CMD>Telescope live_grep<CR>", opt)
map("n", "<leader>st", "<CMD>Telescope git_status<CR>", opt)
-- map("n", "<leader>fr", "<cmd>Telescope lsp_references<CR>", opt)
-- map("n", "<leader>fd", "<cmd>Telescope lsp_definitions<CR>", opt)
-- map("n", "<leader>fi", "<cmd>Telescope lsp_implementations<CR>", opt)


--[[
local pluginKeys = {}
pluginKeys.nvimTreeList = {
    -- Open folder
    { key = { "<CR>", "o", "<2-LeftMouse>" }, action = "edit" },
    -- Split window and open file
    { key = "v", action = "vsplit" },
    { key = "h", action = "split" },
    -- Show hidden files
    { key = "i", action = "toggle_custom" },
    { key = ".", action = "toggle_dotfiles" }, -- Hide (dotfiles)
    -- File operation
    { key = "<F5>", action = "refresh" },
    { key = "a", action = "create" },
    { key = "d", action = "remove" },
    { key = "r", action = "rename" },
    { key = "x", action = "cut" },
    { key = "c", action = "copy" },
    { key = "p", action = "paste" },
    { key = "s", action = "system_open" },
}
return pluginKeys
--]]
