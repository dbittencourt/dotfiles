return {
  -- install nuget authentication helper
  -- use it with dotnet restore --interactive
  -- wget -qO- https://aka.ms/install-artifacts-credprovider.sh | bash
  "GustavEikaas/easy-dotnet.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "ibhagwan/fzf-lua",
    "mfussenegger/nvim-dap",
    -- if in windows arm, run :MasonInstall roslyn --target=win_arm64
    "seblyng/roslyn.nvim",
  },
  ft = { "cs", "csproj", "sln", "slnx", "props", "csx", "targets" },
  config = function()
    require("dap").adapters.coreclr = {
      type = "executable",
      command = "netcoredbg",
      args = { "--interpreter=vscode" },
    }

    -- configure roslyn lsp
    require("roslyn").setup({
      config = {
        settings = {
          ["csharp|inlay_hints"] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = true,
            csharp_enable_inlay_hints_for_implicit_variable_types = false,
            csharp_enable_inlay_hints_for_lambda_parameter_types = true,
            csharp_enable_inlay_hints_for_types = false,
            dotnet_enable_inlay_hints_for_indexer_parameters = true,
            dotnet_enable_inlay_hints_for_literal_parameters = true,
            dotnet_enable_inlay_hints_for_object_creation_parameters = true,
            dotnet_enable_inlay_hints_for_other_parameters = true,
            dotnet_enable_inlay_hints_for_parameters = false,
          },
          ["csharp|code_lens"] = {
            dotnet_enable_references_code_lens = true,
          },
        },
      },
    })

    require("easy-dotnet").setup({
      picker = "fzf",
    })
  end,
}
