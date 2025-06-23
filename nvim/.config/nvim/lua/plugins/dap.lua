return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    dapui.setup()
    for _, event in ipairs({ "attach", "launch" }) do
      dap.listeners.before[event].dapui_config = dapui.open
    end
    for _, event in ipairs({ "event_terminated", "event_exited" }) do
      dap.listeners.before[event].dapui_config = dapui.close
    end

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

    local dap_keymaps = {
      { "n", "<leader>b", dap.toggle_breakpoint, "Toggle breakpoint" },
      { "n", "<F5>", dap.continue, "Continue" },
      { "n", "<F10>", dap.step_over, "Step over" },
      { "n", "<F11>", dap.step_into, "Step into" },
      { "n", "<F12>", dap.step_out, "Step out" },
      {
        "n",
        "<leader>B",
        function()
          dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end,
        "Set conditional breakpoint",
      },
      { "n", "<leader>dr", dap.repl.toggle, "Toggle REPL" },
      { "n", "<leader>dl", dap.run_last, "Run last debug session" },
      { "n", "<leader>du", dapui.toggle, "Toggle DAP UI" },
      {
        "n",
        "<leader>de",
        function()
          dapui.eval(nil, { enter = true })
        end,
        "Evaluate expression",
      },
    }
    for _, map in ipairs(dap_keymaps) do
      vim.keymap.set(map[1], map[2], map[3], { desc = "DAP: " .. map[4] })
    end

    -- "q" to quit in dapui/dap-repl windows
    vim.api.nvim_create_autocmd("FileType", {
      pattern = {
        "dap-repl",
        "dapui_watches",
        "dapui_scopes",
        "dapui_breakpoints",
        "dapui_stacks",
      },
      callback = function(args)
        vim.keymap.set("n", "q", function()
          pcall(dap.close)
          pcall(dapui.close)
        end, { desc = "Close all DAP/DAPUI windows" })
      end,
    })
  end,
}
