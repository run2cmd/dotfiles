local wezterm = require('wezterm')
config = {}

config.font = wezterm.font('Hermit')
config.font_size = 10.0

config.hide_tab_bar_if_only_one_tab = true

config.colors = {
  background = 'Gray15',
}

config.default_domain = 'WSL:Debian'

config.keys = {
  {
    key = 'j',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.SpawnTab {
      DomainName = 'local',
    },
  }
}

return config
