return {
  "stevearc/conform.nvim",
  lazy = true,
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    local format_file = function()
      conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      })
    end

    conform.setup({
      formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        htmlangular = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        lua = { "stylua" },
        python = { "ruff" },
        bash = { "shfmt", "shellcheck" },
        zsh = { "shfmt", "shellcheck" },
        sh = { "shfmt", "shellcheck" },
        cs = { "csharpier" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        sql = { "sql_formatter" },
        pgsql = { "sql_formatter" },
      },
      formatters = {
        csharpier = {
          command = "csharpier",
          args = { "format", "$FILENAME" },
          -- csharpier expects a file path argument rather than stdin
          stdin = false,
        },
        sql_formatter = {
          command = "sql-formatter",
          args = { "--language", "tsql" },
          stdin = true,
        },
      },
      format_on_save = function()
        format_file()
      end,
    })

    vim.keymap.set(
      { "n", "v" },
      "<leader>mp",
      format_file,
      { desc = "Format file or range (in visual mode)" }
    )
  end,
}
