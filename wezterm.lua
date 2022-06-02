local wezterm = require 'wezterm';

return {
  -- Fonts 
  font = wezterm.font('Consolas');
  font_size = 11.0;
  font_antialias = 'Greyscale';

  -- Tabs
  hide_tab_bar_if_only_one_tab = true;

  --  Colors
  colors = {
    background = 'Gray18';
  }
}
