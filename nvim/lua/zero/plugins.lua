-- Plugins live in ~/.local/share/nvim/site/
-- plugins in start/ are automatically loaded (not lazy loaded)
-- plugins in opt/ are lazy loaded. 
-- You can send a plugin to opt/ instead of start by specifying opt = true in the use statement
-- Lazy loaded plugins will startup and run when one of their commands are run for the first time

local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Nvim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads nvim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we dont error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  print "Packer not found"
  return
end

-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

-- Install Plugins here
return packer.startup(function(use)
  -- My plugins here
  use "wbthomason/packer.nvim"  -- Have packer manage itself
  use "nvim-lua/popup.nvim"     -- An implementation of the Popup API from vim in Nvim
  use "nvim-lua/plenary.nvim"   -- Useful lua functions used by lots of plugins
  use "numToStr/Comment.nvim"   -- Easy commenting
  use "nvim-tree/nvim-web-devicons"
  use "nvim-tree/nvim-tree.lua"
  use "akinsho/bufferline.nvim"
  use "moll/vim-bbye"
  use "folke/which-key.nvim"
  use "goolord/alpha-nvim"
  use "nvim-lualine/lualine.nvim"
  use "akinsho/toggleterm.nvim"

  -- Colour Scheme 
  use { "catppuccin/nvim", as = "catpupuccin" }

  -- completions plugins
  use "hrsh7th/nvim-cmp"         -- The completion plugin
  use "hrsh7th/cmp-buffer"       -- Buffer completions
  use "hrsh7th/cmp-path"         -- path completions
  use "hrsh7th/cmp-cmdline"      -- cmdline compeltions
  use "saadparwaiz1/cmp_luasnip" -- snippet completions
  use "hrsh7th/cmp-nvim-lsp"     -- nvim completions 
  use "hrsh7th/cmp-nvim-lua"     -- lua completions 

  -- snippets
  use "L3MON4D3/LuaSnip"             -- snippet engine
  use "rafamadriz/friendly-snippets" -- a bunch of snippets to use

  -- LSP 
  use "neovim/nvim-lspconfig" -- enable LSP
  use "williamboman/mason.nvim" -- simple to use language server installer
  use "williamboman/mason-lspconfig.nvim"
  use "jose-elias-alvarez/null-ls.nvim" -- for formatters and linters
  use "RRethy/vim-illuminate"
  use "simrat39/rust-tools.nvim"

  -- Telescope
  use "nvim-telescope/telescope.nvim"
  use "nvim-telescope/telescope-media-files.nvim"

  -- Treesitter 
  use {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
  }
  use "HiPhish/rainbow-delimiters.nvim"
  use "JoosepAlviste/nvim-ts-context-commentstring"

  -- Autopairs
  use "windwp/nvim-autopairs"

  -- Git
  use "lewis6991/gitsigns.nvim"

  -- ooooo AI... spooooky..
  use {
  'Exafunction/codeium.vim',
  config = function ()
    -- Change '<C-g>' here to any keycode you like.
    vim.keymap.set('i', '<C-a>', function () return vim.fn['codeium#Accept']() end, { expr = true })
    vim.keymap.set('i', '<C-;>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true })
    vim.keymap.set('i', '<C-,>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true })
    vim.keymap.set('i', '<C-x>', function() return vim.fn['codeium#Clear']() end, { expr = true })
  end
}
use {'saecki/crates.nvim'}

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
