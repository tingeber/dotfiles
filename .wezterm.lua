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

-- let's give each tab a directory name

function basename(s)
	local string = tostring(s)
  return string.gsub(string, '(.*[/\\])(.*)', '%2')
end

-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
function tab_title(tab_info)
  local title = tab_info.tab_title
  -- if the tab title is explicitly set, take that
  -- if title and #title > 0 then
  --   return title
  -- end
  -- Otherwise, use the title from the active pane
  -- in that tab
  return basename(tab_info.active_pane.current_working_dir)
end


-- tabs have current folder and process icon
-- thanks to https://github.com/protiumx/.dotfiles/blob/main/stow/wezterm/.config/wezterm/wezterm.lua

local process_icons = {
  ['docker'] = wezterm.nerdfonts.linux_docker,
  ['docker-compose'] = wezterm.nerdfonts.linux_docker,
  ['btm'] = '',
  ['psql'] = '󱤢',
  ['usql'] = '󱤢',
  ['kuberlr'] = wezterm.nerdfonts.linux_docker,
  ['ssh'] = wezterm.nerdfonts.fa_exchange,
  ['ssh-add'] = wezterm.nerdfonts.fa_exchange,
  ['kubectl'] = wezterm.nerdfonts.linux_docker,
  ['stern'] = wezterm.nerdfonts.linux_docker,
  ['nvim'] = wezterm.nerdfonts.custom_vim,
  ['vim'] = wezterm.nerdfonts.dev_vim,
  ['make'] = wezterm.nerdfonts.seti_makefile,
  ['node'] = wezterm.nerdfonts.mdi_hexagon,
  ['go'] = wezterm.nerdfonts.seti_go,
  ['python3'] = wezterm.nerdfonts.dev_python,
  ['Python'] = wezterm.nerdfonts.dev_python,
  ['zsh'] = wezterm.nerdfonts.dev_terminal,
  ['bash'] = wezterm.nerdfonts.cod_terminal_bash,
  ['htop'] = wezterm.nerdfonts.mdi_chart_donut_variant,
  ['cargo'] = wezterm.nerdfonts.dev_rust,
  ['sudo'] = wezterm.nerdfonts.fa_hashtag,
  ['lazydocker'] = wezterm.nerdfonts.linux_docker,
  ['git'] = wezterm.nerdfonts.dev_git,
  ['lua'] = wezterm.nerdfonts.seti_lua,
  ['wget'] = wezterm.nerdfonts.mdi_arrow_down_box,
  ['curl'] = wezterm.nerdfonts.mdi_flattr,
  ['gh'] = wezterm.nerdfonts.dev_github_badge,
  ['ruby'] = wezterm.nerdfonts.cod_ruby,
	['node'] = wezterm.nerdfonts.dev_nodejs_small,
	['npm'] = wezterm.nerdfonts.dev_npm,
	['micro'] = 'µ'
}

local function get_current_working_dir(tab)
  local current_dir = tab.active_pane and tab.active_pane.current_working_dir or { file_path = '' }
  local HOME_DIR = os.getenv('HOME')

  return current_dir.file_path == HOME_DIR and '~'
    or string.gsub(current_dir.file_path, '(.*[/\\])(.*)', '%2')
end

local function get_process(tab)
  if not tab.active_pane or tab.active_pane.foreground_process_name == '' then
    return nil
  end

  local process_name = string.gsub(tab.active_pane.foreground_process_name, '(.*[/\\])(.*)', '%2')
  if string.find(process_name, 'kubectl') then
    process_name = 'kubectl'
  end

  return process_icons[process_name] or string.format('[%s]', process_name)
end

