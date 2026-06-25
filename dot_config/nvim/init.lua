vim.g.mapleader = ","

vim.opt.autocomplete = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.completeopt:append { "menuone", "noselect" }
vim.opt.signcolumn = "number"
vim.opt.number = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.diagnostic.config({ virtual_text = true })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, {
  noremap = true,
  silent = true,
  desc = "Show diagnostic error message",
})

require("cmdline-autocompletion")
require("lsp")
require("pack")
