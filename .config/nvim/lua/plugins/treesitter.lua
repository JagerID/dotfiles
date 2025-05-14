return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function ()
		local treesitter_configs = require("nvim-treesitter.configs")
		treesitter_configs.setup({
			ensure_installed = {
				"c",
				"lua",
				"typescript"
			},
			auto_install = true,
			hightlight = {
				enable = true,
				disable = { "c", "rust" },
			}
		})
	end
}
