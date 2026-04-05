local capabilities = require("blink.cmp").get_lsp_capabilities()

vim.lsp.start({
	name = "clangd",
	cmd = { "clangd" },
	capabilities = capabilities,
	root_markers = {
		".git",
		".clangd",
		".clangd-format",
		"compile_commands.json",
		"compile_flags.txt",
		"Makefile",
	},
})
