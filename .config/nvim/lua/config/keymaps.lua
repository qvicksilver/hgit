vim.api.nvim_set_keymap(
  "n",
  "<C-a>",
  ":Telescope file_browser path=%:p:h select_buffer=true<CR>",
  { noremap = true }
)
