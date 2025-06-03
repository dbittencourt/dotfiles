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

    -- using mini.diff to identify git hunks
    local diff = require("mini.diff")
    local range_ignore_filetypes = { "lua" }
    local format_diffs = function()
      local data = diff.get_buf_data()
      if not data or not data.hunks then
        vim.notify("No hunks in this buffer")
        return
      end

      -- stylua range format mess up indent, so use full format for now
      if vim.tbl_contains(range_ignore_filetypes, vim.bo.filetype) then
        format_file()
        return
      end
      local ranges = {}
      for _, hunk in pairs(data.hunks) do
        if hunk.type ~= "delete" then
          -- always insert to index 1 so format below could start from last hunk
          -- which this sort didn't mess up range
          table.insert(ranges, 1, {
            start = { hunk.buf_start, 0 },
            ["end"] = { hunk.buf_start + hunk.buf_count, 0 },
          })
        end
      end
      for _, range in pairs(ranges) do
        conform.format({
          lsp_fallback = true,
          async = false,
          timeout_ms = 1000,
          range = range,
        })
      end
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
      },
      formatters = {
        csharpier = {
          command = "csharpier",
          args = { "format", "$FILENAME" },
          -- csharpier expects a file path argument rather than stdin
          stdin = false,
        },
      },
      format_on_save = function()
        -- only format git hunks to avoid massive changes on old files
        -- should this become unnecessary, just replace by format_file function
        format_diffs()
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
