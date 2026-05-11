require("config.settings")
require("config.animations")
require("config.keybindings")
require("config.rules")

-- autostart
hl.on("hyprland.start", function()
	hl.exec_cmd("hyprpaper")
	hl.exec_cmd("hypridle")
	hl.exec_cmd("hyprsunset -S")
	hl.exec_cmd("waybar")
	hl.exec_cmd("dunst")
	hl.exec_cmd("nm-applet")
	hl.exec_cmd("solaar --window=hide")
	hl.exec_cmd("systemctl --user start hyprpolkitagent")
end)

-- environment variables
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("GDK_SCALE", "2")

-- monitors
hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "auto",
})

hl.monitor({
	output = "DP-1",
	mode = "3840x2560@120Hz",
	scale = "auto",
	bitdepth = 10,
	vrr = 2,
})
