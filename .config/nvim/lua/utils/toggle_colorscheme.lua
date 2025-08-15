local M = {}

local schemes = { "cyberdream", "dracula" }
local current = 1

function M.toggle ()
  current = current % #schemes + 1
  vim.cmd.colorscheme(schemes[current])
  print("Colorscheme: " .. schemes[current])
end

return M
