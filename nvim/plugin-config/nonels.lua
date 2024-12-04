-- lsp/nonels.lua
-- 即使是采用了 none-ls, 这里也是获取 null-ls
local status, null_ls = pcall(require, "null-ls")
if not status then
  vim.notify("没有找到 null-ls")
  return
end

local formatters = null.builtins.format

null_ls.setup({
    sources = {
        -- Stylua
        formatters.clang_format,
        -- 其他 formatter 方式
    },
})

