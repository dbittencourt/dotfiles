local M = {}

local methods = vim.lsp.protocol.Methods
local function on_attach(client, bufnr)
  local function keymap(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
  end
  keymap(
    "n",
    "<leader>lr",
    "<cmd>lua vim.lsp.stop_client(vim.lsp.get_clients())<cr><cmd>edit<cr>",
    "Restart lsp"
  )
  keymap("n", "<leader>rn", vim.lsp.buf.rename, "Smart rename")
  keymap("n", "<leader>d", vim.diagnostic.open_float, "Show line diagnostics")
  keymap(
    "n",
    "<leader>D",
    "<cmd>FzfLua diagnostics_document<CR>",
    "Show buffer diagnostics"
  )
  keymap(
    { "n", "v" },
    "<leader>ca",
    "<cmd>FzfLua lsp_code_actions<cr>",
    "See available code actions"
  )
  keymap("n", "gd", "<cmd>FzfLua lsp_definitions<CR>", "Show lsp definitions")
  keymap("n", "gD", "<cmd>FzfLua lsp_typedefs<CR>", "Show lsp type definitions")
  keymap(
    "n",
    "gi",
    "<cmd>FzfLua lsp_implementations<CR>",
    "Show lsp implementations"
  )
  keymap("n", "gR", "<cmd>FzfLua lsp_references<CR>", "Show lsp references")
  keymap(
    "n",
    "gC",
    "<cmd>FzfLua lsp_incoming_calls<CR>",
    "Show lsp incoming calls"
  )

  if client:supports_method(methods.textDocument_signatureHelp) then
    local blink_window = require("blink.cmp.completion.windows.menu")
    local blink = require("blink.cmp")

    keymap("i", "<C-k>", function()
      if blink_window.win:is_open() then
        blink.hide()
      end

      vim.lsp.buf.signature_help()
    end, "Show signature")
  end

  if client:supports_method(methods.textDocument_documentHighlight) then
    local group =
      vim.api.nvim_create_augroup("dan/cursor_highlights", { clear = false })
    vim.api.nvim_create_autocmd({ "CursorHold", "InsertLeave" }, {
      group = group,
      desc = "Highlight references under the cursor",
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter", "BufLeave" }, {
      group = group,
      desc = "Clear highlight references",
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end
end

-- make sure inlay hints are disabled, I'm definitely not a fan
vim.g.inlay_hints = false

-- set diagnostic symbols in the sign column
vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.INFO] = " ",
      [vim.diagnostic.severity.HINT] = " ",
    },
  },
})

-- update mappings when registering dynamic capabilities
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
