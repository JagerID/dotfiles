local keymap = vim.keymap

keymap.set ( "n", "<leader>e", "<Cmd>Explore<CR>" )

local fzf = require ( "fzf-lua" )
keymap.set ( "n", "<leader><leader>", fzf.files )
keymap.set ( "n", "<leader>/", fzf.live_grep )
