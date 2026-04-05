vim.pack.add({
	"https://github.com/stevearc/conform.nvim",
})

require("conform").setup({
	notify_on_error = true,
	format_on_save = {
		timeout_ms = 300,
		lsp_format = "fallback",
	},
})
