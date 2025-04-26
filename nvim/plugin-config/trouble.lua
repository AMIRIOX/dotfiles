require("trouble").setup({
    position = "bottom",
    height = 10,
    width = 50,
    -- icons = true,
    mode = "document_diagnostics",
    -- "workspace_diagnostics"、"document_diagnostics"、"quickfix"、"loclist"、"lsp_references"
    fold_open = "",
    fold_closed = "",
    group = true,
    padding = true,
    signs = {
        error = "",
        warning = "",
        hint = "",
        information = "",
    },
    use_diagnostic_signs = false,
})

vim.cmd([[highlight TroubleNormal guibg=NONE]])
vim.cmd([[highlight TroubleBorder guibg=NONE]])
