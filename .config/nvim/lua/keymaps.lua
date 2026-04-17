-- Explorer
vim.keymap.set("n", "<leader>e", ":Oil<CR>", { silent = true })
vim.api.nvim_create_autocmd("FileType", {
	pattern = "oil",
	callback = function()
		vim.keymap.set("n", "q", function()
			vim.api.nvim_buf_delete(0, { force = true })
		end, { noremap = true, silent = true, buf = 0 })
	end,
})

-- Fzf
local fzf = require("fzf-lua")
vim.keymap.set("n", "<leader>ff", fzf.files)
vim.keymap.set("n", "<leader>fb", fzf.buffers)

-- Buffers
vim.keymap.set("n", "<C-n>", ":botright vnew<CR>")
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- Move
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==")
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==")
vim.keymap.set("n", "<A-Down>", ":m .+1<CR>==")
vim.keymap.set("n", "<A-Up>", ":m .-2<CR>==")

vim.keymap.set("v", "<A-j>", ":m '>+1<CR><Esc>gv")
vim.keymap.set("v", "<A-k>", ":m '<-2<CR><Esc>gv")
