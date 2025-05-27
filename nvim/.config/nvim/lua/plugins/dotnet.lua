return {
  -- install nuget authentication helper
  -- use it with dotnet restore --interactive
  -- wget -qO- https://aka.ms/install-artifacts-credprovider.sh | bash
  "GustavEikaas/easy-dotnet.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "ibhagwan/fzf-lua",
    "mfussenegger/nvim-dap",
  },
  ft = { "cs", "csproj", "sln", "slnx", "props", "csx", "targets" },
  config = function()
    require("dap").adapters.coreclr = {
      type = "executable",
      command = "netcoredbg",
      args = { "--interpreter=vscode" },
    }

    require("easy-dotnet").setup({
      picker = "fzf",
    })
  end,
}
