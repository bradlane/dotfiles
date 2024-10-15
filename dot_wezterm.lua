local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- emulate tmux
config.leader = { key = "b", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
	-- splitting
	{ mods = "LEADER", key = "-", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ mods = "LEADER", key = "/", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ mods = "LEADER", key = "LeftArrow", action = wezterm.action.ActivatePaneDirection("Left") },
	{ mods = "LEADER", key = "h", action = wezterm.action.ActivatePaneDirection("Left") },
	{ mods = "LEADER", key = "RightArrow", action = wezterm.action.ActivatePaneDirection("Right") },
	{ mods = "LEADER", key = "l", action = wezterm.action.ActivatePaneDirection("Right") },
	{ mods = "LEADER", key = "UpArrow", action = wezterm.action.ActivatePaneDirection("Up") },
	{ mods = "LEADER", key = "k", action = wezterm.action.ActivatePaneDirection("Up") },
	{ mods = "LEADER", key = "DownArrow", action = wezterm.action.ActivatePaneDirection("Down") },
	{ mods = "LEADER", key = "j", action = wezterm.action.ActivatePaneDirection("Down") },
	{ mods = "LEADER", key = "p", action = wezterm.action.ActivateTabRelative(-1) },
	{ mods = "LEADER", key = "n", action = wezterm.action.ActivateTabRelative(1) },
	{ mods = "LEADER", key = "x", action = wezterm.action.CloseCurrentPane({ confirm = false }) },
	{ mods = "LEADER", key = "X", action = wezterm.action.CloseCurrentTab({ confirm = false }) },
	{ mods = "LEADER", key = "c", action = wezterm.action.SpawnTab("CurrentPaneDomain") },
	{
		mods = "LEADER",
		key = "!",
		action = wezterm.action_callback(function(_win, pane)
			local _tab, _ = pane:move_to_new_tab()
		end),
	},
}

for i = 1, 9 do
	-- ALT + number to activate that tab
	table.insert(config.keys, {
		key = tostring(i),
		mods = "LEADER",
		action = wezterm.action.ActivateTab(i - 1),
	})
end

config.color_scheme = "GruvboxDarkHard"
config.font = wezterm.font_with_fallback({
	"CaskaydiaCove Nerd Font Mono",
	"MesloLGS Nerd Font Mono",
	"JetBrains Mono",
})
config.hide_tab_bar_if_only_one_tab = true
config.initial_cols = 180
config.initial_rows = 45
--config.line_height = 1.2
config.use_fancy_tab_bar = false
config.warn_about_missing_glyphs = false
config.window_close_confirmation = "NeverPrompt"

-- Get Platform
local is_macos <const> = wezterm.target_triple:find("darwin") ~= nil
local is_linux <const> = wezterm.target_triple:find("linux") ~= nil
local is_windows <const> = wezterm.target_triple:find("windows") ~= nil

-- MacOS Specific
if is_macos then
	config.font_size = 16
	config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
	config.window_padding = {
		top = "1.5cell",
	}
	config.send_composed_key_when_left_alt_is_pressed = true -- MacOS Fix
end

-- Windows Specific
if is_windows then
	config.default_prog = { "pwsh.exe", "-NoLogo" }
	config.font_size = 14
end

return config
