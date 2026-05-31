local obs = os.getenv("HOME") .. "/.config/obs-studio/scripts/obs.sh"

hl.bind("SUPER + ALT + O", hl.dsp.exec_cmd(obs .. " open"))
hl.bind("SUPER + ALT + R", hl.dsp.exec_cmd(obs .. " recording toggle"))
hl.bind("SUPER + ALT + P", hl.dsp.exec_cmd(obs .. " recording toggle-pause"))
hl.bind("SUPER + ALT + 6", hl.dsp.exec_cmd(obs .. " scene switch scene_talking"))
hl.bind("SUPER + ALT + 7", hl.dsp.exec_cmd(obs .. " scene switch scene_programming"))
hl.bind("SUPER + ALT + 8", hl.dsp.exec_cmd(obs .. " scene switch scene_browser"))

hl.window_rule({ match = { class = [[^com\.obsproject\.Studio$]] }, workspace = "6" })

hl.window_rule({
	match = { class = [[^obs\.ghostty$]] },
	workspace = "7",
	float = true,
	center = true,
	size = { 1920, 1080 },
})

hl.window_rule({
	match = { class = "^(firefox-obs)$" },
	workspace = "8",
	float = true,
	center = true,
	size = { 1920, 1080 },
})
