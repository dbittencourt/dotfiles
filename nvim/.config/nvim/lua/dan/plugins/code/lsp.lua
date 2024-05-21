return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
  },
  config = function()
    local lspconfig = require("lspconfig")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local keymap = vim.keymap

    local on_attach = function(client, bufnr)
      local opts = { noremap = true, silent = true, buffer = bufnr }
      -- set keybinds
      opts.desc = "Show LSP references"
      keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

      opts.desc = "Go to declaration"
      keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

      opts.desc = "Show LSP definitions"
      keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

      opts.desc = "Show LSP implementations"
      keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

      opts.desc = "Show LSP type definitions"
      keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

      opts.desc = "See available code actions"
      keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

      opts.desc = "Smart rename"
      keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

      -- show  diagnostics for file
      opts.desc = "Show buffer diagnostics"
      keymap.set(
        "n",
        "<leader>D",
        "<cmd>Telescope diagnostics bufnr=0<CR>",
        opts
      )

      opts.desc = "Show line diagnostics"
      keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

      opts.desc = "Restart LSP"
      keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)

      -- enable inlay hints introduced in nvim 0.10
      if client.supports_method("inlayHintProvider") then
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
      end
    end

    -- Enable snippets-completion (nvim-cmp) and folding
    local capabilities = cmp_nvim_lsp.default_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.foldingRange =
      { dynamicRegistration = false, lineFoldingOnly = true }

    -- Change the Diagnostic symbols in the sign column (gutter)
    local signs =
      { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    -- configure angular server
    local ok, mason_registry = pcall(require, "mason-registry")
    if not ok then
      vim.notify("mason-registry could not be loaded")
      return
    end
    local angularls_path =
      mason_registry.get_package("angular-language-server"):get_install_path()
    local cmd = {
      "ngserver",
      "--stdio",
      "--tsProbeLocations",
      table.concat({
        angularls_path,
        vim.fn.getcwd(),
      }, ","),
      "--ngProbeLocations",
      table.concat({
        angularls_path .. "/node_modules/@angular/language-server",
        vim.fn.getcwd(),
      }, ","),
    }
    lspconfig.angularls.setup({
      cmd = cmd,
      on_new_config = function(new_config, _)
        new_config.cmd = cmd
      end,
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- configure css server
    lspconfig.cssls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- configure format on save for eslint
    lspconfig.eslint.setup({
      settings = {
        workingDirectory = { mode = "location" },
      },
      capabilities = capabilities,
      -- requires npm i -g vscode-langservers-extracted
      on_attach = function(_, buffer)
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = buffer,
          command = "EslintFixAll",
        })
      end,
      on_new_config = function(config, new_root_dir)
        config.settings.workspaceFolder = {
          uri = vim.uri_from_fname(new_root_dir),
          name = vim.fn.fnamemodify(new_root_dir, ":t"),
        }
      end,
    })

    -- configure lua server (with special settings)
    lspconfig.lua_ls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = { -- custom settings for lua
        Lua = {
          -- make the language server recognize 'vim' global
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            -- make language server aware of runtime files
            library = {
              [vim.fn.expand("$VIMRUNTIME/lua")] = true,
              [vim.fn.stdpath("config") .. "/lua"] = true,
            },
          },
        },
      },
    })

    -- configure markdown lsp
    lspconfig.marksman.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- configure rust server
    lspconfig.rust_analyzer.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        ["rust-analyzer"] = {
          cargo = { allFeatures = true },
        },
      },
    })

    -- configure typescript server with plugin
    lspconfig.tsserver.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })
  end,
}
