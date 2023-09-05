local M = {
}

function M.config()
  local treesitter = require "nvim-treesitter"
  local configs = require "nvim-treesitter.configs"
  -- This module contains a number of default definitions
  local rainbow_delimiters = require 'rainbow-delimiters'
  configs.setup {


    rainbow_delimiters = {
        strategy = {
            [''] = rainbow_delimiters.strategy['global'],
            vim = rainbow_delimiters.strategy['local'],
        },
        query = {
            [''] = 'rainbow-delimiters',
            lua = 'rainbow-blocks',
        },
        highlight = {
            'RainbowDelimiterRed',
            'RainbowDelimiterYellow',
            'RainbowDelimiterBlue',
            'RainbowDelimiterOrange',
            'RainbowDelimiterGreen',
            'RainbowDelimiterViolet',
            'RainbowDelimiterCyan',
        },
    },
    ensure_installed = "all", -- one of 'all', or a list of languages
    sync_install = false, -- install languages synchonously (only applied to `ensure_installed`)
    ignore_install = { "" }, -- List of parsers to ignore installing

    highlight = {
      enable = true, -- false will disable the whole extension
      disable = { "" }, -- list of languages to disable
      additional_vim_regex_highlighting = true,
    },

    autopairs = {
      enable = true,
    },

    indent = { enable = true, disable = { "yaml" } },

    context_commentstring = {
      enable = true,
      enable_autocmd = false,
    },
  }
end

return M
