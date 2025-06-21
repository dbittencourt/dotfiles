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

return {
  "GustavEikaas/easy-dotnet.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "ibhagwan/fzf-lua",
    "mfussenegger/nvim-dap",
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
  },
  ft = { "cs", "csproj", "sln", "slnx", "props", "csx", "targets" },
  config = function()
    local dotnet = require("easy-dotnet")
    local dap = require("dap")
    local dapui = require("dapui")

    dotnet.setup({ picker = "fzf" })

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

    dapui.setup()
    for _, event in ipairs({ "attach", "launch" }) do
      dap.listeners.before[event].dapui_config = dapui.open
    end
    for _, event in ipairs({ "event_terminated", "event_exited" }) do
      dap.listeners.before[event].dapui_config = dapui.close
    end

    -- Define signs for DAP
    local signs = {
      { name = "DapBreakpoint", text = "●", texthl = "DapBreakpoint" },
      { name = "DapStopped", text = "▶", texthl = "DapStopped" },
      {
        name = "DapBreakpointRejected",
        text = "◯",
        texthl = "DapBreakpointRejected",
      },
      {
        name = "DapBreakpointCondition",
        text = "◆",
        texthl = "DapBreakpointCondition",
      },
    }
    for _, sign in ipairs(signs) do
      vim.fn.sign_define(
        sign.name,
        { text = sign.text, texthl = sign.texthl, linehl = "", numhl = "" }
      )
    end

    -- Keymaps
    local keymaps = {
      {
        "n",
        "q",
        function()
          dap.close()
          dapui.close()
        end,
        {},
      },
      { "n", "<F5>", dap.continue, { desc = "Continue debug execution" } },
      {
        "n",
        "<F10>",
        dap.step_over,
        { desc = "Step over debug breaking point" },
      },
      {
        "n",
        "<F11>",
        dap.step_into,
        { desc = "Step into debug breaking point" },
      },
      {
        "n",
        "<F12>",
        dap.step_out,
        { desc = "Step out of debug breaking point" },
      },
      {
        "n",
        "<leader>b",
        dap.toggle_breakpoint,
        { desc = "Toggle debug breaking point" },
      },
    }
    for _, map in ipairs(keymaps) do
      vim.keymap.set(unpack(map))
    end
  end,
}
