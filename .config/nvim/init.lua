require("vim._core.ui2").enable()

vim.filetype.add({
	extension = {
		h = "c",
	},
})

require("config")
require("plugins")
require("parsers")
require("autocmd")
require("keymaps")
