-- Secure editing of gopass seecrets
vim.api.nvim_create_autocmd({
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

