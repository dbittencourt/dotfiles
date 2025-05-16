return {
  {
    "rebelot/kanagawa.nvim",
    priority = 1000, -- make sure its the first plugin to load
    config = function()
      local kanagawa = require("kanagawa")
      kanagawa.setup({
        colors = {
          theme = {
            all = {
              ui = {
                -- remove color differentiation from line column
                bg_gutter = "none",
              },
            },
          },
        },
        overrides = function(colors)
          local theme = colors.theme
          return {
            -- add `blend = vim.o.pumblend` to enable transparency
            Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
            PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
            PmenuSbar = { bg = theme.ui.bg_m1 },
            PmenuThumb = { bg = theme.ui.bg_p2 },
          }
        end,
      })
      kanagawa.load("dragon")
    end,
  },
  -- color highlighter
  {
    "catgoose/nvim-colorizer.lua",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("colorizer").setup({
        user_default_options = {
          names = false,
          css = true,
          css_fn = true,
          sass = {
            enable = true,
            parsers = {
              "css",
            },
          },
        },
      })
    end,
  },
  -- set ruler at column 80
  {
    "m4xshen/smartcolumn.nvim",
    opts = {
      disabled_filetypes = {
        "help",
        "lazy",
        "mason",
        "lspinfo",
        "checkhealth",
      },
    },
  },
}
