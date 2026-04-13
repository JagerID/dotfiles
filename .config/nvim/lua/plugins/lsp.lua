vim.pack.add({
	"https://github.com/mason-org/mason.nvim",

	"https://github.com/saghen/blink.cmp",
	"https://github.com/folke/lazydev.nvim",

	"https://github.com/folke/trouble.nvim",
})

require("mason").setup()

require("lazydev").setup({
	-- library = {
	-- 	{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
	-- 	{ path = "blink.cmp", words = { "blink" } },
	-- },
})

require("blink.cmp").setup({
	fuzzy = { implementation = "prefer_rust_with_warning" },

	completion = {
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 200,
		},

		ghost_text = { enabled = false },

		menu = {
			auto_show = true,
			auto_show_delay_ms = 150,
			border = "rounded",

			draw = {
				columns = {
					{ "kind_icon", "kind", gap = 1 },
					{ "label", "label_description", gap = 1 },
				},
			},
		},
	},

	keymap = {
		preset = "none",

		["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
		["<C-e>"] = { "hide" },

		["<CR>"] = { "select_and_accept", "fallback" },

		["<Tab>"] = { "select_next", "fallback" },
		["<S-Tab>"] = { "select_prev", "fallback" },
	},

	appearance = {
		use_nvim_cmp_as_default = false,
		nerd_font_variant = "mono",
	},

	signature = {
		enabled = true,
		window = { border = "rounded" },
	},

	sources = {
		default = { "lazydev", "lsp", "path", "buffer" },

		providers = {
			lazydev = {
				name = "LazyDev",
				module = "lazydev.integrations.blink",
				score_offset = 100,
			},
		},
	},
})

require("trouble").setup()
