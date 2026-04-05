vim.opt_local.tabstop = 8
vim.opt_local.shiftwidth = 8
vim.opt_local.expandtab = false

vim.opt_local.commentstring = "/* %s */"

local status, conform = pcall(require, "conform")

if status then
	print("clansds")
	conform.formatters_by_ft.c = { "clang-format" }
	conform.formatters["clang-format"] = {
		prepend_args = {
			"--style={\
				BasedOnStyle: LLVM,\
				TabWidth: 8,\
				IndentWidth: 8,\
				UseTab: Always,\
				\
				BreakBeforeBraces: Linux,\
			}",
		},
	}
end
