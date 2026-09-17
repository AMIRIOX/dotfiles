require("gitsigns").setup({
    signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "契" },
        topdelete = { text = "契" },
        changedelete = { text = "▎" },
    },
    on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local map = vim.keymap.set
        local opts = { buffer = bufnr, noremap = true, silent = true }

        -- 暂存/回滚 hunk
        map("n", "<leader>hs", gs.stage_hunk, opts)
        map("n", "<leader>hr", gs.reset_hunk, opts)
        map("v", "<leader>hs", function()
            gs.stage_hunk(vim.fn.line("."), vim.fn.line("v"))
        end, opts)
        map("v", "<leader>hr", function()
            gs.reset_hunk(vim.fn.line("."), vim.fn.line("v"))
        end, opts)
        map("n", "<leader>hS", gs.stage_buffer, opts)
        map("n", "<leader>hR", gs.reset_buffer, opts)

        -- 预览 / 对比
        map("n", "<leader>hp", gs.preview_hunk, opts)
        map("n", "<leader>hd", gs.diffthis, opts)
        map("n", "<leader>hD", function()
            gs.diffthis("~")
        end, opts)

        -- 行内 blame / 切换删除行
        map("n", "<leader>hb", function()
            gs.blame_line({ full = true })
        end, opts)
        map("n", "<leader>td", gs.toggle_deleted, opts)

        -- 注意:hunk 跳转 ]c/[c 让给 nvim-treesitter-textobjects(类跳转)
    end,
})
