vim.g.mapleader = ","

vim.opt.autocomplete = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.completeopt:append { "menuone", "noselect", "fuzzy" }
vim.opt.signcolumn = "number"
vim.opt.number = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.cursorline = true

vim.diagnostic.config({ virtual_text = true })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, {
  noremap = true,
  silent = true,
  desc = "Show diagnostic error message",
})
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], {
  desc = "Exit terminal mode",
})
vim.filetype.add({
  extension = {
    jbuilder = "ruby",
  },
})
vim.keymap.set("t", "<C-o>", [[<C-\><C-n>]], {
  desc = "Terminal: Normal mode",
})

require("cmdline-autocompletion")
require("lsp")
require("pack")
