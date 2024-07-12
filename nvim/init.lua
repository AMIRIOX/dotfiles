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
  --[[  
  use {"Pu-gayhub/CodeRunner.nvim",
      config = function()
        require"CodeRunner".setup {
            -- 你可以在此处自定义不同语言的执行方式
            tasks = {
            c = "make", -- 可以是字符串，会发送到浮动终端执行
            python = "python <file>", -- 尖括号标记预定义变量。见下方变量。
            lua = function() -- 也可以执行一个函数
            vim.cmd("luafile %") -- 使用 VIM API
            end,
          },
          -- 此处可自定义浮动终端样式
          style = {
          -- 边框，见 `:help nvim_open_win`
          border = "rounded", -- 圆角边框
          -- 终端背景色
          bgcolor = "NONE", -- NONE 为透明
          -- 终端大小和位置，为百分数相对位置
          layout = {
          width = .8, -- 80% 编辑器大小
          height = .8,
          x = .5, -- 在编辑器中间
         y = .5
            }
          }
        }
     end
  }
]]

-- 基础配置
require('basic')
-- 快捷键映射
require("keybindings")
-- Packer 插件管理
-- require('plugins').startup()

-- 主题设置 （新增）
require("colorscheme")
-- 插件配置
require("plugin-config.nvim-tree")
require("plugin-config.bufferline")
require("plugin-config.lualine")
require("plugin-config.dashboard")
require("plugin-config.project")
require("plugin-config.telescope")
require('telescope').load_extension('projects')


  if packer_bootstrap then
    require('packer').sync()
  end
end)





