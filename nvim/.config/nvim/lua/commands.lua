vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("dan/max_column", { clear = true }),
  desc = "Set a ruler at column 100",
  pattern = "*",
  callback = function()
    if
      not vim.tbl_contains({
        "help",
        "terminal",
        "lazy",
        "qf",
        "checkhealth",
      }, vim.bo.filetype)
    then
      vim.opt.colorcolumn = "100"
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("dan/quick_close", { clear = true }),
  desc = "Close with <q>",
  pattern = { "help", "man", "qf", "scratch" },
  callback = function(args)
    vim.keymap.set("n", "q", "<cmd>quit<cr>", { buffer = args.buf })
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("dan/yank_highlight", { clear = true }),
  desc = "Highlight on yank",
  callback = function()
    vim.hl.on_yank({ timeout = 250, higroup = "Visual" })
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("dan/spell_on", { clear = true }),
  desc = "Turn on spell check for markdown and text files",
  pattern = { "text", "tex", "markdown", "gitcommit" },
  callback = function()
    vim.opt_local.spell = true
  end,
})

vim.api.nvim_create_user_command("Todo", function()
  require("fzf-lua").grep({ search = [[TODO:|todo!\(.*\)]], no_esc = true })
end, { desc = "Show all todos", nargs = 0 })
