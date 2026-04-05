local status, conform = pcall(require, "conform")

if status then
	conform.formatters_by_ft.scss = { "prettierd" }
end
