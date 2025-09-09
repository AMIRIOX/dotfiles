local username = os.getenv("USER")

package.path = package.path .. ";/home/" .. username .. "/.config/nvim/?.lua"
package.path = package.path
    .. ";/home/" .. username .. "/.local/share/nvim/site/pack/packer/start/packer.nvim/?.lua"

vim.cmd([[packadd packer.nvim]])

return require("packer").startup(function(use)
    -- load addons

    -- packer
    use("wbthomason/packer.nvim")

    -- colorscheme
    use("folke/tokyonight.nvim")
    use({ "catppuccin/nvim", as = "catppuccin" })
    use("navarasu/onedark.nvim")

    -- UI
    use({
        "kyazdani42/nvim-tree.lua",
        requires = "kyazdani42/nvim-web-devicons",
    })
    use({
        "akinsho/bufferline.nvim",
        requires = {
            "kyazdani42/nvim-web-devicons",
            "moll/vim-bbye",
        },
    })
    use({
        "nvim-lualine/lualine.nvim",
        requires = {
            "kyazdani42/nvim-web-devicons",
        },
    })
    use("glepnir/dashboard-nvim")

    -- multi file
    use("ahmedkhalf/project.nvim")
    use({
        "nvim-telescope/telescope.nvim",
        requires = {
            "nvim-lua/plenary.nvim",
        },
    })
    use({
        "nvim-telescope/telescope-fzf-native.nvim",
        run = "make",
    })

    -- syntax
    use({ "nvim-treesitter/nvim-treesitter" })
    use("numToStr/FTerm.nvim")
    use("wakatime/vim-wakatime")
    use({ "neovim/nvim-lspconfig" })
    use({ "onsails/lspkind.nvim" }) --, after = 'nvim-lspconfig' }
    use({ "j-hui/fidget.nvim" }) --, after = 'nvim-lspconfig' }
    use({ "hrsh7th/nvim-cmp", config = [[require('plugin-config.nvim-cmp')]] })
    use({ "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" })
    use({ "hrsh7th/cmp-buffer", after = "nvim-cmp" })
    use({ "hrsh7th/cmp-path", after = "nvim-cmp" })
    use({ "hrsh7th/cmp-cmdline", after = "nvim-cmp" })
    use("L3MON4D3/LuaSnip")
    use("saadparwaiz1/cmp_luasnip")
    use({ "williamboman/mason.nvim", opts = {} })
    use({ "williamboman/mason-lspconfig.nvim", opts = {} })
    use({ "mfussenegger/nvim-jdtls" })

    use({ "nvimtools/none-ls.nvim" })
    use("folke/trouble.nvim")
    use("ray-x/lsp_signature.nvim")
    --[[
    use({
        "Saecki/crates.nvim",
        requires = { "nvim-lua/plenary.nvim" },
        config = function()
            require("crates").setup()
        end,
    })
    --]]

    --use "rcarriga/nvim-notify"
    --vim.notify = require("notify")

    use("lukas-reineke/indent-blankline.nvim")
    require("ibl").setup({
        exclude = {
            filetypes = { "dashboard", "alpha", "starter" },
        },
    })
    use("ggandor/leap.nvim")
    require("leap").create_default_mappings()

    --use "tpope/vim-repeat"
    --require("vim-repeat")

    -- settings
    require("basic")
    require("keybindings")
    require("colorscheme")

    -- load plugin-config
    require("plugin-config.nvim-tree")
    require("plugin-config.bufferline")
    require("plugin-config.lualine")
    require("plugin-config.dashboard")
    require("plugin-config.project")
    require("plugin-config.telescope")
    require("telescope").load_extension("projects")
    require("plugin-config.nvim-cmp")
    require("plugin-config.lsp")
    require("plugin-config.kind")
    require("plugin-config.trouble")
    require("plugin-config.lsp_signature")
    require("plugin-config.fidget")
    require("plugin-config.fterm")
    require("plugin-config.nonels")
    -- require("plugin-config.toml")

    -- WSL clipboard config，by clip.exe
    if vim.fn.has("unix") == 1 and vim.fn.system("uname") == "Linux\n" then
        local wsl_check = vim.fn.system("grep -i microsoft /proc/version")
        if wsl_check ~= "" then
            -- vim.opt.clipboard = 'unnamedplus'
            vim.g.clipboard = {
                name = "WslClipboard",
                copy = {
                    ["+"] = "clip.exe",
                    ["*"] = "clip.exe",
                },
                paste = {
                    ["+"] = "powershell.exe Get-Clipboard",
                    ["*"] = "powershell.exe Get-Clipboard",
                },
                cache_enabled = 0,
            }
        end
    end

    -- Tests
    --[[
    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "scheme", "racket" },
        callback = function()
            vim.lsp.start({
                name = "racket-lsp",
                cmd = { "racket", "--lib", "racket-langserver" },
                root_dir = vim.fn.getcwd(),
                on_attach = on_attach,
                capabilities = require("cmp_nvim_lsp").default_capabilities(),
            })
        end,
    })
    ]]

    if packer_bootstrap then
        require("packer").sync()
    end
end)
