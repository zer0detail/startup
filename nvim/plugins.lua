local plugins = {
  {
   "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "html",
        "css",
        "javascript",
        "json",
        "c",
        "cpp",
        "python",
        "rust",
        "bash",
        "dockerfile",
        "toml",
        "yaml",
      },
      indent = {
        enable = true,
      },
    }
  },
  {
    "nvim-tree/nvim-tree.lua",
    opts = {

      git = {
        enable = true,
      },
      renderer = {
        highlight_git = true,
        icons = {
          show = {
            git = true,
          },
        },
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "clangd",
        "clang-format",
        "rust-analyzer",
        "pyright",
        "ruff",
        "mypy",
        "black",
        "debugpy",
        "codelldb",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
  },
  {
      "jose-elias-alvarez/null-ls.nvim",
      ft = {"python"},
      opts = function()
        return require "custom.configs.null-ls"
      end,
  },
  {
      "rust-lang/rust.vim",
      ft = "rust",
      init = function ()
          vim.g.rustfmt_autosave = 1
      end
  },
  {
      "simrat39/rust-tools.nvim",
      ft = require("custom.configs.rust-tools").filetype,
      dependencies = require("custom.configs.rust-tools").dependencies,
      config = require("custom.configs.rust-tools").config
  },
  {
      "mfussenegger/nvim-dap",
      config = function(_, opts)
          require("core.utils").load_mappings("dap")
      end
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    event = "VeryLazy",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    opts = {
      handlers = {}
    },
  },
  {
      "mfussenegger/nvim-dap-python",
      ft = "python",
      dependencies = {
          "mfussenegger/nvim-dap",
          "rcarriga/nvim-dap-ui",
      },
      config = function(_, opts)
          local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
          require("dap-python").setup(path)
          require("core.utils").load_mappings("dap_python")
      end,
  },
  {
      "rcarriga/nvim-dap-ui",
      event = "VeryLazy",
      dependencies = "mfussenegger/nvim-dap",
      config = function()
          local dap = require("dap")
          local dapui = require("dapui")
          dapui.setup()
          dap.listeners.after.event_initialized["dapui_config"] = function ()
              dapui.open()
          end
          dap.listeners.before.event_terminated["dapui_config"] = function()
              dapui.close()
          end
          dap.listeners.before.event_exited["dapui_config"] = function()
              dapui.close()
          end
      end
  },
  {
      "saecki/crates.nvim",
      dependencies = "hrsh7th/nvim-cmp",
      ft = {"rust", "toml"},
      config = function(_, opts)
          local crates = require('crates')
          crates.setup(opts)
          crates.show()
      end,
  },
  { "hrsh7th/nvim-cmp",
      opts = function()
          local M = require "plugins.configs.cmp"
          table.insert(M.sources, {name = "crates"})
          return M
      end,
  },
  { "hrsh7th/cmp-vsnip" },
}
return plugins
