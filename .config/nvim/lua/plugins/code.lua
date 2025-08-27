return {
  {
    "mrcjkb/rustaceanvim",
    ft = { "rust" },
    version = "*"
  },
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUedate",
    opts = {}
  },
  {
    "saghen/blink.cmp",
    opts = {
      sources = {
        default = { "lazydev", "lsp", "path", "buffer", "snippets" },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100
          }
        }
      },
      keymap = {
        ["<CR>"] = { "accept", "fallback" }
      },
      completion = {
        documentation = { auto_show = true },
        ghost_text = { enabled = true }
      },
      appearance = {
        use_nvim_cp_as_default = false,
        nerd_font_variant = "mono"
      }
    }
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
    end
  },
  { "williamboman/mason.nvim", opts = {} },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {}
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } }
      }
    }
  }
}
