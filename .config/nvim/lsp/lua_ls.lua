local mason_bin = vim.fn.stdpath ( "data" ) .. "/mason/bin/"

return {
	cmd = { mason_bin .. "lua-language-server" },
	filetypes = { "lua" },
	root_markers = {
		".luarc.json",
		".luarc.jsonc",
		".luacheckrc",
		".stylua.toml",
		"stylua.toml",
		".git",
	},
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			completion = {
				enable = true,
			},
			diagnostics = {
				enable = true,
				globals = { "vim" },
			},
			workspace = {
				library = {
					vim.env.VIMRUNTIME,
					"${3rd}/luv/library"
			},
				checkThirdParty = false,
			},
			telemetry = { enable = false },
		},
	},
}
