vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.expandtab = false

local capabilities = require("blink.cmp").get_lsp_capabilities()

vim.lsp.start({
	name = "lua_ls",
	cmd = { "lua-language-server" },
	capabilities = capabilities,
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			workspace = { checkThirdParty = false },
			diagnostics = { globals = { "vim" } },
		},
	},
})
