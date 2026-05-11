local main_mod = "SUPER"
local hyper = "SUPER + SHIFT + CTRL + ALT"

-- special actions
hl.bind(main_mod .. " + q", hl.dsp.window.close())
hl.bind(main_mod .. " + m", hl.dsp.exit())
hl.bind(main_mod .. " + v", hl.dsp.window.float({ action = "toggle" }))
hl.bind(main_mod .. " + f", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind(main_mod .. " + space", hl.dsp.exec_cmd("rofi -show drun"))
hl.bind(main_mod .. " + SHIFT + a", hl.dsp.exec_cmd("$HOME/.config/hypr/scripts/toggle-audio.sh"))
hl.bind(main_mod .. " + SHIFT + q", hl.dsp.exec_cmd("hyprlock"))
hl.bind(main_mod .. " + SHIFT + s", hl.dsp.exec_cmd('hyprshot -z -m region -o "$HOME/Screenshots"'))

-- app shortcuts
hl.bind(hyper .. " + T", function()
	for _, window in ipairs(hl.get_windows()) do
		if window.mapped and window.class == "personal.ghostty" then
			hl.dispatch(hl.dsp.focus({ window = window }))
			return
		end
	end

	hl.exec_cmd("ghostty --class=personal.ghostty")
end)
hl.bind(hyper .. " + B", hl.dsp.exec_cmd("firefox --name=firefox-personal"))
hl.bind(hyper .. " + E", hl.dsp.exec_cmd("thunderbird"))
hl.bind(hyper .. " + M", hl.dsp.exec_cmd("sone"))
hl.bind(hyper .. " + F", hl.dsp.exec_cmd("ghostty --class=yazi.ghostty -e yazi"))
hl.bind(hyper .. " + A", hl.dsp.exec_cmd("ghostty --class=btop.ghostty -e btop"))
hl.bind(hyper .. " + P", hl.dsp.exec_cmd("hyprpicker"))

local directions = {
	{ key = "left", direction = "l" },
	{ key = "h", direction = "l" },
	{ key = "right", direction = "r" },
	{ key = "l", direction = "r" },
	{ key = "up", direction = "u" },
	{ key = "k", direction = "u" },
	{ key = "down", direction = "d" },
	{ key = "j", direction = "d" },
}
for _, bind in ipairs(directions) do
	-- move focus with main_mod + arrow keys
	hl.bind(main_mod .. " + " .. bind.key, hl.dsp.focus({ direction = bind.direction }))
	-- move window with main_mod + shift + arrow keys
	hl.bind(main_mod .. " + SHIFT + " .. bind.key, hl.dsp.window.move({ direction = bind.direction }))
end

-- window split ratio with main_mod plus minus or equal
hl.bind(main_mod .. " + minus", hl.dsp.layout("splitratio -0.1"), { repeating = true })
hl.bind(main_mod .. " + equal", hl.dsp.layout("splitratio +0.1"), { repeating = true })

-- switch workspaces and move active windows with main_mod plus numbers
for ws = 1, 10 do
	local key = tostring(ws % 10)

	hl.bind(main_mod .. " + " .. key, hl.dsp.focus({ workspace = ws }))
	hl.bind(main_mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = ws }))
end

-- scroll through existing workspaces with main_mod plus scroll
hl.bind(main_mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(main_mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- move and resize windows with main_mod plus mouse drag
hl.bind(main_mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(main_mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- multimedia keys
local media_binds = {
	{
		key = "XF86AudioRaiseVolume",
		cmd = "wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+",
		repeating = true,
	},
	{
		key = "XF86AudioLowerVolume",
		cmd = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-",
		repeating = true,
	},
	{ key = "XF86AudioMute", cmd = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle" },
	{ key = "XF86AudioMicMute", cmd = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle" },
	{
		key = "XF86MonBrightnessUp",
		cmd = "$HOME/dotfiles/scripts/brightness.sh up",
		repeating = true,
	},
	{
		key = "XF86MonBrightnessDown",
		cmd = "$HOME/dotfiles/scripts/brightness.sh down",
		repeating = true,
	},
	{ key = "XF86AudioNext", cmd = "playerctl next" },
	{ key = "XF86AudioPause", cmd = "playerctl play-pause" },
	{ key = "XF86AudioPlay", cmd = "playerctl play-pause" },
	{ key = "XF86AudioPrev", cmd = "playerctl previous" },
}

for _, bind in ipairs(media_binds) do
	hl.bind(bind.key, hl.dsp.exec_cmd(bind.cmd), {
		locked = true,
		repeating = bind.repeating == true,
	})
end
