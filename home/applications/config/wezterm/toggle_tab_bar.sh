#!/usr/bin/env sh
grep -q 'config.enable_tab_bar = false' ~/.config/wezterm/wezterm.lua && sed -i 's/config.enable_tab_bar = false/config.enable_tab_bar = true/' ~/.config/wezterm/wezterm.lua || sed -i 's/config.enable_tab_bar = true/config.enable_tab_bar = false/' ~/.config/wezterm/wezterm.lua
