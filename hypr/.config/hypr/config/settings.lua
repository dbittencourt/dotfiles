hl.config({
	general = {
		gaps_in = 2,
		gaps_out = 4,
		border_size = 1,
		col = {
			active_border = "rgb(1f1f28)",
		},
		resize_on_border = true,
		allow_tearing = false,
		layout = "dwindle",
	},
	group = {
		col = {
			border_active = "rgb(c4b28a)",
		},
		groupbar = {
			col = {
				active = "rgb(c4b28a)",
			},
		},
	},
	decoration = {
		rounding = 4,
		rounding_power = 2,
		active_opacity = 1.0,
		inactive_opacity = 1.0,
		shadow = {
			enabled = true,
		},
		blur = {
			enabled = true,
		},
	},
	animations = {
		enabled = true,
	},
	dwindle = {
		preserve_split = true,
	},
	master = {
		new_status = "master",
	},
	misc = {
		force_default_wallpaper = 0,
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		mouse_move_enables_dpms = true,
		key_press_enables_dpms = true,
	},
	input = {
		kb_layout = "us",
		repeat_rate = 50,
		repeat_delay = 250,
		follow_mouse = 1,
		sensitivity = 0,
		touchpad = {
			natural_scroll = true,
		},
	},
	cursor = {
		inactive_timeout = 5,
	},
	xwayland = {
		force_zero_scaling = true,
	},
	ecosystem = {
		no_donation_nag = true,
		no_update_news = true,
	},
})
