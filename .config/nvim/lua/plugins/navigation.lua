vim.pack.add({
	"https://github.com/stevearc/oil.nvim",
	"https://github.com/nvim-mini/mini.nvim",
	"https://github.com/folke/flash.nvim",
	"https://github.com/ibhagwan/fzf-lua",
})

require("mini.icons").setup()

require("flash").setup()

require("oil").setup({
	default_file_explorer = true,
	columns = {
		"icon",
		"size",
	},
})
