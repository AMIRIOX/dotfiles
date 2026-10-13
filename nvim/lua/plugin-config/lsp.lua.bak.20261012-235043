vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    update_in_insert = false,
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
    ensure_installed = {
        "clangd",
        "rust_analyzer",
        "gopls",
        "asm_lsp",
        "pylsp",
        "lua_ls",
        "cmake",
        "jdtls",
        "racket-langserver",
    },
})

-- Neovim 0.11+ 新 LSP API(需 nvim >= 0.11)
local function lsp_setup(server, opts)
    opts = opts or {}
    vim.lsp.config(server, opts)
    vim.lsp.enable(server)
end

local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, opts)

local on_attach = function(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

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

-- 每个 Java 项目根目录只初始化一次 jdtls(避免重复创建 user commands)
local jdtls_roots = {}
vim.api.nvim_create_autocmd("FileType", {
    pattern = "java",
    callback = function()
        local root = vim.fn.getcwd()
        if jdtls_roots[root] then
            return
        end
        local ok, err = pcall(function()
            require("plugin-config.jdtls_conf").setup()
        end)
        if ok then
            jdtls_roots[root] = true
        else
            vim.notify("jdtls 初始化失败: " .. err, vim.log.levels.ERROR)
        end
    end,
    desc = "Setup JDTLS for Java files",
})

lsp_setup("clangd", {
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

lsp_setup("racket_langserver", {
    on_attach = on_attach,
    cmd = { "racket", "--lib", "racket-langserver" },
    filetypes = { "scheme", "racket" },
})

lsp_setup("gopls", {
    on_attach = on_attach,
})

lsp_setup("asm_lsp", {
    on_attach = on_attach,
})

lsp_setup("rust_analyzer", {
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

lsp_setup("pylsp", {
    on_attach = on_attach,
})

lsp_setup("cmake", {
    on_attach = on_attach,
})

local signs = { Error = "󰅙", Info = "󰋼", Hint = "󰌵", Warn = "" }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
