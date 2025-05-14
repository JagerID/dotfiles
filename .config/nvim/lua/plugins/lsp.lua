return {
	{
		"neovim/nvim-lspconfig",
		opts = {},
		lazy = true,
	},
	{
		"mason-org/mason.nvim",
		opts = {},
		lazy = true,
	},
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {
			ensure_installed = {
				"lua_ls",
				"glslls",
				"tailwindcss",
				"jsonls"
			}
		}
	},
}

