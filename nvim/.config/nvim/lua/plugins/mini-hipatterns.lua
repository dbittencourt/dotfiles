vim.pack.add({ { src = "https://github.com/nvim-mini/mini.hipatterns" } })

-- highlight color codes (probably not required after neovim 0.12)
local hipatterns = require("mini.hipatterns")
hipatterns.setup({
	highlighters = {
		-- #rrggbb
		hex_color = hipatterns.gen_highlighter.hex_color({ priority = 2000 }),
		-- rgb(255, 255, 255)
		rgb_color = {
			pattern = "rgb%(%d+, ?%d+, ?%d+%)",
			group = function(_, match)
				local red, green, blue = match:match("rgb%((%d+), ?(%d+), ?(%d+)%)")
				local hex = string.format("#%02x%02x%02x", red, green, blue)
				return hipatterns.compute_hex_color_group(hex, "bg")
			end,
			priority = 2000,
		},
		-- rgba(255, 255, 255, 0.5)
		rgba_color = {
			pattern = "rgba%(%d+, ?%d+, ?%d+, ?%d*%.?%d*%)",
			group = function(_, match)
				local r_str, g_str, b_str, a_str = match:match("rgba%((%d+), ?(%d+), ?(%d+), ?(%d*%.?%d*)%)")
				local alpha = tonumber(a_str)
				if
					not (
						tonumber(r_str)
						and tonumber(g_str)
						and tonumber(b_str)
						and alpha
						and alpha >= 0
						and alpha <= 1
					)
				then
					return false
				end
				local hex = string.format("#%02x%02x%02x", r_str, g_str, b_str)
				return hipatterns.compute_hex_color_group(hex, "bg")
			end,
			priority = 2000,
		},
	},
})
