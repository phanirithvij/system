local wezterm = require 'wezterm'
local os = require 'os'
local mux = wezterm.mux
local act = wezterm.action
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.window_background_opacity = 1
config.font = wezterm.font 'JetBrains Mono'
-- config.color_scheme = 'Tomorrow Night Bright'

config.keys = {
  { key = 'l', mods = 'ALT', action = wezterm.action.ShowLauncher },
  {
    key = 'x',
    mods = 'CMD|SHIFT',
    action = act.ShowTabNavigator,
  },
  {
    key = 'b',
    mods = 'ALT',
    action = act.EmitEvent 'toggle_tab_bar'
  }
}

wezterm.on('toggle_tab_bar', function(window, pane)
  local overrides = window:get_config_overrides() or {}
  window:toast_notification('wezterm', overrides.enable_tab_bar, nil, 4000)
  overrides.enable_tab_bar = not overrides.enable_tab_bar
  window:set_config_overrides(overrides)
end)

-- Window decorations etc
wezterm.on('gui-startup', function(cmd)
  local _, _, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

local window_min = ' 󰖰 '
local window_close = ' 󰅖 '
config.tab_bar_at_bottom = true
config.tab_bar_style = {
    window_hide = window_min,
    window_hide_hover = window_min,
    window_close = window_close,
    window_close_hover = window_close,
}
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.tab_max_width = 20
config.window_decorations="INTEGRATED_BUTTONS|RESIZE"
config.integrated_title_buttons = {}
-- config.integrated_title_buttons = { 'Hide', 'Close' }
config.launch_menu = {}
config.show_new_tab_button_in_tab_bar = false

-- #tab_bar_maker
config.enable_tab_bar = false

-- https://wezfurlong.org/wezterm/config/appearance.html#retro-tab-bar-appearance
config.colors = {
  tab_bar = {
    -- The color of the inactive tab bar edge/divider
    background = 'rgba(0 0 0 0)',

    inactive_tab = {
      bg_color = 'rgba(0 0 0 0)',
      fg_color = '#a0a0a0',
    },

    active_tab = {
      fg_color = '#f0f0f0',
      bg_color = 'rgba(0 0 0 0)',
    },
  },
}

return config

