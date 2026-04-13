vim.pack.add({
	"https://github.com/folke/tokyonight.nvim",
	"https://github.com/navarasu/onedark.nvim",
	"https://github.com/loctvl842/monokai-pro.nvim",
	"https://github.com/scottmckendry/cyberdream.nvim",
	"https://github.com/zootedb0t/citruszest.nvim",
	"https://github.com/DonJulve/NeoCyberVim",
})

require("onedark").setup({ style = "deep" })

vim.cmd("colorscheme cyberdream")
