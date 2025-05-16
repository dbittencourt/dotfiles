return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPre", "BufNewFile" },
  build = ":TSUpdate",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-context",
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  config = function()
    local treesitter = require("nvim-treesitter.configs")

    treesitter.setup({
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = {
        "javascript",
        "json",
        "typescript",
        "angular",
        "css",
        "scss",
        "dockerfile",
        "gitignore",
        "html",
        "latex",
        "lua",
        "sql",
        "terraform",
        "yaml",
        "markdown",
        "markdown_inline",
        "bash",
        "vim",
        "vimdoc", -- fix errors when using :help <anything>
        "python",
        "diff",
        "go",
        "c_sharp",
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    })

    require("treesitter-context").setup({
      max_lines = 3,
      multiline_threshold = 1,
      min_window_height = 20,
    })

    require("nvim-treesitter.configs").setup({
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["a="] = {
              query = "@assignment.outer",
              desc = "Select outer part of an assignment",
            },
            ["i="] = {
              query = "@assignment.inner",
              desc = "Select inner part of an assignment",
            },
            ["l="] = {
              query = "@assignment.lhs",
              desc = "Select left hand side of an assignment",
            },
            ["r="] = {
              query = "@assignment.rhs",
              desc = "Select right hand side of an assignment",
            },
            ["aa"] = {
              query = "@parameter.outer",
              desc = "Select outer part of a parameter/argument",
            },
            ["ia"] = {
              query = "@parameter.inner",
              desc = "Select inner part of a parameter/argument",
            },
            ["ai"] = {
              query = "@conditional.outer",
              desc = "Select outer part of a conditional",
            },
            ["ii"] = {
              query = "@conditional.inner",
              desc = "Select inner part of a conditional",
            },
            ["al"] = {
              query = "@loop.outer",
              desc = "Select outer part of a loop",
            },
            ["il"] = {
              query = "@loop.inner",
              desc = "Select inner part of a loop",
            },
            ["af"] = {
              query = "@call.outer",
              desc = "Select outer part of a function call",
            },
            ["if"] = {
              query = "@call.inner",
              desc = "Select inner part of a function call",
            },
            ["am"] = {
              query = "@function.outer",
              desc = "Select outer part of a method/function definition",
            },
            ["im"] = {
              query = "@function.inner",
              desc = "Select inner part of a method/function definition",
            },
            ["ac"] = {
              query = "@class.outer",
              desc = "Select outer part of a class",
            },
            ["ic"] = {
              query = "@class.inner",
              desc = "Select inner part of a class",
            },
          },
        },
        swap = {
          enable = true,
          swap_next = {
            -- swap parameters/argument with next
            ["<leader>na"] = "@parameter.inner",
            -- swap object property with next
            ["<leader>n:"] = "@property.outer",
            -- swap function with next
            ["<leader>nm"] = "@function.outer",
          },
          swap_previous = {
            -- swap parameters/argument with prev
            ["<leader>pa"] = "@parameter.inner",
            -- swap object property with prev
            ["<leader>p:"] = "@property.outer",
            -- swap function with previous
            ["<leader>pm"] = "@function.outer",
          },
        },
        move = {
          enable = true,
          -- add jumps in the jumplist
          set_jumps = true,
          goto_next_start = {
            ["]f"] = {
              query = "@call.outer",
              desc = "Next function call start",
            },
            ["]m"] = {
              query = "@function.outer",
              desc = "Next method/function def start",
            },
            ["]c"] = { query = "@class.outer", desc = "Next class start" },
            ["]i"] = {
              query = "@conditional.outer",
              desc = "Next conditional start",
            },
            ["]l"] = { query = "@loop.outer", desc = "Next loop start" },

            ["]z"] = {
              query = "@fold",
              query_group = "folds",
              desc = "Next fold",
            },
          },
          goto_next_end = {
            ["]F"] = { query = "@call.outer", desc = "Next function call end" },
            ["]M"] = {
              query = "@function.outer",
              desc = "Next method/function def end",
            },
            ["]C"] = { query = "@class.outer", desc = "Next class end" },
            ["]I"] = {
              query = "@conditional.outer",
              desc = "Next conditional end",
            },
            ["]L"] = { query = "@loop.outer", desc = "Next loop end" },
          },
          goto_previous_start = {
            ["[f"] = {
              query = "@call.outer",
              desc = "Prev function call start",
            },
            ["[m"] = {
              query = "@function.outer",
              desc = "Prev method/function def start",
            },
            ["[c"] = { query = "@class.outer", desc = "Prev class start" },
            ["[i"] = {
              query = "@conditional.outer",
              desc = "Prev conditional start",
            },
            ["[l"] = { query = "@loop.outer", desc = "Prev loop start" },
          },
          goto_previous_end = {
            ["[F"] = { query = "@call.outer", desc = "Prev function call end" },
            ["[M"] = {
              query = "@function.outer",
              desc = "Prev method/function def end",
            },
            ["[C"] = { query = "@class.outer", desc = "Prev class end" },
            ["[I"] = {
              query = "@conditional.outer",
              desc = "Prev conditional end",
            },
            ["[L"] = { query = "@loop.outer", desc = "Prev loop end" },
          },
        },
      },
    })
  end,
}
