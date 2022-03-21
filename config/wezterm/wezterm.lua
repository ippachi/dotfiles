local wezterm = require 'wezterm';

return {
  font = wezterm.font("FiraCode Nerd Font"),
  color_scheme = "Gruvbox Dark",
  tab_bar_at_bottom = true,
  keys = {
   {key="Enter", mods="CTRL|SHIFT", action=wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}}},
   {key="Enter", mods="CTRL|SHIFT|ALT", action=wezterm.action{SplitVertical={domain="CurrentPaneDomain"}}},
   {key=",", mods="SHIFT|CTRL", action="QuickSelect"},
  }
}
