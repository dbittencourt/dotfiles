return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local lazy_status = require("lazy.status")
    require("lualine").setup({
      options = {
        theme = "auto",
        section_separators = "",
        component_separators = "",
      },
      sections = {
        lualine_c = {
          {
            "filename",
            path = 1, -- show current file path
          },
        },
        lualine_x = {
          {
            lazy_status.updates,
            cond = lazy_status.has_updates,
            color = { fg = "#ff9e64" },
          },
          { "encoding" },
          { "fileformat" },
          { "filetype" },
        },
      },
      tabline = {
        lualine_a = {
          {
            "tabs",
            max_length = vim.api.nvim_win_get_width(0), --vim.o.columns / 3
            mode = 1, -- shows tab name
            path = 0, -- shows just the filename
            show_modified_status = true,
          },
        },
      },
    })
  end,
}
