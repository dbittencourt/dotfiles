-- install with script install-roslyn.sh

local roslyn_command = {
	"Microsoft.CodeAnalysis.LanguageServer",
	"--logLevel",
	"Information",
	"--extensionLogDirectory",
	vim.fs.joinpath(vim.uv.os_tmpdir(), "roslyn_ls/logs"),
	"--stdio",
}

local roslyn_env = {
	-- todo: figure out how to configure secrets
	Configuration = vim.env.Configuration or "Debug",
}

local function roslyn_handlers()
	return {
		["workspace/projectInitializationComplete"] = function(_, _, ctx)
			local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
			local buffers = vim.lsp.get_buffers_by_client_id(ctx.client_id)
			for _, buf in ipairs(buffers) do
				local params = { textDocument = vim.lsp.util.make_text_document_params(buf) }
				client:request(vim.lsp.protocol.Methods.textDocument_diagnostic, params, nil, buf)
			end
		end,
		["workspace/_roslyn_projectHasUnresolvedDependencies"] = function()
			vim.notify("Detected missing dependencies. Run `dotnet restore` command.", vim.log.levels.ERROR, {
				title = "roslyn_ls",
			})
			return vim.NIL
		end,
		["workspace/refreshSourceGeneratedDocument"] = function(_, _, ctx)
			local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
			for _, buf in ipairs(vim.api.nvim_list_bufs()) do
				local uri = vim.api.nvim_buf_get_name(buf)
				if vim.api.nvim_buf_get_name(buf):match("^roslyn%-source%-generated://") then
					local function handler(err, result)
						assert(not err, vim.inspect(err))
						if vim.b[buf].resultId == result.resultId then
							return
						end
						local content = result.text
						if content == nil then
							content = ""
						end
						local normalized = string.gsub(content, "\r\n", "\n")
						local source_lines = vim.split(normalized, "\n", { plain = true })
						vim.bo[buf].modifiable = true
						vim.api.nvim_buf_set_lines(buf, 0, -1, false, source_lines)
						vim.b[buf].resultId = result.resultId
						vim.bo[buf].modifiable = false
					end

					local params = {
						textDocument = {
							uri = uri,
						},
						resultId = vim.b[buf].resultId,
					}

					client:request("sourceGeneratedDocument/_roslyn_getText", params, handler, buf)
				end
			end
		end,
		["workspace/_roslyn_projectNeedsRestore"] = function(_, result, ctx)
			local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
			client:request("workspace/_roslyn_restore", result, function(err, _)
				if err then
					vim.notify(err.message, vim.log.levels.ERROR, { title = "roslyn_ls" })
				end
			end)
			return vim.NIL
		end,
		["razor/provideDynamicFileInfo"] = function(_, _, _)
			vim.notify(
				"Razor is not supported.\nPlease use https://github.com/tris203/rzls.nvim",
				vim.log.levels.WARN,
				{ title = "roslyn_ls" }
			)
			return vim.NIL
		end,
	}
end

local function get_root_dir(bufnr, cb)
	local bufname = vim.api.nvim_buf_get_name(bufnr)
	-- don't try to find sln or csproj for files from libraries outside of the project
	if not bufname:match("^" .. vim.fs.joinpath("/tmp/MetadataAsSource/")) then
		-- try find solutions root first
		local root = vim.fs.root(bufnr, function(fname, _)
			return fname:match("%.sln$") ~= nil
		end)

		if not root then
			-- try find projects root
			root = vim.fs.root(bufnr, function(fname, _)
				return fname:match("%.csproj$") ~= nil
			end)
		end

		if root then
			cb(root)
		end
	end
end

local on_init = {
	function(client)
		local root_dir = client.config.root_dir
		local sln_file
		local csproj_files = {}

		for entry, type in vim.fs.dir(root_dir) do
			if type == "file" then
				if vim.endswith(entry, ".sln") then
					sln_file = entry
					break
				elseif vim.endswith(entry, ".csproj") then
					table.insert(csproj_files, entry)
				end
			end
		end

		if sln_file then
			client:notify("solution/open", {
				solution = vim.uri_from_fname(vim.fs.joinpath(root_dir, sln_file)),
			})
			return
		end

		if #csproj_files > 0 then
			client:notify("project/open", {
				projects = vim.tbl_map(function(file)
					return vim.uri_from_fname(vim.fs.joinpath(root_dir, file))
				end, csproj_files),
			})
		end
	end,
}

local capabilities = {
	-- HACK: Doesn't show any diagnostics if we do not set this to true
	textDocument = {
		diagnostic = {
			dynamicRegistration = true,
		},
	},
}

local roslyn_settings = {
	["csharp|background_analysis"] = {
		dotnet_analyzer_diagnostics_scope = "fullSolution",
		dotnet_compiler_diagnostics_scope = "fullSolution",
	},
	["csharp|inlay_hints"] = {
		csharp_enable_inlay_hints_for_implicit_object_creation = false,
		csharp_enable_inlay_hints_for_implicit_variable_types = false,
		csharp_enable_inlay_hints_for_lambda_parameter_types = false,
		csharp_enable_inlay_hints_for_types = false,
		dotnet_enable_inlay_hints_for_indexer_parameters = false,
		dotnet_enable_inlay_hints_for_literal_parameters = false,
		dotnet_enable_inlay_hints_for_object_creation_parameters = false,
		dotnet_enable_inlay_hints_for_other_parameters = false,
		dotnet_enable_inlay_hints_for_parameters = false,
		dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = false,
		dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = false,
		dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = false,
	},
	["csharp|symbol_search"] = {
		dotnet_search_reference_assemblies = true,
	},
	["csharp|completion"] = {
		dotnet_show_name_completion_suggestions = true,
		dotnet_show_completion_items_from_unimported_namespaces = true,
		dotnet_provide_regex_completions = true,
	},
	["csharp|code_lens"] = {
		dotnet_enable_references_code_lens = true,
	},
	["csharp|document_analysis"] = {
		dotnet_format_on_type = true,
		dotnet_enable_pull_diagnostics = true,
	},
	["editorconfig"] = {
		enable = true,
	},
}

return {
	name = "roslyn",
	cmd = roslyn_command,
	cmd_env = roslyn_env,
	filetypes = { "cs" },
	handlers = roslyn_handlers(),
	root_dir = get_root_dir,
	on_init = on_init,
	capabilities = capabilities,
	settings = roslyn_settings,
}
