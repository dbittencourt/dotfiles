hl.window_rule({ match = { class = ".*" }, suppress_event = "maximize" })

hl.window_rule({
	match = { title = "(Volume Control)" },
	float = true,
	size = "70% 70%",
	center = true,
})

local file_dialog_title = "^("
	.. "Open File|Select a File|Choose wallpaper|Open Folder|Save As|Library|File Upload"
	.. ")(.*)$"

hl.window_rule({
	match = { title = file_dialog_title },
	float = true,
	center = true,
})

hl.window_rule({ match = { class = "^(personal.ghostty)$" }, workspace = "1" })
hl.window_rule({ match = { class = "^(firefox-personal)$" }, workspace = "2" })
hl.window_rule({ match = { class = "^(org.mozilla.Thunderbird)$" }, workspace = "3" })
hl.window_rule({ match = { class = "^(sone)$" }, workspace = "4" })

local private_classes = {
	[[^personal\.ghostty$]],
	"^(firefox-personal)$",
	"^(discord)$",
	[[^org\.mozilla\.Thunderbird$]],
	"^(Bitwarden)$",
	[[^com\.yubico\.yubioath$]],
	[[^org\.gnome\.seahorse\.Application$]],
}

for _, class in ipairs(private_classes) do
	hl.window_rule({ match = { class = class }, no_screen_share = true })
end
