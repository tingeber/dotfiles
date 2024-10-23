-- Pull in the wezterm API
local wezterm = require("wezterm")
local mux = wezterm.mux

wezterm.on('gui-startup', function(cmd)
	local tab, pane, window = mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

config.color_scheme = 'Catppuccin Frappe'



-- config.font = wezterm.font("MesloLGS Nerd Font")
-- config.font = wezterm.font("FiraCode Nerd Font")
config.font = wezterm.font("CaskaydiaCove Nerd Font")
config.font_size = 14
config.line_height = 1.2


config.default_cursor_style = 'SteadyUnderline'
-- Acceptable values are SteadyBlock, BlinkingBlock, SteadyUnderline, BlinkingUnderline, SteadyBar, and BlinkingBar

-- config.enable_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = true

config.window_decorations = "RESIZE"
-- config.window_background_opacity = 0.9
-- config.macos_window_background_blur = 8

-- and finally, return the configuration to wezterm
return config
