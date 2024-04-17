return {
  "windwp/nvim-autopairs",
  event = { "InsertEnter" },
  dependencies = { "hrsh7th/nvim-cmp" },
  config = function()
    local autopairs = require("nvim-autopairs")

    autopairs.setup({
      check_ts = true, -- enable treesitter
      ts_config = {
        lua = { "string" }, -- dont add pairs in lua string treesitter nodes
        -- dont add pairs in javascript template string treesitter nodes
        javascript = { "template_string" },
      },
    })

    local cmp_autopairs = require("nvim-autopairs.completion.cmp")

    -- import nvim-cmp (completions plugin)
    local cmp = require("cmp")

    -- make autopairs and cmp work together
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
  end,
}
