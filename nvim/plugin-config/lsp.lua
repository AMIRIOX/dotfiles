vim.diagnostic.config({
    virtual_text = true,
})

require('mason').setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
})

require('mason-lspconfig').setup({
    -- A list of servers to automatically install if they're not already installed
    ensure_installed = { 'clangd', 'rust_analyzer', 'asm_lsp', 'pylsp', 'lua_ls', 'cmake' },
})

-- Set different settings for different languages' LSP
-- LSP list: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
-- How to use setup({}): https://github.com/neovim/nvim-lspconfig/wiki/Understanding-setup-%7B%7D
--     - the settings table is sent to the LSP
--     - on_attach: a lua callback function to run after LSP atteches to a given buffer
local lspconfig = require('lspconfig')

-- Customized on_attach function
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set("n", "<space>f", function()
        vim.lsp.buf.format({ async = true })
    end, bufopts)
end

-- Configure each language
-- How to add LSP for a specific language?
-- 1. use `:Mason` to install corresponding LSP
-- 2. add configuration below
lspconfig.clangd.setup({
    on_attach = on_attach,
    cmd = { "clangd", "--background-index", "--clang-tidy", "--completion-style=detailed", "--offset-encoding=utf-16" },
    settings = {
      clangd = {
        inlayHints = {
          enable = true,  -- 启用类型提示
          parameterHints = true,  -- 启用函数参数类型提示
          returnTypeHints = true,  -- 启用函数返回值类型提示
        },
      },
    },
})
lspconfig.asm_lsp.setup({
    on_attach = on_attach,
})
lspconfig.rust_analyzer.setup({
    on_attach = on_attach,
    settings = {
      rust_analyzer = {
        diagnostics = {
          enable = true,  -- 启用诊断
        },
        cargo = {
          allFeatures = true,  -- 启用所有 cargo features
        },
        hover = {
          enable = true,  -- 启用 hover 功能
        },
        inlayHints = {
          enable = true,  -- 启用内联类型提示
          typeHints = {
              enable = true,
          },
          onlyTyped = false,  -- 显示所有类型提示（而不是仅显示显式标注的类型）
        },
      },
    }
})
lspconfig.pylsp.setup({
    on_attach = on_attach,
})
lspconfig.cmake.setup({
    on_attach = on_attach,
})
