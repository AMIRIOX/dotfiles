-- treesitter:parser 与查询由 nvim-treesitter(main 分支)提供;
-- 高亮/折叠/选中都是 Neovim 内置功能,需显式启用
-- textobject 由 nvim-treesitter-textobjects 提供(自带 queries/*/textobjects.scm)

-- move 用的是全局 ]m/[m/]M/[M,而 ftplugin/python.vim 会在 buffer 内抢这几个键
-- (正则实现),关掉它让所有语言统一走 treesitter
vim.g.no_python_maps = true

local map = vim.keymap.set

-- 启用 treesitter 高亮(有 parser 才启动,没有则继续用 regex syntax)
vim.api.nvim_create_autocmd("FileType", {
    callback = function(ev)
        pcall(vim.treesitter.start, ev.buf)
    end,
    desc = "Treesitter: 为支持的语言启用高亮",
})

-- 内置 vim.treesitter.select() 的增量选择键位
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

-- 语法感知 textobject:yif/caf/daf/ic/ac/ia/aa 等
require("nvim-treesitter-textobjects").setup({
    select = {
        lookahead = true,
        selection_modes = {
            ["@function.outer"] = "V",
            ["@class.outer"] = "V",
        },
    },
})

local select_textobject = require("nvim-treesitter-textobjects.select").select_textobject
local textobjects = {
    ["if"] = "@function.inner",
    ["af"] = "@function.outer",
    ["ic"] = "@class.inner",
    ["ac"] = "@class.outer",
    ["ia"] = "@parameter.inner",
    ["aa"] = "@parameter.outer",
}

for lhs, query in pairs(textobjects) do
    map({ "x", "o" }, lhs, function()
        select_textobject(query)
    end, { desc = "Treesitter: " .. query })
end

-- 语法感知跳转,替代只在个别 ftplugin 里存在的正则版 ]m/[m/]M/[M
local move = require("nvim-treesitter-textobjects.move")
local moves = {
    ["]m"] = { "goto_next_start", "下一个函数开始" },
    ["[m"] = { "goto_previous_start", "上一个函数开始" },
    ["]M"] = { "goto_next_end", "下一个函数结束" },
    ["[M"] = { "goto_previous_end", "上一个函数结束" },
}

for lhs, spec in pairs(moves) do
    map({ "n", "x", "o" }, lhs, function()
        move[spec[1]]("@function.outer", "textobjects")
    end, { desc = "Treesitter: " .. spec[2] })
end
