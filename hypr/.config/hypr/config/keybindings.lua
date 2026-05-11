local main_mod = "SUPER"
local hyper = "SUPER + SHIFT + CTRL + ALT"

hl.bind(main_mod .. " + q", hl.dsp.window.close())
hl.bind(main_mod .. " + m", hl.dsp.exit())
hl.bind(main_mod .. " + v", hl.dsp.window.float({ action = "toggle" }))
hl.bind(main_mod .. " + f", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind(main_mod .. " + space", hl.dsp.exec_cmd("rofi -show drun"))

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

-- move focus with main_mod plus arrow keys
hl.bind(main_mod .. " + left", hl.dsp.focus({ direction = "l" }))
hl.bind(main_mod .. " + h", hl.dsp.focus({ direction = "l" }))
hl.bind(main_mod .. " + right", hl.dsp.focus({ direction = "r" }))
hl.bind(main_mod .. " + l", hl.dsp.focus({ direction = "r" }))
hl.bind(main_mod .. " + up", hl.dsp.focus({ direction = "u" }))
hl.bind(main_mod .. " + k", hl.dsp.focus({ direction = "u" }))
hl.bind(main_mod .. " + down", hl.dsp.focus({ direction = "d" }))
hl.bind(main_mod .. " + j", hl.dsp.focus({ direction = "d" }))

-- window split ratio with main_mod plus minus or equal
hl.bind(main_mod .. " + minus", hl.dsp.layout("splitratio -0.1"), { repeating = true })
hl.bind(main_mod .. " + equal", hl.dsp.layout("splitratio +0.1"), { repeating = true })

-- move windows with main_mod plus shift and arrow keys
hl.bind(main_mod .. " + SHIFT + left", hl.dsp.window.move({ direction = "l" }))
hl.bind(main_mod .. " + SHIFT + h", hl.dsp.window.move({ direction = "l" }))
hl.bind(main_mod .. " + SHIFT + right", hl.dsp.window.move({ direction = "r" }))
hl.bind(main_mod .. " + SHIFT + l", hl.dsp.window.move({ direction = "r" }))
hl.bind(main_mod .. " + SHIFT + up", hl.dsp.window.move({ direction = "u" }))
hl.bind(main_mod .. " + SHIFT + k", hl.dsp.window.move({ direction = "u" }))
hl.bind(main_mod .. " + SHIFT + down", hl.dsp.window.move({ direction = "d" }))
hl.bind(main_mod .. " + SHIFT + j", hl.dsp.window.move({ direction = "d" }))

-- switch workspaces and move active windows with main_mod plus numbers
for ws = 1, 10 do
	local key = tostring(ws % 10)

	hl.bind(main_mod .. " + " .. key, hl.dsp.focus({ workspace = ws }))
	hl.bind(main_mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = ws }))
end

-- special actions
hl.bind(main_mod .. " + SHIFT + a", hl.dsp.exec_cmd("$HOME/.config/hypr/scripts/toggle-audio.sh"))
hl.bind(main_mod .. " + SHIFT + q", hl.dsp.exec_cmd("hyprlock"))
hl.bind(main_mod .. " + SHIFT + s", hl.dsp.exec_cmd('hyprshot -z -m region -o "$HOME/Screenshots"'))

-- scroll through existing workspaces with main_mod plus scroll
hl.bind(main_mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(main_mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- move and resize windows with main_mod plus mouse drag
hl.bind(main_mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(main_mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- multimedia keys
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86MonBrightnessUp",
	hl.dsp.exec_cmd("$HOME/dotfiles/scripts/brightness.sh up"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86MonBrightnessDown",
	hl.dsp.exec_cmd("$HOME/dotfiles/scripts/brightness.sh down"),
	{ locked = true, repeating = true }
)
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
