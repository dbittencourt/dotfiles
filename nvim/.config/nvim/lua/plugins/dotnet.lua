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
    dotnet.setup({
      picker = "fzf",
    })

    local debug_dll = nil
    local function ensure_dll()
      if debug_dll ~= nil then
        return debug_dll
      end
      local dll = dotnet.get_debug_dll()
      debug_dll = dll
      return dll
    end

    local dap = require("dap")
    for _, value in ipairs({ "cs", "fsharp" }) do
      dap.configurations[value] = {
        {
          type = "coreclr",
          name = "Program",
          request = "launch",
          env = function()
            local dll = ensure_dll()
            local vars = dotnet.get_environment_variables(
              dll.project_name,
              dll.absolute_project_path
            )
            return vars or nil
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
            local dll = ensure_dll()
            return dll.absolute_project_path
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

    local dapui = require("dapui")
    dapui.setup()
    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end

    -- change breaking point icons. still not sure on their colors,
    -- maybe I should leave to the default colorscheme...
    vim.fn.sign_define(
      "DapBreakpoint",
      { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" }
    )
    -- vim.cmd("highlight DapBreakpoint guifg=#FF0000 guibg=NONE")

    vim.fn.sign_define(
      "DapStopped",
      { text = "▶", texthl = "DapStopped", linehl = "", numhl = "" }
    )
    -- vim.cmd("highlight DapStopped guifg=#FFFF00 guibg=NONE")

    vim.fn.sign_define("DapBreakpointRejected", {
      text = "◯",
      texthl = "DapBreakpointRejected",
      linehl = "",
      numhl = "",
    })
    -- vim.cmd("highlight DapBreakpointRejected guifg=#FF0000 guibg=NONE")

    vim.fn.sign_define("DapBreakpointCondition", {
      text = "◆",
      texthl = "DapBreakpointCondition",
      linehl = "",
      numhl = "",
    })
    -- vim.cmd("highlight DapBreakpointCondition guifg=#FFA500 guibg=NONE")

    vim.keymap.set("n", "q", function()
      dap.close()
      dapui.close()
    end, {})
    vim.keymap.set(
      "n",
      "<F5>",
      dap.continue,
      { desc = "Continue debug execution" }
    )
    vim.keymap.set(
      "n",
      "<F10>",
      dap.step_over,
      { desc = "Step over debug breaking point" }
    )
    vim.keymap.set(
      "n",
      "<F11>",
      dap.step_into,
      { desc = "Step into debug breaking point" }
    )
    vim.keymap.set(
      "n",
      "<F12>",
      dap.step_out,
      { desc = "Step out of debug breaking point" }
    )
    vim.keymap.set(
      "n",
      "<leader>b",
      dap.toggle_breakpoint,
      { desc = "Toggle debug breaking point" }
    )
  end,
}
