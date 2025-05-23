local ensure_installed = {
  "angular-language-server",
  "html-lsp",
  "css-lsp",
  "some-sass-language-server",
  "typescript-language-server",
  "eslint-lsp", -- js/ts linter
  "prettier", -- js/ts formatter
  "gopls", -- go lsp
  "golangci-lint",
  "lua-language-server",
  "stylua", -- lua formatter
  "marksman", -- markdown linter
  "ruff", -- python lsp
  "roslyn", -- dotnet lsp
  "csharpier", -- c# formatter
  "netcoredbg", -- dotnet debugger
  "shfmt", -- shell script formatter
  "shellcheck", -- shell script linter
}

vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("dan/mason_install", { clear = true }),
  desc = "Run MasonInstall for all lsps/formatters/daps that aren't installed",
  callback = function()
    local registry = require("mason-registry")
    for _, server in ipairs(ensure_installed) do
      if not registry.is_installed(server) then
        vim.cmd("MasonInstall " .. server)
      end
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
    -- priority must be higher than lsp reference
    vim.hl.on_yank({ timeout = 200, higroup = "Visual", priority = 250 })
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("dan/spell_on", { clear = true }),
  desc = "Turn on spell check for markdown and text files",
  pattern = { "*.md" },
  callback = function()
    vim.opt_local.spell = true
  end,
})

vim.api.nvim_create_user_command("Todos", function()
  require("fzf-lua").grep({ search = [[TODO:|todo!\(.*\)]], no_esc = true })
end, { desc = "Grep TODOs", nargs = 0 })

vim.api.nvim_create_user_command("Scratch", function()
  vim.cmd("bel 10new")
  local buf = vim.api.nvim_get_current_buf()
  for name, value in pairs({
    filetype = "scratch",
    buftype = "nofile",
    bufhidden = "wipe",
    swapfile = false,
    modifiable = true,
  }) do
    vim.api.nvim_set_option_value(name, value, { buf = buf })
  end
end, { desc = "Open a scratch buffer", nargs = 0 })
