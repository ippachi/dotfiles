local opt = vim.opt
local keymap = vim.keymap
local api = vim.api
local augroup = api.nvim_create_augroup("my-vimrc", { clear = true })
local cmd = vim.cmd

opt.autoindent = true
opt.swapfile = false
opt.backup = true
opt.backupdir = vim.env.HOME .. "/.config/nvim/backup/"
opt.cmdheight = 2
opt.colorcolumn = "120"
opt.completeopt = { "menu", "menuone", "noselect" }
opt.cursorline = true
opt.expandtab = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.foldmethod = "marker"
opt.smartcase = true
opt.number = true
opt.signcolumn = "number"
opt.pumblend = 15
opt.pumheight = 10
opt.termguicolors = true
opt.title = true
opt.undofile = true
opt.formatoptions:remove({ "ro" })
opt.formatoptions:append({ "mM" })
opt.diffopt = { "internal", "filler", "algorithm:histogram", "indent-heuristic" }
opt.updatetime = 300
opt.grepprg = "rg --vimgrep --no-heading --smart-case"
opt.grepformat = "%f:%l:%c:%m"

vim.g.mapleader = ","

keymap.set("n", "j", "gj", { noremap = true })
keymap.set("n", "k", "gk", { noremap = true })
keymap.set("t", "<c-o>", "<c-/><c-n>", { noremap = true })

api.nvim_create_autocmd("QuickFixCmdPost", {
  group = augroup,
  pattern = "*",
  callback = "copen",
})

api.nvim_create_autocmd("BufWritePost", {
  group = augroup,
  pattern = "plugins.lua",
  callback = function()
    vim.cmd([[PackerCompile]])
  end,
})

require("plugins")
