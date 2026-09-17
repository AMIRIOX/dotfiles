-- Neovim 0.12 内置 treesitter:高亮默认自动开启,折叠用 basic.lua 的
-- vim.treesitter.foldexpr(),无需 nvim-treesitter 插件(已归档,2026-04)
-- 本文件只保留内置 vim.treesitter.select() 的增量选择键位

local map = vim.keymap.set
map("n", "<CR>", function()
    vim.treesitter.select("child")
end, { desc = "Treesitter: 选择当前节点" })
map("x", "<CR>", function()
    vim.treesitter.select("parent")
end, { desc = "Treesitter: 扩大到父节点" })
map("x", "<BS>", function()
    vim.treesitter.select("child")
end, { desc = "Treesitter: 缩小到子节点" })
map("x", "<TAB>", function()
    vim.treesitter.select("next")
end, { desc = "Treesitter: 选择下一个兄弟节点" })
