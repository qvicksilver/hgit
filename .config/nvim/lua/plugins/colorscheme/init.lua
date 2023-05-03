return {
  {
    "navarasu/onedark.nvim",
    lazy = false,
    config = function()
      require('onedark').setup({
        style = 'darker'
      })
      require('onedark').load()
    end,
  },
}
