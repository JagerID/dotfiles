vim.pack.add({
	"https://github.com/stevearc/conform.nvim",
})

require("conform").setup({
	notify_on_error = true,
	format_on_save = {
		timeout_ms = 300,
		lsp_format = "fallback",
	},

	formatters_by_ft = {
		sh = { "shfmt" },
		bash = { "shfmt" },
		zsh = { "shfmt" },
	},

	formatters = {
		shfmt = {
			prepend_args = { "-i", "2", "-ci", "-sr" },
			condition = function()
				return true
			end,
		},
	},
})
