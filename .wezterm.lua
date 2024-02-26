local wezterm = require "wezterm"
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.color_scheme = 'Dracula'
config.enable_tab_bar = false
config.font = wezterm.font('FiraCode')
config.font_size = 12
config.cell_width = 1.0
config.line_height = 1.1
config.keys = {
  {
    key = 'F11',
    action = wezterm.action.ToggleFullScreen,
  },
}
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

-- Program

config.default_prog = { '/bin/zsh', '-l' }

-- CWD

config.default_cwd = "/home/jager/dev"

-- Cursor

config.default_cursor_style = 'BlinkingBar'
config.cursor_thickness = 2
config.cursor_blink_rate = 400
config.cursor_blink_ease_in = 'Linear'

return config
