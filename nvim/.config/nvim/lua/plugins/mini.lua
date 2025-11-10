return {
	{
		"nvim-mini/mini.nvim",
		version = false,
		config = function()
			require("mini.icons").setup()

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
							local r_str, g_str, b_str, a_str =
								match:match("rgba%((%d+), ?(%d+), ?(%d+), ?(%d*%.?%d*)%)")
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

			-- text manipulation around selection
			require("mini.surround").setup()

			-- advanced text objects
			local ai = require("mini.ai")
			ai.setup({
				n_lines = 500,
				custom_textobjects = {
					o = ai.gen_spec.treesitter({ -- code block
						a = { "@block.outer", "@conditional.outer", "@loop.outer" },
						i = { "@block.inner", "@conditional.inner", "@loop.inner" },
					}),
					m = ai.gen_spec.treesitter({ -- method/function definition
						a = "@function.outer",
						i = "@function.inner",
					}),
					c = ai.gen_spec.treesitter({ -- class
						a = "@class.outer",
						i = "@class.inner",
					}),
					d = { "%f[%d]%d+" }, -- digits
				},
			})

			-- automatic pair completion
			require("mini.pairs").setup({
				modes = { insert = true, command = true, terminal = false },
				-- skip autopair when next character is one of these
				skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
				-- skip autopair when the cursor is inside these treesitter nodes
				skip_ts = { "string" },
				-- skip autopair when next character is closing pair
				-- and there are more closing pairs than opening pairs
				skip_unbalanced = true,
				-- deals better with markdown code blocks
				markdown = true,
			})

			-- neovim session management
			local sessions = require("mini.sessions")
			sessions.setup()
			local function session_name()
				local name = vim.fn.getcwd():gsub("/", "%%2F") .. ".vim"
				return name
			end
			local function session_path()
				local session_dir = sessions.config.directory or (vim.fn.stdpath("data") .. "/session")
				return session_dir .. "/" .. session_name()
			end

			vim.keymap.set("n", "<leader>ss", function()
				sessions.write(session_name())
			end, { desc = "Save session for current directory" })
			vim.keymap.set("n", "<leader>rs", function()
				if vim.loop.fs_stat(session_path()) then
					sessions.read(session_name())
				else
					vim.notify("Session not found for current directory.", vim.log.levels.WARN)
				end
			end, { desc = "Restore session for current directory" })

			-- file explorer
			local files = require("mini.files")
			files.setup({
				options = { permanent_delete = false },
				windows = {
					max_number = 3,
				},
				mappings = {
					go_in_plus = "<cr>",
					go_out_plus = "<tab>",
				},
			})

			-- manually notify LSPs that a file got modified as for now the plugin
			-- author has no intention to make it the default behaviour
			vim.api.nvim_create_autocmd("User", {
				desc = "Notify LSPs that a file was modified",
				pattern = { "MiniFilesActionRename", "MiniFilesActionMove" },
				callback = function(args)
					local changes = {
						files = {
							{
								oldUri = vim.uri_from_fname(args.data.from),
								newUri = vim.uri_from_fname(args.data.to),
							},
						},
					}
					local will_rename_method, did_rename_method =
						vim.lsp.protocol.Methods.workspace_willRenameFiles,
						vim.lsp.protocol.Methods.workspace_didRenameFiles
					local clients = vim.lsp.get_clients()
					for _, client in ipairs(clients) do
						if client:supports_method(will_rename_method) then
							local res = client:request_sync(will_rename_method, changes, 1000, 0)
							if res and res.result then
								vim.lsp.util.apply_workspace_edit(res.result, client.offset_encoding)
							end
						end
					end

					for _, client in ipairs(clients) do
						if client:supports_method(did_rename_method) then
							client:notify(did_rename_method, changes)
						end
					end
				end,
			})

			vim.keymap.set("n", "<leader>e", function()
				if not files.close() then
					local path
					if vim.bo.buftype == "terminal" then
						path = vim.fn.getcwd()
					else
						path = vim.api.nvim_buf_get_name(0)
					end
					files.open(path)
				end
			end, { desc = "Open file explorer" })

			vim.api.nvim_create_autocmd("User", {
				desc = "Add minifiles keymaps",
				pattern = "MiniFilesBufferCreate",
				callback = function(args)
					local function open_in_new_view(create_view_func)
						local state = files.get_explorer_state()
						if state.target_window == nil or files.get_fs_entry().fs_type == "directory" then
							return
						end

						local new_view = vim.api.nvim_win_call(state.target_window, function()
							create_view_func()
							return vim.api.nvim_get_current_win()
						end)

						files.set_target_window(new_view)
						files.go_in({ close_on_file = true })
					end

					vim.keymap.set("n", "<C-t>", function()
						open_in_new_view(function()
							vim.cmd("tabnew")
						end)
					end, {
						desc = "Open file in a new tab",
						buffer = args.data.buf_id,
					})

					vim.keymap.set("n", "<C-w>v", function()
						open_in_new_view(function()
							vim.cmd("belowright vsplit")
						end)
					end, {
						desc = "Open file in a new vertical split",
						buffer = args.data.buf_id,
					})
				end,
			})
		end,
	},
}
