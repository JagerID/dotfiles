local wezterm = require "wezterm"
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.color_scheme = 'dracula'
config.font = wezterm.font('IosevkaNerdFont')
config.font_size = 12
config.cell_width = 1.0
config.line_height = 1.1
config.keys = {
  {
    key = 'F11',
    action = wezterm.action.ToggleFullScreen,
  },
}

-- Window

config.window_padding = {
  left = 5,
  right = 0,
  top = 0,
  bottom = 0,
}
config.window_decorations = "NONE"
config.window_background_opacity = .8
config.max_fps = 165
config.window_close_confirmation = "NeverPrompt"

-- Tabs

config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false

-- Animation

config.animation_fps = 165

-- Program

config.default_prog = { '/bin/zsh', '-l' }

-- CWD

config.default_cwd = "/home/jager/dev"

-- Cursor

config.default_cursor_style = 'BlinkingBar'
config.cursor_thickness = 2
config.cursor_blink_rate = 700
config.cursor_blink_ease_in = 'Linear'

-- Hyperlinks

config.hyperlink_rules = {
      -- Matches: a URL in parens: (URL)
      {
         regex = '\\((\\w+://\\S+)\\)',
         format = '$1',
         highlight = 1,
      },
      -- Matches: a URL in brackets: [URL]
      {
         regex = '\\[(\\w+://\\S+)\\]',
         format = '$1',
         highlight = 1,
      },
      -- Matches: a URL in curly braces: {URL}
      {
         regex = '\\{(\\w+://\\S+)\\}',
         format = '$1',
         highlight = 1,
      },
      -- Matches: a URL in angle brackets: <URL>
      {
         regex = '<(\\w+://\\S+)>',
         format = '$1',
         highlight = 1,
      },
      -- Then handle URLs not wrapped in brackets
      {
         regex = '\\b\\w+://\\S+[)/a-zA-Z0-9-]+',
         format = '$0',
      },
      -- implicit mailto link
      {
         regex = '\\b\\w+@[\\w-]+(\\.[\\w-]+)+\\b',
         format = 'mailto:$0',
      },
   }

return config
