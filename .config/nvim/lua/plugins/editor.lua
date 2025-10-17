return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		--@type Flash.Config
		opts = {},
	},
	{
		"catgoose/nvim-colorizer.lua",
		event = "BufReadPre",
		opts = {},
	},
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {},
	},
	{ "folke/todo-comments.nvim", opts = {} },
	{ "numToStr/Comment.nvim", opts = {} },
	{
		"stevearc/oil.nvim",
		---@module 'oil'
		---@type oil.SetupOpts
		opts = {
			default_file_explorer = true,
			columns = { "icon", "size", "mtime" },
			delete_to_trash = true,
			skip_confirm_for_simple_edits = true,
			watch_for_changes = true,
			view_options = {
				show_hidden = true,
				natural_order = true,
				is_always_hidden = function(name, _)
					return name == ".." or name == ".git"
				end,
			},

			win_options = { wrap = true },
		},
		keys = {
			{ "<leader>e", "<CMD>Oil<CR>", desc = "Open File Explorer (Oil)" },
		},
		--   Optional dependencies
		dependencies = { { "echasnovski/mini.icons", opts = {} } },
		lazy = false,
	},
	{
		"benomahony/oil-git.nvim",
	},
	{
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "VeryLazy",
		opts = {},
	},
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				rust = { "rustfmt", lsp_format = "fallback" },
				javascript = { "prettierd", "prettier", stop_after_first = true },
				typescript = { "prettierd", "prettier", stop_after_first = true },
				lua = { "stylua", lsp_format = "fallback" },
				conf = { "nginxfmt", lsp_format = "fallback" },
			},
			format_on_save = {
				timeout_ms = 200,
				lsp_format = "fallback",
			},
		},
	},
	{
		"mfussenegger/nvim-lint",
		config = function()
			local lint = require("lint")

			lint.linters_by_ft = {
				javascript = { "eslint_d" },
				typescript = { "eslint_d" },
				lua = { "luacheck" },
        nu = { "nu" },
			}

			--[[ vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
				callback = function()
					lint.try_lint()
				end,
			}) ]]
		end,
	},
	{ "sphamba/smear-cursor.nvim", opts = {} },
	{
		"nvimdev/dashboard-nvim",
		event = "VimEnter",
		opts = {},
	},
	-- {
	--   "nvim-tree/nvim-tree.lua",
	--   opts = {
	--     disable_netrw = true,
	--     hijack_netrw = true,
	--     open_on_tab = false,
	--     hijack_cursor = true,
	--     update_cwd = true,
	--     actions = {
	--       open_file = {
	--         quit_on_open = false
	--       }
	--     },
	--     view = {
	--       width = 30,
	--       adaptive_size = true,
	--     },
	--     renderer = {
	--       icons = {
	--         show = {
	--           git = true,
	--           folder = true,
	--           file = true,
	--           folder_arrow = true
	--         }
	--       }
	--     },
	--     filters = {
	--       dotfiles = true,
	--       custom = { ".git", "node_modules", ".cache" }
	--     },
	--     git = {
	--       enable = true,
	--       ignore = false,
	--       timeout = 500,
	--     }
	--   },
	--   keys = {
	--     { "<leader>e",  "<cmd>NvimTreeToggle<cr>",   desc = "Nvim Tree Toggle" },
	--     { "<leader>ff", "<cmd>NvimTreeFindFile<cr>", desc = "Nvim Tree Find File" }
	--   }
	-- }
}
