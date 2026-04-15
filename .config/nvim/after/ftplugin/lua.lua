vim.opt_local.tabstop = 2       -- длина таба (в пробелах
vim.opt_local.shiftwidth = 2    -- .. не знаю в чем отличие
vim.opt_local.expandtab = false -- заменять ли таб на пробелы


local status, conform = pcall(require, "conform")

if status then
	conform.formatters_by_ft.lua = { "stylua" }
end
