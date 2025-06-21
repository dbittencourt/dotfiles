return {
  "GustavEikaas/easy-dotnet.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "ibhagwan/fzf-lua",
    "mfussenegger/nvim-dap",
  },
  ft = { "cs", "csproj", "sln", "slnx", "props", "csx", "targets" },
  config = function()
    local dotnet = require("easy-dotnet")
    local dap = require("dap")
    dotnet.setup({ picker = "fzf" })

    -- configure debug for dotnet. maybe I should move it o a different file
    local function rebuild_project(co, path)
      local spinner = require("easy-dotnet.ui-modules.spinner").new()
      spinner:start_spinner("Building")
      vim.fn.jobstart(string.format("dotnet build %s", path), {
        on_exit = function(_, return_code)
          if return_code == 0 then
            spinner:stop_spinner("Built successfully")
          else
            spinner:stop_spinner(
              "Build failed with exit code " .. return_code,
              vim.log.levels.ERROR
            )
            error("Build failed")
          end
          coroutine.resume(co)
        end,
      })
      coroutine.yield()
    end

    local function file_exists(path)
      local stat = vim.loop.fs_stat(path)
      return stat and stat.type == "file"
    end

    local debug_dll
    local function ensure_dll()
      if debug_dll then
        return debug_dll
      end
      debug_dll = dotnet.get_debug_dll()
      return debug_dll
    end

    for _, lang in ipairs({ "cs", "fsharp" }) do
      dap.configurations[lang] = {
        {
          type = "coreclr",
          name = "Program",
          request = "launch",
          env = function()
            local dll = ensure_dll()
            return dotnet.get_environment_variables(
              dll.project_name,
              dll.absolute_project_path
            ) or nil
          end,
          program = function()
            local dll = ensure_dll()
            local co = coroutine.running()
            rebuild_project(co, dll.project_path)
            if not file_exists(dll.target_path) then
              error("Project has not been built, path: " .. dll.target_path)
            end
            return dll.target_path
          end,
          cwd = function()
            return ensure_dll().absolute_project_path
          end,
        },
      }
    end

    dap.listeners.before["event_terminated"]["easy-dotnet"] = function()
      debug_dll = nil
    end

    dap.adapters.coreclr = {
      type = "executable",
      command = os.getenv("HOME") .. "/.dotnet/tools/netcoredbg/netcoredbg",
      args = { "--interpreter=vscode" },
    }
  end,
}
