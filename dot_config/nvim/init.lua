vim.g.mapleader = ","

vim.opt.autocomplete = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.completeopt:append { "menuone", "noselect" }
vim.opt.signcolumn = "number"
vim.opt.number = true
vim.opt.undofile = true

require("cmdline-autocompletion")
require("lsp")
require("pack")
