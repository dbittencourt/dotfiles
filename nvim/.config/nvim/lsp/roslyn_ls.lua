-- install with script install-roslyn.sh

local roslyn_executable = {
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

local function apply_resolved_action(client, resolved)
	if resolved and resolved.edit then
		vim.lsp.util.apply_workspace_edit(resolved.edit, client.offset_encoding or "utf-16")
	end
	if resolved and resolved.command then
		vim.lsp.buf.execute_command(resolved.command)
	end
end

local function build_nested_action_list(nested)
	local out = {}
	for _, it in ipairs(nested or {}) do
		local data = it.data or {}
		local path = data.CodeActionPath or {}
		local title
		if #path == 1 then
			title = path[1]
		else
			title = table.concat(path, " -> ", 2)
		end
		if data.FixAllFlavors then
			title = string.format("Fix All: %s", title)
		end
		table.insert(out, { title = title, code_action = it })
	end
	return out
end

local function handle_fix_all_code_action(client, data)
	local arg = (data and data.arguments and data.arguments[1]) or {}
	local flavors = arg.FixAllFlavors or {}
	if #flavors == 0 then
		vim.notify("No Fix All scopes available for this action.", vim.log.levels.WARN, { title = "roslyn_ls" })
		return
	end

	vim.ui.select(flavors, { prompt = "Pick a Fix All scope:" }, function(flavor)
		if not flavor then
			return
		end
		local params = {
			title = data.title,
			data = arg,
			scope = flavor,
		}
		client:request("codeAction/resolveFixAll", params, function(err, resolved)
			if err then
				vim.notify(err.message or vim.inspect(err), vim.log.levels.ERROR, { title = "roslyn_ls" })
				return
			end
			apply_resolved_action(client, resolved)
		end)
	end)
end

local function roslyn_commands()
	return {
		["roslyn.client.fixAllCodeAction"] = function(data, ctx)
			local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
			handle_fix_all_code_action(client, data)
		end,

		-- handles nested code actions (some of which may be Fix All)
		["roslyn.client.nestedCodeAction"] = function(data, ctx)
			local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
			local args = (data and data.arguments and data.arguments[1]) or {}
			local list = build_nested_action_list(args.NestedCodeActions or {})

			if #list == 0 then
				vim.notify("No nested code actions available.", vim.log.levels.WARN, { title = "roslyn_ls" })
				return
			end

			local titles = {}
			for _, it in ipairs(list) do
				table.insert(titles, it.title)
			end

			vim.ui.select(titles, { prompt = args.UniqueIdentifier or "Select action" }, function(selected)
				if not selected then
					return
				end

				local chosen
				for _, it in ipairs(list) do
					if it.title == selected then
						chosen = it
						break
					end
				end
				if not chosen then
					return
				end

				local is_fix_all = chosen.code_action
					and chosen.code_action.data
					and chosen.code_action.data.FixAllFlavors
				if is_fix_all then
					handle_fix_all_code_action(client, chosen.code_action.command or {
						title = chosen.code_action.title,
						arguments = { chosen.code_action.data },
					})
					return
				end

				client:request("codeAction/resolve", {
					title = chosen.code_action.title,
					data = chosen.code_action.data,
				}, function(err, resolved)
					if err then
						vim.notify(err.message or vim.inspect(err), vim.log.levels.ERROR, { title = "roslyn_ls" })
						return
					end
					apply_resolved_action(client, resolved)
				end)
			end)
		end,
	}
end

local function get_root_dir(bufnr, cb)
	local bufname = vim.api.nvim_buf_get_name(bufnr)
	-- don't try to find sln or csproj for files from libraries outside of the project
	if not bufname:match("^" .. vim.fs.joinpath("/tmp/MetadataAsSource/")) then
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

local on_init = function(client)
	local root_dir = client.config.root_dir
	if not root_dir then
		return
	end

	local sln_files = vim.fs.find("*.sln", { path = root_dir, limit = 1, type = "file" })
	if #sln_files > 0 then
		client:notify("solution/open", {
			solution = vim.uri_from_fname(sln_files[1]),
		})
		return
	end

	local csproj_files = vim.fs.find("*.csproj", { path = root_dir, type = "file" })
	if #csproj_files > 0 then
		client:notify("project/open", {
			projects = vim.tbl_map(function(file)
				return vim.uri_from_fname(file)
			end, csproj_files),
		})
	end
end

local capabilities = {
	-- HACK: Doesn't show any diagnostics if we do not set this to true
	textDocument = {
		diagnostic = {
			dynamicRegistration = true,
		},
	},
	offsetEncoding = { "utf-16" },
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
	cmd = roslyn_executable,
	cmd_env = roslyn_env,
	filetypes = { "cs" },
	handlers = roslyn_handlers(),
	commands = roslyn_commands(),
	root_dir = get_root_dir,
	on_init = on_init,
	capabilities = capabilities,
	settings = roslyn_settings,
}
