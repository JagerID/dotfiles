local ag = vim.api.nvim_create_augroup

local highlight_group = ag("YankHightlight", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({ timeout = 100 })
	end,
	group = highlight_group,
})

local ts_fold_group = ag("TreesitterFolding", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "c", "lua", "rust", "javascript", "typescript" },
	callback = function()
		print("autocmd")
		vim.treesitter.start()
		vim.opt_local.foldmethod = "expr"
		vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr ()"
	end,
	group = ts_fold_group,
})

local blink_group = ag("Blink", { clear = true })

vim.api.nvim_create_autocmd("PackChanged", {
	pattern = "*",
	callback = function(ev)
		if ev.data.spec.name == "blink.cmp" then
			vim.notify("Building blink.cmp", vim.log.levels.INFO)
			local obj = vim.system(
				{ "cargo", "build", "--release" },
				{ cwd = vim.fn.stdpath("data") .. "/site/pack/core/opt/blink.cmp" }
			):wait()

			if obj.code == 0 then
				vim.notify("Building blink.cmp done", vim.log.levels.INFO)
			else
				vim.notify("Building blink.cmp failed", vim.log.levels.ERROR)
			end
		end
	end,
	group = blink_group,
})

local conform_group = ag("Conform", { clear = true })

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
	group = conform_group,
})
