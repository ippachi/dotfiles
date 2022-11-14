local keymap = vim.keymap
local api = vim.api
local augroup = api.nvim_create_augroup("my-vimrc", { clear = true })

vim.opt.autoindent = true
vim.opt.swapfile = false
vim.opt.backup = true
vim.opt.backupdir = vim.env.HOME .. "/.config/nvim/backup/"
vim.opt.cmdheight = 2
vim.opt.colorcolumn = "120"
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.ignorecase = true
vim.opt.shiftwidth = 2
vim.opt.foldmethod = "marker"
vim.opt.smartcase = true
vim.opt.number = true
vim.opt.signcolumn = "number"
vim.opt.pumblend = 15
vim.opt.pumheight = 10
vim.opt.termguicolors = true
vim.opt.title = true
vim.opt.undofile = true
vim.opt.formatoptions:remove({ "ro" })
vim.opt.formatoptions:append({ "mM" })
vim.opt.diffopt = { "internal", "filler", "algorithm:histogram", "indent-heuristic" }
vim.opt.updatetime = 300
vim.opt.grepprg = "rg --vimgrep --no-heading --smart-case"
vim.opt.grepformat = "%f:%l:%c:%m"

vim.g.mapleader = ","

keymap.set("n", "j", "gj", { noremap = true })
keymap.set("n", "k", "gk", { noremap = true })
keymap.set("t", "<c-o>", "<c-/><c-n>", { noremap = true })

api.nvim_create_autocmd("QuickFixCmdPost", {
  group = augroup,
  pattern = "*",
  callback = "copen",
})

require("plugins")
