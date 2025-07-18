local M = {}

local methods = vim.lsp.protocol.Methods
local function on_attach(client, bufnr)
  local function keymap(mode, lhs, rhs, desc, noremap)
    noremap = noremap or false
    vim.keymap.set(
      mode,
      lhs,
      rhs,
      { buffer = bufnr, desc = desc, noremap = noremap }
    )
  end

  -- default neovim keymaps
  -- grn: smart rename
  -- gra: show code actions

  keymap("n", "<leader>lr", function()
    vim.lsp.stop_client(vim.lsp.get_clients())
    vim.cmd("edit")
  end, "Restart lsp")

  -- diagnostics
  keymap("n", "<leader>d", vim.diagnostic.open_float, "Show line diagnostics")
  keymap(
    "n",
    "<leader>D",
    "<cmd>FzfLua diagnostics_document<cr>",
    "Show buffer diagnostics"
  )
  keymap(
    "n",
    "<leader>qd",
    vim.diagnostic.setqflist,
    "Send diagnostics to quickfix"
  )

  -- code navigation
  keymap("n", "gd", "<cmd>FzfLua lsp_definitions<cr>", "Show lsp definitions")
  keymap(
    "n",
    "grt",
    "<cmd>FzfLua lsp_typedefs<cr>",
    "Show lsp type definitions"
  )
  keymap(
    "n",
    "gri",
    "<cmd>FzfLua lsp_implementations<cr>",
    "Show lsp implementations"
  )
  keymap("n", "grr", "<cmd>FzfLua lsp_references<cr>", "Show lsp references")
  keymap(
    "n",
    "grc",
    "<cmd>FzfLua lsp_incoming_calls<cr>",
    "Show lsp incoming calls"
  )
  keymap(
    "n",
    "gO",
    "<cmd>FzfLua lsp_document_symbols<cr>",
    "Show document symbols"
  )

  -- override neovim default signature keymap to close blink if its open
  if client:supports_method(methods.textDocument_signatureHelp) then
    keymap({ "n", "i", "s" }, "<C-S>", function()
      if require("blink.cmp.completion.windows.menu").win:is_open() then
        require("blink.cmp").hide()
      end
      vim.lsp.buf.signature_help()
    end, "Show signature", true)
  end

  if client:supports_method(methods.textDocument_documentHighlight) then
    vim.api.nvim_create_autocmd({ "CursorHold", "InsertLeave" }, {
      desc = "Highlight references under the cursor",
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter", "BufLeave" }, {
      desc = "Clear highlight references",
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end
end

-- make sure inlay hints are disabled, I'm definitely not a fan
vim.g.inlay_hints = false

-- set diagnostic symbols in the sign column
local diagnostic_icons = {
  [vim.diagnostic.severity.ERROR] = " ",
  [vim.diagnostic.severity.WARN] = " ",
  [vim.diagnostic.severity.INFO] = " ",
  [vim.diagnostic.severity.HINT] = " ",
}
vim.diagnostic.config({
  float = {
    source = "if_many",
  },
  signs = {
    text = diagnostic_icons,
  },
})

-- update mappings when registering dynamic capabilities
-- borrowed from https://github.com/MariaSolOs/dotfiles
local register_capability = vim.lsp.handlers[methods.client_registerCapability]
vim.lsp.handlers[methods.client_registerCapability] = function(err, res, ctx)
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  if not client then
    return
  end

  on_attach(client, vim.api.nvim_get_current_buf())

  return register_capability(err, res, ctx)
end

vim.api.nvim_create_autocmd("LspAttach", {
  desc = "Configure lsps",
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end

    on_attach(client, args.buf)
  end,
})

-- enable lsp servers from lsp directory
vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
  once = true,
  callback = function()
    local server_configs = vim
      .iter(vim.api.nvim_get_runtime_file("lsp/*.lua", true))
      :map(function(file)
        return vim.fn.fnamemodify(file, ":t:r")
      end)
      :totable()
    vim.lsp.enable(server_configs)
  end,
})

return M
