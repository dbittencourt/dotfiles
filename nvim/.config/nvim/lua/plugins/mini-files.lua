vim.pack.add({ { src = "https://github.com/nvim-mini/mini.files" } })

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
			vim.lsp.protocol.Methods.workspace_willRenameFiles, vim.lsp.protocol.Methods.workspace_didRenameFiles
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
