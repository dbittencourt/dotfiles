local speed = 1

hl.curve("quick", {
	type = "bezier",
	points = { { 0.15, 0 }, { 0.1, 1 } },
})

-- default speed for any unset animation leaf
hl.animation({
	leaf = "global",
	enabled = true,
	speed = speed,
	bezier = "quick",
})

-- keep window animations fast and direct
hl.animation({
	leaf = "windows",
	enabled = true,
	speed = speed,
	bezier = "quick",
	style = "popin 87%",
})

-- keep opacity transitions fast
hl.animation({
	leaf = "fade",
	enabled = true,
	speed = speed,
	bezier = "quick",
})

-- avoid sliding workspace motion
hl.animation({
	leaf = "workspaces",
	enabled = true,
	speed = speed,
	bezier = "quick",
	style = "fade",
})
