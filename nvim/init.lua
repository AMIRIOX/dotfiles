package.path = package.path .. ';/home/amiriox/.config/nvim/?.lua'
package.path = package.path .. ';/home/amiriox/.local/share/nvim/site/pack/packer/start/packer.nvim/?.lua'

vim.cmd [[packadd packer.nvim]]

-- add
return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use("folke/tokyonight.nvim")
  use {
    'kyazdani42/nvim-tree.lua',
    requires = 'kyazdani42/nvim-web-devicons'
  }
  use({
    "akinsho/bufferline.nvim", requires = {
    "kyazdani42/nvim-web-devicons", "moll/vim-bbye" }})

  use({
   "nvim-lualine/lualine.nvim", requires = {
   "kyazdani42/nvim-web-devicons" } })
  use("arkav/lualine-lsp-progress")

  use("glepnir/dashboard-nvim")
  use("ahmedkhalf/project.nvim")

  use {
    'nvim-telescope/telescope.nvim', requires = {
    "nvim-lua/plenary.nvim" } }
  use {
    'nvim-telescope/telescope-fzf-native.nvim',
    run = 'make'
  }
  use 'navarasu/onedark.nvim'
  -- use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use { 'nvim-treesitter/nvim-treesitter' }
  use "numToStr/FTerm.nvim"
  use 'wakatime/vim-wakatime'
  use { 'neovim/nvim-lspconfig' }
  use { 'hrsh7th/nvim-cmp', config = [[require('plugin-config.nvim-cmp')]] }
  use { 'hrsh7th/cmp-nvim-lsp', after = 'nvim-cmp' }
  use { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' } -- buffer auto-completion
  use { 'hrsh7th/cmp-path', after = 'nvim-cmp' } -- path auto-completion
  use { 'hrsh7th/cmp-cmdline', after = 'nvim-cmp' } -- cmdline auto-completion
  use 'L3MON4D3/LuaSnip'
  use 'saadparwaiz1/cmp_luasnip'

  use { 'williamboman/mason.nvim' }
  use { 'williamboman/mason-lspconfig.nvim'}

  use { 'onsails/lspkind.nvim' }
  use { 'nvimtools/none-ls.nvim' }

  -- 基础配置
  require('basic')
  -- 快捷键映射
  require("keybindings")
  -- 主题设置 
  require("colorscheme")
  -- 插件配置
  require("plugin-config.nvim-tree")
  require("plugin-config.bufferline")
  require("plugin-config.lualine")
  require("plugin-config.dashboard")
  require("plugin-config.project")
  require("plugin-config.telescope")
  require('telescope').load_extension('projects')
  require("plugin-config.nvim-cmp")
  require("plugin-config.lsp")
  require("plugin-config.kind")

  -- WSL 下的剪贴板配置，使用 clip.exe
  if vim.fn.has('unix') == 1 and vim.fn.system('uname') == 'Linux\n' then
  local wsl_check = vim.fn.system('grep -i microsoft /proc/version')
  if wsl_check ~= '' then
    -- vim.opt.clipboard = 'unnamedplus'
    vim.g.clipboard = {
      name = 'WslClipboard',
      copy = {
          ['+'] = 'clip.exe',
          ['*'] = 'clip.exe',
      },
      paste = {
          ['+'] = 'powershell.exe Get-Clipboard',
          ['*'] = 'powershell.exe Get-Clipboard',
      },
      cache_enabled = 0,
    }
    end
  end

  if packer_bootstrap then
    require('packer').sync()
  end
end)


