return {
  {"nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      local components = require "plugins.statusline.components"
      require('lualine').setup({
        options = {
          globalstatus = true,
          theme = 'auto',
          -- From Modern Neovim
          component_separators = {},
          section_separators = {},
          disabled_filetypes = {
            statusline = { "alpha", "lazy" },
            winbar = {
              "help",
              "alpha",
              "lazy",
            },
          },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { components.git_repo, "branch" },
          lualine_c = { components.diff, components.diagnostics, components.separator, components.lsp_client },
          lualine_x = { "filename", components.spaces, "encoding", "fileformat", "filetype", "progress" },
          lualine_y = {},
          lualine_z = { "location" },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        extenstion = { "nvim-tree", "toggleterm", "quickfix" }
      })
    end,
  },
}
