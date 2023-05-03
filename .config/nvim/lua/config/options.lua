vim.opt.cmdheight = 0
vim.opt.completeopt = "menuone,noselect"
vim.opt.expandtab = true
vim.opt.ignorecase = true
vim.opt.laststatus = 0
vim.opt.pumblend = 10
vim.opt.pumheight = 10
vim.opt.shiftround = true
vim.opt.shiftwidth = 2
vim.opt.signcolumn = "yes"
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.tabstop = 2
vim.opt.termguicolors = true
vim.opt.wildignorecase = true
vim.opt.wildmode = "longest:full,full"

vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0

-- Remap leader and local leader to <Space>
vim.api.nvim_set_keymap("", "<Space", "<Nop>", { noremap = true, silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.api.nvim_set_keymap("n", "<leader><leader>", ":nohlsearch<Bar>:echo<CR>", { noremap = true, silent = true })

