-- lsp/nonels.lua
local status, null_ls = pcall(require, "null-ls")
if not status then
    vim.notify("没有找到 null-ls")
    return
end

local formatters = null_ls.builtins.formatting

null_ls.setup({
    sources = {
        formatters.stylua,
        formatters.clang_format,
    },
})
