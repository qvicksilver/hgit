vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0

--vim.g.mapleader = '<Space>'

vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.laststatus = 3
vim.opt.cmdheight = 0

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath
    })
  end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {"navarasu/onedark.nvim"},
  {"nvim-lualine/lualine.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
  },
  {"nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<C-a>", "<CMD>Neotree toggle<CR>", mode = { "n", "i", "v" } }
    },
  },
  {"VonHeikemen/lsp-zero.nvim",
    dependencies = {
      {'neovim/nvim-lspconfig'},
      {'williamboman/mason.nvim'},
      {'williamboman/mason-lspconfig.nvim'},
      {'hrsh7th/nvim-cmp'},
      {'hrsh7th/cmp-nvim-lsp'},
      {'hrsh7th/cmp-buffer'},
      {'hrsh7th/cmp-path'},
      {'L3MON4D3/LuaSnip'},
    },
  },
  {"mfussenegger/nvim-jdtls", },
  {"nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup {
	ensure_installed = { "bash", "c", "java", "javascript", "json", "make", "lua", "python", "yaml" },
	highlight = { enable = true, }
      }
    end },
})

require('onedark').setup({
  style = 'darker'
})
require('onedark').load()

require('lualine').setup({
  options = { theme = 'onedark' },
})

--vim.keymap.set('n', '<leader><leader>', function() vim.opt.hlsearch = false end)

local autocmd = vim.api.nvim_create_autocmd

-- Secure editing of gopass seecrets
autocmd({
  'BufNewFile', 'BufRead'
}, {
  pattern = {'/dev/shm/gopass*'},
  callback = function(ev)
    vim.opt_local.swapfile = false
    vim.opt_local.backup = false
    vim.opt_local.undofile = false
    vim.opt_local.shada = {}
  end
})

local lsp = require('lsp-zero').preset({
  name = 'minimal',
  set_lsp_keymaps = true,
  manage_nvim_cmp = true,
})
lsp.skip_server_setup({'jdtls'})
lsp.nvim_workspace()
lsp.setup()
