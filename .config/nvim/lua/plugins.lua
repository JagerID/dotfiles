-- Theme
vim.pack.add({
	{ src = "https://github.com/nyoom-engineering/oxocarbon.nvim" },
	{ src = "https://github.com/scottmckendry/cyberdream.nvim" },
})

vim.cmd("colorscheme cyberdream")

-- Mason
vim.pack.add({ "https://github.com/mason-org/mason.nvim" })
require("mason").setup({})

-- Fzf
vim.pack.add({ "https://github.com/ibhagwan/fzf-lua" })
local actions = require("fzf-lua.actions")
require("fzf-lua").setup({
	winopts = { backdrop = 85 },
	keymap = {
		builtin = {
			["<C-f>"] = "preview-page-down",
			["<C-b>"] = "preview-page-up",
			["<C-p>"] = "toggle-preview",
		},
		fzf = {
			["ctrl-a"] = "toggle-all",
			["ctrl-t"] = "first",
			["ctrl-g"] = "last",
			["ctrl-d"] = "half-page-down",
			["ctrl-u"] = "half-page-up",
		},
	},
	actions = {
		files = {
			["ctrl-q"] = actions.file_sel_to_qf,
			["ctrl-n"] = actions.toggle_ignore,
			["ctrl-h"] = actions.toggle_hidden,
			["enter"] = actions.file_edit_or_qf,
		},
	},
})

-- Blink
vim.pack.add({
	{ src = "https://github.com/saghen/blink.cmp", vim.version.range("*") },
})

require("blink.cmp").setup({
	fuzzy = {
		implementation = "prefer_rust_with_warning",
	},
	signature = { enabled = true },
	keymap = {
		preset = "default",
		["<C-p>"] = {},
		["<Tab>"] = {},
		["<S-Tab>"] = {},
		["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
		["<CR>"] = { "select_and_accept", "fallback" },
		["<C-k>"] = { "select_prev", "fallback" },
		["<C-j>"] = { "select_next", "fallback" },
	},

	appearance = {
		use_nvim_cmp_as_default = true,
		nerd_font_variant = "mono",
	},

	completion = {
		ghost_text = { enabled = true },

		documentation = {
			auto_show = true,
			auto_show_delay_ms = 200,
		},

		menu = {
			auto_show = true,
			auto_show_delay_ms = 200,
		},
	},

	cmdline = {
		completion = {
			list = {
				selection = {
					preselect = false,
				},
			},
		},
		keymap = {
			preset = "inherit",
			["<CR>"] = { "accept_and_enter", "fallback" },
		},
	},

	sources = {
		default = {
			"lsp",
			"buffer",
			"path",
		},
	},
})

-- Treesitter
vim.pack.add({
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", name = "nvim-treesitter" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" }, -- для умной навигации
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter-context" }, -- для липких заголовков
})

require("nvim-treesitter").setup({
	ensure_installed = {
		"typescript",
		"markdown",
	},

	auto_install = true,

	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},

	indent = {
		enable = true,
	},

	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "<C-space>",
			node_incremental = "<C-space>",
			scope_incremental = "<bs>",
			node_decremental = "<M-space>",
		},
	},
})

-- Which key
vim.pack.add({ "https://github.com/folke/which-key.nvim" })

-- Conform (formatter)
vim.pack.add({ "https://github.com/stevearc/conform.nvim" })

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		javascript = { "prettierd", "prettier", stop_after_first = true },
		c = { "clang-format" },
	},
	formatters = {
		["clang-format"] = {
			prepend_args = {
				"-style={\
					BasedOnStyle: LLVM,\
					\
					TabWidth: 8,\
					IndentWidth: 8,\
					UseTab: Always,\
					\
					ColumnLimit: 80,\
					BreakBeforeBraces: Allman,\
					AlignAfterOpenBracket: Align,\
					AllowShortFunctionsOnASingleLine: None,\
					IndentCaseLabels: true,\
					\
					AllowShortIfStatementsOnASingleLine: false,\
					AllowShortLoopsOnASingleLine: false\
				}",
			},
		},
	},
})

-- Mini icons
vim.pack.add({ "https://github.com/nvim-mini/mini.icons" })
require("mini.icons").setup()

-- Flash
vim.pack.add({ "https://github.com/folke/flash.nvim" })
require("flash")

-- Noice (ui)
vim.pack.add({
	{ src = "https://github.com/folke/noice.nvim" },
	{ src = "https://github.com/MunifTanjim/nui.nvim" },
	{ src = "https://github.com/rcarriga/nvim-notify" },
})

require("notify").setup({
	render = "compact",
})

require("noice").setup()
