local function on_attach(client, bufnr)
	local function keymap(mode, lhs, rhs, desc)
		vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
	end

	local fzf = require("fzf-lua")

	-- code navigation
	keymap("n", "gd", fzf.lsp_definitions, "Show lsp definitions")
	keymap("n", "gD", function()
		vim.cmd("tab split")
		vim.lsp.buf.definition()
	end, "Show lsp definition in new tab")
	keymap("n", "grt", fzf.lsp_typedefs, "Show lsp type definitions")
	keymap("n", "gri", fzf.lsp_implementations, "Show lsp implementations")
	keymap("n", "grr", fzf.lsp_references, "Show lsp references")
	keymap("n", "grc", fzf.lsp_incoming_calls, "Show lsp incoming calls")
	keymap("n", "gO", fzf.lsp_document_symbols, "Show document symbols")

	if client:supports_method("textDocument/documentHighlight") then
		vim.api.nvim_create_autocmd({ "CursorHold", "InsertLeave" }, {
			desc = "Highlight references under the cursor",
			buffer = bufnr,
			callback = vim.lsp.buf.document_highlight,
		})
		vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter", "BufLeave" }, {
			desc = "Clear highlight references",
			buffer = bufnr,
			callback = vim.lsp.buf.clear_references,
		})
	end
end

vim.api.nvim_create_autocmd("LspAttach", {
	desc = "Configure lsps",
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if not client then
			return
		end

		on_attach(client, args.buf)
	end,
})

-- enable lsp servers from lsp directory
vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
	once = true,
	callback = function()
		local server_configs = vim.iter(vim.api.nvim_get_runtime_file("lsp/*.lua", true))
			:map(function(file)
				return vim.fn.fnamemodify(file, ":t:r")
			end)
			:totable()
		vim.lsp.enable(server_configs)
	end,
})
