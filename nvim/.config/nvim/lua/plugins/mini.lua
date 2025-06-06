return {
  {
    "echasnovski/mini.nvim",
    version = false,
    config = function()
      require("mini.icons").setup()

      -- highlight color codes (probably not required after neovim 0.12)
      local hipatterns = require("mini.hipatterns")
      hipatterns.setup({
        highlighters = {
          -- #rrggbb
          hex_color = hipatterns.gen_highlighter.hex_color({ priority = 2000 }),
          -- rgb(255, 255, 255)
          rgb_color = {
            pattern = "rgb%(%d+, ?%d+, ?%d+%)",
            group = function(_, match)
              local red, green, blue =
                match:match("rgb%((%d+), ?(%d+), ?(%d+)%)")
              local hex = string.format("#%02x%02x%02x", red, green, blue)
              return hipatterns.compute_hex_color_group(hex, "bg")
            end,
            priority = 2000,
            -- rgba(255, 255, 255, 0.5)
            rgba_color = {
              pattern = "rgba%(%d+, ?%d+, ?%d+, ?%d*%.?%d*%)",
              group = function(_, match)
                local red, green, blue, alpha =
                  match:match("rgba%((%d+), ?(%d+), ?(%d+), ?(%d*%.?%d*)%)")
                alpha = tonumber(alpha)
                if alpha == nil or alpha < 0 or alpha > 1 then
                  return false
                end
                local hex = string.format(
                  "#%02x%02x%02x",
                  red * alpha,
                  green * alpha,
                  blue * alpha
                )
                return hipatterns.compute_hex_color_group(hex, "bg")
              end,
            },
          },
        },
      })

      -- text manipulation around selection
      require("mini.surround").setup()

      -- automatic pair completion
      require("mini.pairs").setup({
        modes = { insert = true, command = true, terminal = false },
        -- skip autopair when next character is one of these
        skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
        -- skip autopair when the cursor is inside these treesitter nodes
        skip_ts = { "string" },
        -- skip autopair when next character is closing pair
        -- and there are more closing pairs than opening pairs
        skip_unbalanced = true,
        -- better deal with markdown code blocks
        markdown = true,
      })

      -- neovim session management
      require("mini.sessions").setup()
      vim.keymap.set(
        "n",
        "<leader>ss",
        "<cmd>lua MiniSessions.write('session')<cr>",
        { desc = "Save session for auto session root dir" }
      )
      vim.keymap.set(
        "n",
        "<leader>rs",
        "<cmd>lua MiniSessions.read('session')<cr>",
        { desc = "Restore session for cwd" }
      )

      -- file explorer
      local files = require("mini.files")
      files.setup({
        options = { permanent_delete = false },
        windows = {
          max_number = 3,
        },
        mappings = {
          go_in_plus = "<cr>",
          go_out_plus = "<tab>",
        },
      })
      -- manually notify LSPs that a file got renamed as for now the plugin
      -- author has no intention to make it the default behaviour
      vim.api.nvim_create_autocmd("User", {
        desc = "Notify LSPs that a file was renamed",
        pattern = "MiniFilesActionRename",
        callback = function(args)
          local changes = {
            files = {
              {
                oldUri = vim.uri_from_fname(args.data.from),
                newUri = vim.uri_from_fname(args.data.to),
              },
            },
          }
          local will_rename_method, did_rename_method =
            vim.lsp.protocol.Methods.workspace_willRenameFiles,
            vim.lsp.protocol.Methods.workspace_didRenameFiles
          local clients = vim.lsp.get_clients()
          for _, client in ipairs(clients) do
            if client:supports_method(will_rename_method) then
              local res =
                client:request_sync(will_rename_method, changes, 1000, 0)
              if res and res.result then
                vim.lsp.util.apply_workspace_edit(
                  res.result,
                  client.offset_encoding
                )
              end
            end
          end

          for _, client in ipairs(clients) do
            if client:supports_method(did_rename_method) then
              client:notify(did_rename_method, changes)
            end
          end
        end,
      })
      vim.keymap.set("n", "<leader>e", function()
        if not files.close() then
          files.open(vim.api.nvim_buf_get_name(0))
        end
      end, { desc = "Open file explorer" })
    end,
  },
}
