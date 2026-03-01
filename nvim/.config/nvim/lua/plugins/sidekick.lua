vim.pack.add({ { src = "https://github.com/folke/sidekick.nvim" } })

require("sidekick").setup({
	nes = { enabled = false },
	cli = { picker = "fzf-lua" },
})

vim.keymap.set("n", "<leader>at", function()
	require("sidekick.cli").toggle({ name = "copilot", focus = true })
end, { desc = "Toggle copilot cli" })

vim.keymap.set("x", "<leader>av", function()
	require("sidekick.cli").send({ msg = "{selection}" })
end, { desc = "Send visual selection to Sidekick" })
