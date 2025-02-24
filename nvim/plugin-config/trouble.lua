require("trouble").setup({
  position = "bottom",         -- 窗口位置：可选 "bottom"、"top"、"left"、"right"
  height = 10,                 -- 窗口高度（仅对 top/bottom 有效）
  width = 50,                  -- 窗口宽度（仅对 left/right 有效）
  --icons = true,                -- 显示图标（需要 nvim-web-devicons）
  mode = "document_diagnostics", -- 默认模式："workspace_diagnostics"、"document_diagnostics"、"quickfix"、"loclist"、"lsp_references"
  fold_open = "",             -- 折叠打开图标
  fold_closed = "",           -- 折叠关闭图标
  group = true,                -- 按文件分组
  padding = true,              -- 窗口内边距
  signs = {
    error = "",
    warning = "",
    hint = "",
    information = ""
  },
  use_diagnostic_signs = false  -- 使用 Neovim 内置诊断图标
})

vim.cmd [[highlight TroubleNormal guibg=NONE]]
vim.cmd [[highlight TroubleBorder guibg=NONE]]
