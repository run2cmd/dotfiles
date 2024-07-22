local wezterm = require('wezterm')
config = {}

config.font = wezterm.font('Hermit')
config.font_size = 10.0

config.hide_tab_bar_if_only_one_tab = true

config.colors = {
  background = 'Gray15',
}

config.default_prog = { 'wsl.exe', '-d', 'Debian', '--cd', '~' }

return config
