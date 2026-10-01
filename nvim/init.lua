local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local ok = vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
    if ok ~= 0 then
        vim.notify("lazy.nvim 安装失败,请检查网络后重试", vim.log.levels.ERROR)
    end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- colorscheme
    "folke/tokyonight.nvim",
    { "catppuccin/nvim", name = "catppuccin" },
    "navarasu/onedark.nvim",

    -- UI
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },
    {
        "akinsho/bufferline.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons", "moll/vim-bbye" },
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },
    "nvimdev/dashboard-nvim",

    -- multi file
    "ahmedkhalf/project.nvim",
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
    },
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },

    -- syntax
    "numToStr/FTerm.nvim",
    "wakatime/vim-wakatime",
    -- treesitter:main 分支提供 parser 与官方查询;高亮/折叠由 Neovim 内置提供
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = ":TSUpdate",
    },
    -- 语法对象(自带 queries/*/textobjects.scm)
    { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },

    -- LSP / completion
    "neovim/nvim-lspconfig",
    "onsails/lspkind.nvim",
    "j-hui/fidget.nvim",
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
        },
    },
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "mfussenegger/nvim-jdtls",

    "stevearc/conform.nvim",
    "lewis6991/gitsigns.nvim",
    "folke/trouble.nvim",
    "ray-x/lsp_signature.nvim",

    -- 编辑增强
    "kylechui/nvim-surround",
    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        ft = "markdown",
        config = function()
            require("render-markdown").setup({
                heading = {
                    icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
                },
            })
        end,
    },
    --[[
    {
        "Saecki/crates.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
    },
    --]]

    -- "rcarriga/nvim-notify"

    "lukas-reineke/indent-blankline.nvim",
    -- "ggandor/leap.nvim"

    -- "tpope/vim-repeat"

    {
        "folke/sidekick.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("sidekick").setup({
                nes = { enabled = false },
                cli = {
                    enabled = true,
                    context = {
                        enabled = true,
                        files = true,
                    },
                },
            })
            vim.keymap.set("n", "<leader>ai", function()
                require("sidekick.cli").toggle({ name = "copilot" })
            end, {
                desc = "Toggle Copilot CLI",
                silent = true,
                noremap = true,
            })

            vim.keymap.set("v", "<leader>sd", function()
                require("sidekick.cli").send({ name = "copilot" })
            end, {
                desc = "Send selection to Copilot",
                silent = true,
                noremap = true,
            })
        end,
    },

    --[[
    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons", "nvim-treesitter/nvim-treesitter" },
        config = function()
            require("render-markdown").setup({
                heading = {
                    icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
                },
            })
        end,
    },
    --]]
})

-- Load basic settings
require("basic")
require("keybindings")
require("colorscheme")

-- Load plugin configurations
require("plugin-config.nvim-tree")
require("plugin-config.bufferline")
require("plugin-config.lualine")
require("plugin-config.dashboard")
require("plugin-config.project")
require("plugin-config.telescope")
require("plugin-config.nvim-cmp")
require("plugin-config.lsp")
require("plugin-config.kind")
require("plugin-config.trouble")
require("plugin-config.lsp_signature")
require("plugin-config.fidget")
require("plugin-config.fterm")
require("plugin-config.conform")
require("plugin-config.gitsigns")
require("plugin-config.treesitter")

-- Configure indent-blankline
require("ibl").setup({
    exclude = {
        filetypes = { "dashboard", "alpha", "starter" },
    },
})

-- WSL config(clipboard + 系统打开)
if vim.fn.has("unix") == 1 and vim.fn.system("uname") == "Linux\n" then
    local wsl_check = vim.fn.system("grep -i microsoft /proc/version")
    if wsl_check ~= "" then
        vim.g.clipboard = {
            name = "WslClipboard",
            copy = {
                ["+"] = "win32yank.exe -i",
                ["*"] = "win32yank.exe -i",
            },
            paste = {
                ["+"] = "win32yank.exe -o",
                ["*"] = "win32yank.exe -o",
            },
            cache_enabled = 0,
        }
        -- nvim-tree 的 system_open 已移除,统一走 vim.ui.open();
        -- WSL 下若安装了 wsl-open(原 system_open 的行为),则覆盖用它
        -- https://github.com/4U6U57/wsl-open/
        if vim.fn.executable("wsl-open") == 1 then
            vim.ui.open = function(path)
                return vim.system({ "wsl-open", path }, { detach = true })
            end
        end
    end
end
