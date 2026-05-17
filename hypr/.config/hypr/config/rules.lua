hl.window_rule({ match = { class = ".*" }, suppress_event = "maximize" })

-- remove borders when there is a single window in workspace
hl.window_rule({ match = { float = false, workspace = "w[tv1]" }, border_size = 0 })
hl.window_rule({ match = { float = false, workspace = "f[1]" }, border_size = 0 })

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

-- disable screenshare for certain apps
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

hl.window_rule({ match = { class = "^(personal.ghostty)$" }, workspace = "1" })
hl.window_rule({ match = { class = "^(firefox-personal)$" }, workspace = "2" })
hl.window_rule({ match = { class = "^(org.mozilla.Thunderbird)$" }, workspace = "3" })
hl.window_rule({ match = { class = "^(sone)$" }, workspace = "4" })
