local home = os.getenv("HOME")

-- File chooser via XDG portal for gtk3 apps
hl.env("GTK_USE_PORTAL", "1")

hl.env("CAELESTIA_SCREENSHOTS_DIR", home .. "/media/screenshots")
hl.env("CAELESTIA_RECORDINGS_DIR", home .. "/media/recordings")

---- MONITORS -------------
-- Catch-all rule: every monitor at preferred mode, auto position, 1.25 scale
hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = 1.25,
})

--Keyboard layout US + Bulgarian phonetic, switch with Super + Space
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

---- SCROLLING LAYOUT -----
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

-- Toggle between scrolling and dwindle.
local scrollingActive = true
hl.bind("SUPER + CTRL + S", function()
	scrollingActive = not scrollingActive
	hl.config({
		general = {
			layout = scrollingActive and "scrolling" or "dwindle",
		},
	})
end)

---- alt + hjkl = arrows and alt + e = escape
hl.bind("ALT + J", hl.dsp.send_shortcut({ mods = "", key = "down" }))
hl.bind("ALT + K", hl.dsp.send_shortcut({ mods = "", key = "up" }))
hl.bind("ALT + H", hl.dsp.send_shortcut({ mods = "", key = "left" }))
hl.bind("ALT + L", hl.dsp.send_shortcut({ mods = "", key = "right" }))
hl.bind("ALT + E", hl.dsp.send_shortcut({ mods = "", key = "escape" }))

local function smart_copy_paste(key)
	local window = hl.get_active_window()
	local class = window and window.class and window.class:lower() or ""

	if class == "kitty" then
		-- Kitty focused: Ctrl + Shift + C/V
		hl.dispatch(hl.dsp.send_shortcut({ mods = "CTRL + SHIFT", key = key }))
	else
		-- Anything else: Ctrl + C/V
		hl.dispatch(hl.dsp.send_shortcut({ mods = "CTRL", key = key }))
	end
end

-- Bind Alt + c / v to do Ctrl + Shift + c / v if kitty is on focus and Ctrl + c / v otherwise
hl.bind("ALT + c", function()
	smart_copy_paste("c")
end)
hl.bind("ALT + v", function()
	smart_copy_paste("v")
end)
