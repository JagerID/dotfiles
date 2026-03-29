local mason_bin = vim.fn.stdpath("data") .. "/mason/bin/"

return {
	cmd = { mason_bin .. "clangd" },
	filetypes = { "c", "cpp" },
}
