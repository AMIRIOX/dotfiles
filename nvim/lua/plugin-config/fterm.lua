require("FTerm").setup({
    blend = 0,
    border = "rounded",
})

vim.cmd([[highlight NormalFloat guibg=NONE]])
vim.cmd([[highlight FloatBorder guibg=NONE]])

vim.keymap.set("n", "<leader>ct", function()
    require("FTerm").run("cargo test")
end, { desc = "cargo test" })
