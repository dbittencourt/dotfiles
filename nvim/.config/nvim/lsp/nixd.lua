local markers = { "flake.nix", ".git" }

return {
	cmd = { "nixd" },
	filetypes = { "nix" },
	root_dir = function(bufnr, on_dir)
		local uri = vim.uri_from_bufnr(bufnr)
		if not vim.startswith(uri, "file://") then
			return
		end

		local path = vim.uri_to_fname(uri)
		on_dir(vim.fs.root(path, markers) or vim.fs.dirname(path))
	end,
}
