return {
	"ibhagwan/fzf-lua",
	config = function()
		local fzf = require("fzf-lua")

		fzf.setup({
			defaults = {
				-- configure results format to name followed by directory
				formatter = { "path.filename_first", 2 },
				keymap = {
					fzf = {
						-- send all current search results to quickfix list
						["ctrl-q"] = "select-all+accept",
					},
				},
				actions = {
					-- open selection in new tab with ctrl+t
					["ctrl-t"] = fzf.actions.file_tabedit,
				},
			},
			winopts = {
				preview = {
					layout = "vertical",
					vertical = "down:60%",
				},
			},
			oldfiles = {
				-- restrict buffers from cwd to avoid confusion when switching projects
				cwd_only = true,
				winopts = {
					preview = { hidden = true },
				},
			},
			files = {
				winopts = {
					preview = { hidden = true },
				},
				actions = {
					["ctrl-i"] = fzf.actions.toggle_ignore,
					["ctrl-h"] = fzf.actions.toggle_hidden,
				},
			},
			diagnostics = {
				multiline = 1,
			},
			{
				undotree =
					-- use git-delta diff
					{ previewer = "undotree_native" },
			},
		})

		fzf.register_ui_select()

		local set = vim.keymap.set
		set("n", "<leader>u", fzf.undotree, { desc = "Show Undo tree" })
		set("n", "<leader>fd", fzf.diagnostics_document, { desc = "Show document diagnostics" })
		set("n", "<leader>fd", fzf.diagnostics_document, { desc = "Show document diagnostics" })
		set("n", "<leader>ff", fzf.files, { desc = "Search file in cwd" })
		set("n", "<leader>fb", fzf.buffers, { desc = "Show open buffers" })
		set("n", "<leader>fs", fzf.live_grep, { desc = "Live search string in cwd" })
		set("n", "<leader>fg", fzf.grep, { desc = "Search string in cwd" })
		set("v", "<leader>fv", fzf.grep_visual, { desc = "Search selection in cwd" })
		set("n", "<leader>fp", function()
			vim.ui.input({
				prompt = "File Pattern: ",
				default = "*.",
			}, function(pattern)
				if not pattern or pattern == "" then
					return
				end

				fzf.live_grep({ rg_opts = "-i --glob " .. vim.fn.shellescape(pattern) })
			end)
		end, { desc = "Search string in specific filetypes within cwd" })
	end,
}
