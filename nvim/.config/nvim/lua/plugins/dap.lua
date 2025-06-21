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

    vim.keymap.set("n", "q", function()
      dap.close()
      dapui.close()
    end, { desc = "Close all dap/dapui windows" })
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
