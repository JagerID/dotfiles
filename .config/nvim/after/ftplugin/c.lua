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
				IndentWidth: 8,\
				TabWidth: 8,\
				UseTab: Always,\
				\
				MaxEmptyLinesToKeep: 1,\
				IncludeBlocks: Regroup,\
				SeparateDefinitionBlocks: Always,\
				\
				AlignAfterOpenBracket: true,\
				AlignArrayOfStructures: Right,\
				AlignConsecutiveAssignments: {\
					Enabled: true,\
					AcrossEmptyLines: false,\
					AcrossComments: true,\
				},\
				\
				AllowShortBlocksOnASingleLine: Empty,\
				AllowShortFunctionsOnASingleLine: Empty,\
				AllowShortIfStatementsOnASingleLine: false,\
				\
				BreakBeforeBraces: Custom,\
				BraceWrapping: {\
					AfterEnum: false,\
					AfterStruct: false,\
					AfterUnion: false,\
					AfterFunction: true,\
				},\
				\
				SpacesInParens: Custom,\
				SpacesInParensOptions: {\
					InConditionalStatements: true,\
					ExceptDoubleParentheses: false,\
					Other: true,\
				}\
			}",
		},
	}
end
