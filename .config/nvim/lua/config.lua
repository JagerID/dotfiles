vim.opt.number = true -- номера строк
vim.opt.relativenumber = true -- относительные номера

vim.opt.tabstop = 4 -- длина таба (в пробелах
vim.opt.shiftwidth = 4 -- .. не знаю в чем отличие
vim.opt.expandtab = false -- заменять ли таб на пробелы

vim.opt.splitbelow = true -- новые h-windows открываются снизу
vim.opt.splitright = true -- новые v-windows открываются снизу
vim.opt.ignorecase = true -- игнорировать регистр при поиске vim.opt.smartcase	= true	-- .. но учитывать его, если в запросе есть заглавная буква

vim.opt.cursorline = true -- подсвечивать строку, на которой стоит курсор
vim.opt.termguicolors = true -- поддержка 24битных цветов

vim.opt.list = true -- включить отображение невидимых символов
vim.opt.listchars = {
	tab = "> ", -- табы
	trail = ".", -- пробелы в конце строки
	nbsp = "␣", -- неразрывный пробел
	extends = "→", -- строка уходит за край экрана справа
	precedes = "←", -- .. слева
	eol = "↲", -- конец строки
}

vim.opt.clipboard = "unnamedplus"
