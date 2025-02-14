local keymap = vim.keymap
local api = vim.api
local augroup = api.nvim_create_augroup("my-vimrc", { clear = true })

vim.opt.autoindent = true
vim.opt.smartindent = true

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.backupdir = vim.env.HOME .. "/.config/nvim/backup/"

vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.pumheight = 10

vim.opt.number = true
vim.opt.signcolumn = "number"

vim.opt.cmdheight = 2
vim.opt.title = false
vim.opt.undofile = true
vim.opt.mouse = ""
vim.opt.formatoptions:append({
  t = true,
  m = true,
  M = true,
})
vim.opt.diffopt = { "internal", "filler", "algorithm:histogram", "indent-heuristic", "linematch:60" }
vim.opt.updatetime = 300
vim.opt.completeopt = { "menu", "menuone", "noselect", "popup" }
vim.opt.exrc = true

vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.breakindentopt = "shift:2,sbr"
vim.opt.breakat:remove(":@!")
vim.opt.showbreak = "\\"
vim.opt.wildmode = { "longest:full" }

vim.opt.grepprg = "rg --pcre2 --vimgrep"
vim.opt.grepformat:prepend("%f:%l:%c:%m")
vim.opt.cursorline = true

vim.cmd([[packadd Cfilter]])

keymap.set("n", "j", "gj", { noremap = true })
keymap.set("n", "k", "gk", { noremap = true })
keymap.set("n", "\\", ",", { noremap = true })
keymap.set("t", "<c-o>", "<c-\\><c-n>", { noremap = true })

vim.api.nvim_create_autocmd("QuickFixcmdPost", {
  group = augroup,
  pattern = { "grep", "vimgrep" },
  callback = function()
    vim.cmd([[cwindow]])
  end,
})

require("config.lazy")
