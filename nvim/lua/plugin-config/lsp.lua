vim.diagnostic.config({
    virtual_text = {
        current_line = false,
        severity = { min = vim.diagnostic.severity.WARN },
    },
    virtual_lines = { current_line = true },
    severity_sort = true,
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

local function have(exe)
    return vim.fn.executable(exe) == 1
end

-- ensure_installed 只检查 mason 自己的安装目录，不看 PATH。
-- 系统里已有的 server 再列进来，只会被 mason 重复安装一遍，
-- 装不上的（例如需要 cargo/go/racket 的）会在每次启动重试并报错。
local ensure_installed = { "lua_ls", "pylsp", "rust_analyzer", "cmake", "jdtls" }
if not have("clangd") then
    table.insert(ensure_installed, "clangd")
end

require("mason-lspconfig").setup({
    automatic_enable = false,
    ensure_installed = ensure_installed,
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
        -- 配置节名必须是带连字符的 "rust-analyzer";写成 rust_analyzer 会被 lspconfig 忽略。
        ["rust-analyzer"] = {
            -- 先注释掉:AX_CONFIG_PATH 要按每个项目根求值,而 vim.fn.getcwd() 只在 nvim
            -- 启动时算一次,会让所有项目都指向同一个路径。要用就改成按 config.root_dir
            -- 求值(放 before_init 里),再取消注释。
            -- cargo = {
            --     extraEnv = {
            --         AX_CONFIG_PATH = vim.fn.getcwd() .. "/.axconfig.toml",
            --     },
            -- },
        },
    },
})

lsp_setup("pylsp", {
    on_attach = on_attach,
})

lsp_setup("lua_ls", {
    on_attach = on_attach,
    settings = {
        Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
        },
    },
})

lsp_setup("cmake", {
    on_attach = on_attach,
})

-- 可执行文件缺失时，在打开对应文件类型时提示一次。
-- 这样“没装成功”不会静默，也不至于每次启动都刷屏。
local lsp_executables = {
    c = "clangd",
    cpp = "clangd",
    objc = "clangd",
    go = "gopls",
    asm = "asm-lsp",
    scheme = "racket",
    racket = "racket",
    lua = "lua-language-server",
    python = "pylsp",
    rust = "rust-analyzer",
    java = "java",
}
local warned_missing = {}
vim.api.nvim_create_autocmd("FileType", {
    callback = function(ev)
        local ft = vim.bo[ev.buf].filetype
        local exe = lsp_executables[ft]
        if exe and not warned_missing[exe] and not have(exe) then
            warned_missing[exe] = true
            vim.notify(
                ("LSP 未启动:找不到 %s(打开 %s 文件)"):format(exe, ft),
                vim.log.levels.WARN
            )
        end
    end,
    desc = "Warn once when an LSP executable is missing",
})

local signs = { Error = "󰅙", Info = "󰋼", Hint = "󰌵", Warn = "" }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
