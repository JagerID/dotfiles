vim.keymap.set("n", "<leader>tc", function()
  require("utils.toggle_colorscheme").toggle()
end, { desc = "Toggle Colorscheme" })

vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save changes", noremap = true, silent = true })
