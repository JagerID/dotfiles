vim.pack.add({
	"https://github.com/stevearc/oil.nvim",
	"https://github.com/nvim-mini/mini.nvim",
	"https://github.com/folke/flash.nvim",
	"https://github.com/ibhagwan/fzf-lua",
	"https://github.com/folke/which-key.nvim",
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

require("fzf-lua").setup({
	profile = "ivy",

	winopts = {
		height = 0.6,
		width = 0.75,
		row = 0.5,
		col = 0.5,

		border = "rounded",
	},

	preview = {
		layout = "flex",
		flip_columns = 120,
		delay = 10,
	},

	files = {
		formatter = "path.filename_first",
		git_icons = true,
		devicons = true,
	},
})
