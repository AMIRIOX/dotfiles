-- Trouble v3 配置(注意:signs/use_diagnostic_signs/顶层 position 等 v2 选项已移除,
-- v3 使用 icons、win、diagnostics 等新结构)
require("trouble").setup({
    mode = "document_diagnostics",
    -- 窗口位置与大小:bottom/top 用 size,left/right 用 width
    win = {
        position = "bottom",
        size = 10,
        width = 50,
    },
    icons = {
        error = "",
        warning = "",
        hint = "",
        information = "",
        fold_open = "",
        fold_closed = "",
    },
    diagnostics = {
        signs = false, -- 等价旧版 use_diagnostic_signs = false
    },
})

vim.cmd([[highlight TroubleNormal guibg=NONE]])
vim.cmd([[highlight TroubleBorder guibg=NONE]])
