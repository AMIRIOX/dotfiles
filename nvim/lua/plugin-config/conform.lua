-- conform.nvim 接管格式化(替代 none-ls 的 formatting 部分)
-- 缺失的 formatter 会在保存时提示安装,如:
--   brew install stylua          (lua)
--   brew install black           (python,可选)
-- rustfmt 随 rustup 自带,gofmt 随 Go 自带
require("conform").setup({
    formatters_by_ft = {
        lua = { "stylua" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        rust = { "rustfmt" },
        go = { "gofmt" },
        python = { "black" },
    },
    format_on_save = {
        timeout_ms = 2000,
        lsp_format = "fallback", -- 未匹配的 filetype 用 LSP 格式化(如 java 走 jdtls)
    },
})