wezterm.on(
	'format-tab-title',
	function(tab, tabs, panes, config, hover, max_width)
		local colours = config.resolved_palette.tab_bar

    local active_tab_index = 0
    for _, t in ipairs(tabs) do
      if t.is_active == true then
        active_tab_index = t.tab_index
      end
    end

    -- TODO: make colors configurable
    local rainbow = {
      -- config.resolved_palette.ansi[2],
      config.resolved_palette.indexed[16],
      config.resolved_palette.ansi[4],
      config.resolved_palette.ansi[3],
      config.resolved_palette.ansi[5],
      config.resolved_palette.ansi[6],
    }

    local i = tab.tab_index % 6
    local active_bg = rainbow[i + 1]
    local active_fg = colours.background
    local inactive_bg = colours.inactive_tab.bg_color
    local inactive_fg = colours.inactive_tab.fg_color
    local new_tab_bg = colours.new_tab.bg_color

    local s_bg, s_fg, e_bg, e_fg

    -- the last tab
    if tab.tab_index == #tabs - 1 then
      if tab.is_active then
        s_bg = active_bg
        s_fg = active_fg
        e_bg = new_tab_bg
        e_fg = active_bg
      else
        s_bg = inactive_bg
        s_fg = inactive_fg
        e_bg = new_tab_bg
        e_fg = inactive_bg
      end
    elseif tab.tab_index == active_tab_index - 1 then
      s_bg = inactive_bg
      s_fg = inactive_fg
      e_bg = rainbow[(i + 1) % 6 + 1]
      e_fg = inactive_bg
    elseif tab.is_active then
      s_bg = active_bg
      s_fg = active_fg
      e_bg = inactive_bg
      e_fg = active_bg
    else
      s_bg = inactive_bg
      s_fg = inactive_fg
      e_bg = inactive_bg
      e_fg = inactive_bg
    end


		local has_unseen_output = false
		for _, pane in ipairs(tab.panes) do
			if pane.has_unseen_output then
				has_unseen_output = true
				break
			end
		end


		local cwd = wezterm.format({
			{ Text = get_current_working_dir(tab) },
		})

		local process = get_process(tab)
		local title = process and string.format(' %s %s ', process, cwd) or ' [?] '

		if has_unseen_output then
			return {
				{ Foreground = { Color = config.resolved_palette.ansi[6]}},
				{ Text = title },
			}
		end

		return {
			{ Background = { Color = s_bg } },
      { Foreground = { Color = s_fg } },
      { Text = title },
      { Background = { Color = e_bg } },
      { Foreground = { Color = e_fg } },
		}
	end
)


-- config.font = wezterm.font("MesloLGS Nerd Font")
-- config.font = wezterm.font("FiraCode Nerd Font")
config.font = wezterm.font("CaskaydiaCove Nerd Font")
config.font_size = 14
config.line_height = 1.2


config.default_cursor_style = 'SteadyUnderline'
-- Acceptable values are SteadyBlock, BlinkingBlock, SteadyUnderline, BlinkingUnderline, SteadyBar, and BlinkingBar

-- config.enable_tab_bar = false
-- config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.tab_max_width = 32

config.window_decorations = "RESIZE"
-- config.window_background_opacity = 0.9
-- config.macos_window_background_blur = 8


-- a plugin for a pretty tab, with cattpuccin
-- wezterm.plugin.require("https://github.com/nekowinston/wezterm-bar").apply_to_config(config, {
--   position = "bottom",
--   max_width = 32,
--   dividers = "slant_right", -- or "slant_left", "arrows", "rounded", false
--   indicator = {
--     leader = {
--       enabled = false,
--       off = " ",
--       on = " ",
--     },
--     mode = {
--       enabled = false,
--       names = {
--         resize_mode = "RESIZE",
--         copy_mode = "VISUAL",
--         search_mode = "SEARCH",
--       },
--     },
--   },
--   tabs = {
--     numerals = "arabic", -- or "roman"
--     pane_count = "superscript", -- or "subscript", false
--     brackets = {
--       active = { "", ":" },
--       inactive = { "", ":" },
--     },
--   },
--   clock = { -- note that this overrides the whole set_right_status
--     enabled = true,
--     format = "%H:%M", -- use https://wezfurlong.org/wezterm/config/lua/wezterm.time/Time/format.html
--   },
-- })




-- and finally, return the configuration to wezterm
return config
