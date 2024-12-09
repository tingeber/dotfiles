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
	['micro'] = 'µ',
  ['htop'] = wezterm.nerdfonts.cod_dashboard
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
    -- heavily modified right-slanted rainbow palette for tab bars
    -- works with catpuccin frappe colors
    -- thanks to https://github.com/nekowinston/wezterm-bar/blob/main/plugin/init.lua

    -- grab colors
		local colours = config.resolved_palette.tab_bar

    -- identify the active tab
    local active_tab_index = 0
    for _, t in ipairs(tabs) do
      if t.is_active == true then
        active_tab_index = t.tab_index
      end
    end

    -- make a rainbow palette
    local rainbow = {
      config.resolved_palette.ansi[2],
      config.resolved_palette.indexed[16],
      config.resolved_palette.ansi[4],
      config.resolved_palette.ansi[3],
      config.resolved_palette.ansi[5],
      config.resolved_palette.ansi[6],
    }

    -- assign the rainbow palette to up to 6 tabs, then repeat
    local i = tab.tab_index % 6
    local active_bg = rainbow[i + 1]
    local active_fg = colours.background
    local inactive_bg = colours.inactive_tab.bg_color
    local inactive_fg = colours.inactive_tab.fg_color
    local new_tab_bg = colours.new_tab.bg_color

    local s_bg, s_fg, e_bg, e_fg

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

    -- check if there's unseen output in an inactive tab
		local has_unseen_output = false
		for _, pane in ipairs(tab.panes) do
			if pane.has_unseen_output then
				has_unseen_output = true
				break
			end
		end

    -- grab the directory name and clean it up, and get the process name
		local cwd = wezterm.format({
			{ Text = get_current_working_dir(tab) },
		})
		local process = get_process(tab)
		local title = process and string.format(' %s %s ', process, cwd) or ' [?] '

    -- change text color of inactive tabs if there's unseen activity
		if has_unseen_output then
			return {
        { Background = { Color = s_bg } },
				{ Foreground = { Color = config.resolved_palette.ansi[6]}},
				{ Text = title },
        { Background = { Color = e_bg } },
        { Foreground = { Color = e_fg } },
        {Text = utf8.char(0xe0bc)}
			}
		end

    -- print a pretty slanted rainbow colored tab with process and directory name
		return {
			{ Background = { Color = s_bg } },
      { Foreground = { Color = s_fg } },
      { Text = title },
      { Background = { Color = e_bg } },
      { Foreground = { Color = e_fg } },
      {Text = utf8.char(0xe0bc)}
		}
	end
)

-- wezterm.on('update-right-status', function(window, pane)
--   local cwd_uri = pane:get_current_working_dir()


--   -- I like my date/time in this style: "Wed Mar 3 08:14"
--   local date = wezterm.strftime '%a %b %-d %H:%M'
--   table.insert(cells, date)

--   window:set_right_status(wezterm.format{{ Text = cwd_uri }})
-- end)

wezterm.on('update-right-status', function(window, pane)
  local cwd_uri = pane:get_current_working_dir()
  local domain = pane:get_domain_name()
  -- local inactiveColor = config.resolved_palette.tab_bar.inactive_tab.bg_color
  -- Make it italic and underlined
  local frappe = {
		rosewater = "#f2d5cf",
		flamingo = "#eebebe",
		pink = "#f4b8e4",
		mauve = "#ca9ee6",
		red = "#e78284",
		maroon = "#ea999c",
		peach = "#ef9f76",
		yellow = "#e5c890",
		green = "#a6d189",
		teal = "#81c8be",
		sky = "#99d1db",
		sapphire = "#85c1dc",
		blue = "#8caaee",
		lavender = "#babbf1",
		text = "#c6d0f5",
		subtext1 = "#b5bfe2",
		subtext0 = "#a5adce",
		overlay2 = "#949cbb",
		overlay1 = "#838ba7",
		overlay0 = "#737994",
		surface2 = "#626880",
		surface1 = "#51576d",
		surface0 = "#414559",
		base = "#303446",
		mantle = "#292c3c",
		crust = "#232634",
	}

  window:set_right_status(wezterm.format {
    { Background = { Color = frappe.surface0}},
    { Foreground = { Color = frappe.crust}},
    {Text = utf8.char(0xe0bc)},
    -- {Attribute={Italic=true}},
    { Background = { Color = frappe.surface0}},
    { Foreground = { Color = frappe.lavender}},
    { Text = ' ' ..cwd_uri.file_path.. ' ' },
    -- { Text = ' ' ..domain.. ' ' },
    -- { Background = { Color = config.resolved_palette.ansi[2]}},
    -- { Foreground = { Color = config.resolved_palette.ansi[6]}},
  })
end)

-- font config
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




-- and finally, return the configuration to wezterm
return config
