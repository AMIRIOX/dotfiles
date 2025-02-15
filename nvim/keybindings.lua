vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.api.nvim_set_keymap
-- 复用 opt 参数
local opt = { noremap = true, silent = true }

vim.keymap.set('n', '<C-Space>', '<CMD>lua require("FTerm").toggle()<CR>')
vim.keymap.set('t', '<C-Space>', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>')

-- 格式化代码 (clang-format)
map("n", "<A-S-f>", ":lua vim.lsp.buf.format { async = true }<CR>", opt)
-- 取消 s 默认功能
map("n", "s", "", opt)
-- windows 分屏快捷键
map("n", "sv", ":vsp<CR>", opt)
map("n", "sh", ":sp<CR>", opt)
-- 关闭当前
map("n", "sc", "<C-w>c", opt)
-- 关闭其他
map("n", "so", "<C-w>o", opt)
-- Alt + hjkl  窗口之间跳转
map("n", "<A-h>", "<C-w>h", opt)
map("n", "<A-j>", "<C-w>j", opt)
map("n", "<A-k>", "<C-w>k", opt)
map("n", "<A-l>", "<C-w>l", opt)

-- 左右比例控制
map("n", "<C-Left>", ":vertical resize -2<CR>", opt)
map("n", "<C-Right>", ":vertical resize +2<CR>", opt)
map("n", "s,", ":vertical resize -20<CR>", opt)
map("n", "s.", ":vertical resize +20<CR>", opt)
-- 上下比例
map("n", "sj", ":resize +10<CR>", opt)
map("n", "sk", ":resize -10<CR>", opt)
map("n", "<C-Down>", ":resize +2<CR>", opt)
map("n", "<C-Up>", ":resize -2<CR>", opt)
-- 等比例
map("n", "s=", "<C-w>=", opt)

-- Terminal相关
map("n", "<leader>t", ":sp | terminal<CR>", opt)
map("n", "<leader>vt", ":vsp | terminal<CR>", opt)
map("t", "<Esc>", "<C-\\><C-n>", opt)
map("t", "<A-h>", [[ <C-\><C-N><C-w>h ]], opt)
map("t", "<A-j>", [[ <C-\><C-N><C-w>j ]], opt)
map("t", "<A-k>", [[ <C-\><C-N><C-w>k ]], opt)
map("t", "<A-l>", [[ <C-\><C-N><C-w>l ]], opt)

-- visual模式下缩进代码
map("v", "<", "<gv", opt)
map("v", ">", ">gv", opt)
-- 上下移动选中文本
map("v", "J", ":move '>+1<CR>gv-gv", opt)
map("v", "K", ":move '<-2<CR>gv-gv", opt)

-- 上下滚动浏览
map("n", "<C-j>", "4j", opt)
map("n", "<C-k>", "4k", opt)
-- ctrl u / ctrl + d  只移动9行，默认移动半屏
map("n", "<C-u>", "9k", opt)
map("n", "<C-d>", "9j", opt)

-- 在visual 模式里粘贴不要复制
map("v", "p", '"_dP', opt)

-- 退出 (啥b快捷键绑定，我怎么用宏啊？)
-- map("n", "q", ":q<CR>", opt)
-- map("n", "qq", ":q!<CR>", opt)
-- map("n", "Q", ":qa!<CR>", opt)

-- insert 模式下，跳到行首行尾
map("i", "<C-h>", "<ESC>I", opt)
map("i", "<C-l>", "<ESC>A", opt)

-- bufferline
-- 左右Tab切换
map("n", "<Tab>", ":BufferLineCycleNext<CR>", opt)
map("n", "<C-h>", ":BufferLineCyclePrev<CR>", opt)
map("n", "<C-l>", ":BufferLineCycleNext<CR>", opt)
-- 关闭
--"moll/vim-bbye"
map("n", "<C-w>", ":Bdelete!<CR>", opt)
map("n", "<leader>bl", ":BufferLineCloseRight<CR>", opt)
map("n", "<leader>bh", ":BufferLineCloseLeft<CR>", opt)
map("n", "<leader>bc", ":BufferLinePickClose<CR>", opt)

-- 插件快捷键
local pluginKeys = {

   }

-- nvim-tree
-- alt + m 键打开关闭tree
map("n", "<A-m>", ":NvimTreeToggle<CR>", opt)
-- 列表快捷键
pluginKeys.nvimTreeList = {

  -- 打开文件或文件夹
  {

    key = {

   "<CR>", "o", "<2-LeftMouse>"}, action = "edit" },
  -- 分屏打开文件
  {

    key = "v", action = "vsplit" },
  {

    key = "h", action = "split" },
  -- 显示隐藏文件
  {

    key = "i", action = "toggle_custom" }, -- 对应 filters 中的 custom (node_modules)
  {

    key = ".", action = "toggle_dotfiles" }, -- Hide (dotfiles)
  -- 文件操作
  {

    key = "<F5>", action = "refresh" },
  {

    key = "a", action = "create" },
  {

    key = "d", action = "remove" },
  {

    key = "r", action = "rename" },
  {

    key = "x", action = "cut" },
  {

    key = "c", action = "copy" },
  {

    key = "p", action = "paste" },
  {

    key = "s", action = "system_open" },
}

-- lsp 快捷键
--[[
pluginKeys.lspKeybinding = function(mapbuf)
 -- rename
 mapbuf("n", "<leader>r", ":lua vim.lsp.buf.rename<CR>", opt)
 -- code action
 mapbuf("n", "<leader>ca", ":lua vim.lsp.buf.code_action()<CR>", opt)
 -- go to definition
 mapbuf("n", "gd", ":lua vim.lsp.buf.definition()<CR>", opt)
 -- show hover
 mapbuf("n", "gh", ":lua vim.lsp.buf.hover()<CR>", opt)
 -- format
 mapbuf("n", "<C-y>", ":lua vim.lsp.buf.format { async = true }<CR>", opt)
end
--]]

return pluginKeys

