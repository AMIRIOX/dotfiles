vim.diagnostic.config({
    virtual_text = true,
})

require("mason").setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
        },
    },
})

require("mason-lspconfig").setup({
    automatic_enable = false,
    -- A list of servers to automatically install if they're not already installed
    ensure_installed = {
        "clangd",
        "rust_analyzer",
        "asm_lsp",
        "pylsp",
        "lua_ls",
        "cmake",
        "jdtls",
        --        "racket-langserver",
    },
})

-- gen by default; modified a lot

-- Set different settings for different languages' LSP
-- LSP list: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
-- How to use setup({}): https://github.com/neovim/nvim-lspconfig/wiki/Understanding-setup-%7B%7D
--     - the settings table is sent to the LSP
--     - on_attach: a lua callback function to run after LSP atteches to a given buffer
local lspconfig = require("lspconfig")
local util = require("lspconfig.util")

-- Customized on_attach function
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set(
        "n",
        "<space>wr",
        vim.lsp.buf.remove_workspace_folder,
        bufopts
    )
    vim.keymap.set("n", "<space>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)
    vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
    vim.keymap.set("n", "<space>f", function()
        vim.lsp.buf.format({ async = true })
    end, bufopts)
end

-- X11 required
local configs = require("lspconfig.configs")
if not configs.racket_langserver then
    configs.racket_langserver = {
        default_config = {
            cmd = { "racket", "--lib", "racket-langserver" },
            filetypes = { "scheme", "racket" },
            root_dir = util.path.dirname,
            single_file_support = true,
            settings = {},
        },
    }
end

-- Isolated jdtls config
vim.api.nvim_create_autocmd("FileType", {
    pattern = "java",
    callback = function()
        local jdtls_custom_conf = require("plugin-config.jdtls_conf")
        if not jdtls_custom_conf then
            print("Error: Could not load jdtls_conf")
            return
        end
        jdtls_custom_conf.setup()
        print("JDTLS setup initiated for Java file.")
    end,
    desc = "Setup JDTLS for Java files",
})

-- Configure each language
lspconfig.clangd.setup({
    on_attach = on_attach,
    cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--completion-style=detailed",
        "--offset-encoding=utf-16",
    },
    settings = {
        clangd = {
            inlayHints = {
                enable = true,
                parameterHints = true,
                returnTypeHints = true,
            },
        },
    },
})
lspconfig.racket_langserver.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { "racket", "--lib", "racket-langserver" },
    filetypes = { "scheme", "racket" },
})
lspconfig.asm_lsp.setup({
    on_attach = on_attach,
})
lspconfig.rust_analyzer.setup({
    on_attach = on_attach,
    settings = {
        rust_analyzer = {
            diagnostics = {
                enable = true,
            },
            cargo = {
                allFeatures = true,
                allTargets = true,
                extraEnv = {
                    AX_CONFIG_PATH = vim.fn.getcwd() .. "/.axconfig.toml",
                },
                buildScripts = {
                    enable = true,
                },
            },
            procMacro = {
                enable = true,
            },
            hover = {
                enable = true,
            },
            completion = {
                autoimport = {
                    enable = true,
                },
                fullFunctionSignatures = {
                    enable = true,
                },
            },
            workspace = {
                symbol = {
                    search = {
                        kind = "all_symbols",
                        limit = 128,
                    },
                },
            },
            inlayHints = {
                enable = true,
                typeHints = {
                    enable = true,
                },
                onlyTyped = false,
            },
        },
    },
})
lspconfig.pylsp.setup({
    on_attach = on_attach,
})
lspconfig.cmake.setup({
    on_attach = on_attach,
})

vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    update_in_insert = false,
})

local signs = { Error = "󰅙", Info = "󰋼", Hint = "󰌵", Warn = "" }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
