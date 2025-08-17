return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
	},
	config = function()
		local dapui = require("dapui")
		dapui.setup()

		local dap = require("dap")
		for _, event in ipairs({ "attach", "launch" }) do
			dap.listeners.before[event].dapui_config = dapui.open
		end
		for _, event in ipairs({ "event_terminated", "event_exited" }) do
			dap.listeners.before[event].dapui_config = dapui.close
		end

		-- linehl = "", numhl = ""
		-- change breakpoint related symbols
		local sign = vim.fn.sign_define
		sign("DapBreakpoint", { text = "●", texthl = "DapBreakpoint" })
		sign("DapStopped", { text = "▶", texthl = "DapStopped" })
		sign("DapBreakpointRejected", { text = "◯", texthl = "DapBreakpointRejected" })
		sign("DapBreakpointCondition", { text = "◆", texthl = "DapBreakpointCondition" })

		local set = vim.keymap.set
		set("n", "<F5>", dap.continue, { desc = "Continue" })
		set("n", "<F10>", dap.step_over, { desc = "Step over" })
		set("n", "<F11>", dap.step_into, { desc = "Step into" })
		set("n", "<F12>", dap.step_out, { desc = "Step out" })
		set("n", "<leader>du", dapui.toggle, { desc = "Toggle dap ui" })
		set("n", "<leader>dr", dap.repl.toggle, { desc = "Toggle repl" })
		set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
		set("n", "<leader>dB", function()
			dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
		end, { desc = "Set conditional breakpoint" })
		set("n", "<leader>de", function()
			dapui.eval(nil, { enter = true })
		end, { desc = "Evaluate expression" })

		-- "q" to quit in dapui/dap-repl windows
		vim.api.nvim_create_autocmd("FileType", {
			pattern = {
				"dap-repl",
				"dapui_watches",
				"dapui_scopes",
				"dapui_breakpoints",
				"dapui_stacks",
			},
			callback = function()
				vim.keymap.set("n", "q", function()
					pcall(dap.close)
					pcall(dapui.close)
				end, { desc = "Close all DAP/DAPUI windows" })
			end,
		})
	end,
}
