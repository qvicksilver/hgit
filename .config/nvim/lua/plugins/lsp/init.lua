return {
  {
    "VonHeikemen/lsp-zero.nvim",
    event = "VeryLazy",
    dependencies = {
      'neovim/nvim-lspconfig',
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'L3MON4D3/LuaSnip',
      {"j-hui/fidget.nvim", config = true },
    },
    config = function()
      local lsp = require('lsp-zero').preset({
        name = 'minimal',
        set_lsp_keymaps = true,
        --manage_nvim_cmp = true,
      })
      lsp.skip_server_setup({'jdtls'})
      lsp.nvim_workspace()
      lsp.setup()
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = "BufReadPre",
    dependencies = { "mason.nvim" },
    config = function()
      local nls = require "null-ls"
      nls.setup()
    end,
  },
}
