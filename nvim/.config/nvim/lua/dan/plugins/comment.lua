return {
  --  todo: assess if this plugin is still required when nvim 0.10 is released
  "numToStr/Comment.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = true,
}
