return {
  "saghen/blink.cmp",
  version = "*",
  dependencies = {
    "rafamadriz/friendly-snippets",
  },
  event = "InsertEnter",
  opts = {
    keymap = {
      preset = "enter",
    },
    appearance = {
      use_nvim_cmp_as_default = false,
      -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- adjusts spacing to ensure icons are aligned
      nerd_font_variant = "mono",
    },
    sources = {
      default = {
        "lsp",
        "path",
        "snippets",
        "buffer",
        "omni",
        "cmdline",
        "markdown",
        "easy-dotnet",
      },
      providers = {
        markdown = {
          name = "RenderMarkdown",
          module = "render-markdown.integ.blink",
          fallbacks = { "lsp" },
        },
        ["easy-dotnet"] = {
          name = "easy-dotnet",
          module = "easy-dotnet.completion.blink",
          score_offset = 10000,
          async = true,
        },
      },
    },
    -- disable auto-completion when scrolling through options
    completion = {
      list = {
        selection = {
          preselect = false,
          auto_insert = false,
        },
      },
      -- automatically trigger snippets when trigger character is used
      -- ps: trigger character is defined by lsps, like . or (
      trigger = {
        show_on_trigger_character = true,
      },
      accept = {
        -- experimental auto-brackets support
        auto_brackets = {
          enabled = true,
        },
      },
      menu = {
        draw = {
          treesitter = { "lsp" },
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
      },
      -- disable ghost text, kinda annoying
      ghost_text = {
        enabled = false,
      },
    },
    cmdline = {
      keymap = {
        ["<CR>"] = { "accept", "fallback" },
      },
    },
    snippets = { preset = "default" },
  },
  config = function(_, opts)
    local blink = require("blink.cmp")
    blink.setup(opts)

    -- extend neovim completion capabilities
    vim.lsp.config(
      "*",
      { capabilities = blink.get_lsp_capabilities(nil, true) }
    )
  end,
}
