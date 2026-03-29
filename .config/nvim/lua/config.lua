local g = vim.g

-- stylua: ignore start

g.mapleader		=	" "		-- установка leader кнопки
g.netrw_banner		=	false		-- отображать ли баннер в netrw

local opt = vim.opt

opt.guicursor		=	"i:block"		-- в режиме i (insert) курсор блочный
opt.number 		=	true			-- нумерация строк
opt.relativenumber 	=	true			-- относительные строки
opt.tabstop 		=	8			-- ширина таба
opt.shiftwidth		=	8			-- всегда такая же, как и tabstop
opt.expandtab		=	false			-- табы в пробелы
opt.colorcolumn		=	"80"			-- подсвечивает 80ю колонку
opt.winborder		=	"rounded"		-- окна с border radius
opt.listchars		=	"tab:> ,multispace:|,eol:↵"
opt.clipboard		=	"unnamedplus"		-- общий буфер обмена с ОС
opt.ignorecase		=	true			-- игнорировать casesensitivity в поиске
opt.swapfile		=	false			-- отключить swap-файлы
opt.list		=	true			-- показывать символы переносов и т.п.
opt.inccommand		=	"nosplit"		-- показывать результат команды в буфере
opt.hlsearch		=	false			-- отключить подсветку после поиска

-- stylua: ignore end

vim.cmd.filetype("plugin indent on")
