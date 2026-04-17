vim.opt_local.tabstop = 8
vim.opt_local.shiftwidth = 8
vim.opt_local.expandtab = false

vim.opt_local.commentstring = "/* %s */"

local status, conform = pcall(require, "conform")

if status then
	conform.formatters_by_ft.c = { "clang-format" }
	conform.formatters_by_ft.h = { "clang-format" }
	conform.formatters["clang-format"] = {
		prepend_args = {
			"--style={\
				IndentWidth: 8,\
				TabWidth: 8,\
				UseTab: Always,\
				IndentCaseBlocks: true,\
				ColumnLimit: 0,\
				IndentPPDirectives: BeforeHash,\
				\
				MaxEmptyLinesToKeep: 1,\
				IncludeBlocks: Regroup,\
				SeparateDefinitionBlocks: Always,\
				\
				AlignAfterOpenBracket: true,\
				AlignArrayOfStructures: Right,\
				\
				BreakBeforeBraces: Custom,\
				BraceWrapping: {\
					AfterFunction: true,\
					AfterStruct: false,\
					AfterUnion: false,\
					AfterEnum: false,\
					AfterClass: false,\
					AfterExternBlock: false,\
					\
					AfterCaseLabel: false,\
					AfterControlStatement: Never,\
					BeforeElse: false,\
					\
					IndentBraces: false,\
				},\
				\
				AllowShortFunctionsOnASingleLine: Empty,\
				AllowShortIfStatementsOnASingleLine: Never,\
				AllowShortLoopsOnASingleLine: false,\
				AllowShortLambdasOnASingleLine: All,\
				AllowShortBlocksOnASingleLine: Empty,\
				AllowShortCaseLabelsOnASingleLine: true,\
				\
				AlignConsecutiveAssignments: {\
					Enabled: true,\
					AcrossEmptyLines: false,\
					AcrossComments: true,\
				},\
				\
				SpacesInCStyleCastParentheses: true,\
				SpaceAfterCStyleCast: true,\
				\
				SpacesInParens: Custom,\
				SpacesInParensOptions: {\
					InConditionalStatements: true,\
					ExceptDoubleParentheses: false,\
					InCStyleCasts: true,\
					Other: true,\
				},\
				SpacesInContainerLiterals: true,\
				SpaceBeforeSquareBrackets: true,\
				SpacesInSquareBrackets: true,\
				\
				AlignConsecutiveDeclarations: {\
					Enabled: true,\
					AcrossEmptyLines: false,\
					AcrossComments: true,\
				},\
				\
				AlignTrailingComments: true,\
				\
				SortIncludes: CaseSensitive,\
				\
				PointerAlignment: Right,\
				KeepEmptyLinesAtTheStartOfBlocks: false,\
				\
				SpaceBeforeParens: Custom,\
				SpaceBeforeParensOptions: {\
					AfterControlStatements: true,\
					AfterFunctionDefinitionName: true,\
					AfterFunctionDeclarationName: true,\
					BeforeNonEmptyParentheses: true,\
				}\
			}",
		},
	}
end
