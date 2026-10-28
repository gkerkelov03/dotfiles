local home = os.getenv("HOME")

---------------------------
---- ENVIRONMENT ----------
---------------------------
-- $HOME is not expanded inside strings, so build the paths in Lua instead.
hl.env("XDG_CONFIG_HOME", home .. "/.config")
hl.env("XDG_CACHE_HOME", home .. "/.cache")
hl.env("XDG_DATA_HOME", home .. "/.local/share")
hl.env("XDG_STATE_HOME", home .. "/.local/state")

hl.env("EDITOR", "nvim")
hl.env("VISUAL", "nvim")
hl.env("SUDO_EDITOR", "nvim")
hl.env("BROWSER", "qutebrowser")
hl.env("PAGER", "bat")

hl.env("DOTNET_ROOT", "/usr/share/dotnet")

---------------------------
---- MONITORS -------------
---------------------------
-- Catch-all rule: every monitor at preferred mode, auto position, 1.25 scale
hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = 1.25,
})

---------------------------
---- INPUT / CURSOR -------
---------------------------
-- US + Bulgarian phonetic, switch with Super + Space
hl.config({
	input = {
		follow_mouse = 0,
		kb_layout = "us,bg",
		kb_variant = ",phonetic",
		kb_options = "grp:win_space_toggle",
	},
	cursor = {
		no_warps = true,
	},
})

---------------------------
---- SCROLLING LAYOUT -----
---------------------------
hl.config({
	general = {
		layout = "scrolling",
	},
	scrolling = {
		column_width = 0.65,
		focus_fit_method = 0, -- 0 = center, 1 = fit
	},
})

hl.bind("SUPER + H", hl.dsp.layout("focus l"))
hl.bind("SUPER + L", hl.dsp.layout("focus r"))
hl.bind("SUPER + SHIFT + H", hl.dsp.layout("swapcol l"))
hl.bind("SUPER + SHIFT + L", hl.dsp.layout("swapcol r"))
hl.bind("SUPER + CTRL + H", hl.dsp.layout("colresize -conf"))
hl.bind("SUPER + CTRL + L", hl.dsp.layout("colresize +conf"))
hl.bind("SUPER + T", hl.dsp.layout("togglefit"))

-- Toggle between scrolling and dwindle.
-- Replaces the old hyprctl getoption/keyword one-liner with native Lua.
local scrollingActive = true
hl.bind("SUPER + CTRL + S", function()
	scrollingActive = not scrollingActive
	hl.config({
		general = {
			layout = scrollingActive and "scrolling" or "dwindle",
		},
	})
end)

---------------------------
---- ALT + HJKL = ARROWS --
---------------------------
-- No `window` given, so the shortcut goes to the active window.
hl.bind("ALT + J", hl.dsp.send_shortcut({ mods = "", key = "down" }))
hl.bind("ALT + K", hl.dsp.send_shortcut({ mods = "", key = "up" }))
hl.bind("ALT + H", hl.dsp.send_shortcut({ mods = "", key = "left" }))
hl.bind("ALT + L", hl.dsp.send_shortcut({ mods = "", key = "right" }))
