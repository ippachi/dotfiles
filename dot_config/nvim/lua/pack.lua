vim.pack.add({
  { src = "https://github.com/tpope/vim-fugitive" },
  { src = "https://github.com/rbong/vim-flog" },
  { src = "https://github.com/ibhagwan/fzf-lua" },
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },
  { src = "https://github.com/dlyongemallo/diffview-plus.nvim" },
  { src = "https://github.com/stevearc/conform.nvim" },
  { src = "https://github.com/nvim-mini/mini.surround" },
  { src = "https://github.com/nvim-mini/mini.trailspace" },
  { src = "https://github.com/stevearc/oil.nvim" },
  { src = "https://github.com/rebelot/kanagawa.nvim" },
  { src = "https://github.com/vim-test/vim-test" },
})

-- fzf-lua
require("fzf-lua").setup()
vim.keymap.set("n", "<C-p>", function()
  require("fzf-lua").combine({
    pickers = "oldfiles;git_files",
    cwd_only = true,
    include_current_session = true
  })
end)

vim.keymap.set("n", "<leader>gg", function()
  require("fzf-lua").live_grep({
    keymap = {
      fzf = {
        ["ctrl-q"] = "select-all+accept",
      },
    },
    actions = {
      ["ctrl-q"] = false,
    },
  })
end)

-- diffview-plus
vim.keymap.set("n", "<leader>do", function() vim.cmd[[DiffviewOpen]] end)
require("diffview").setup({
  enhanced_diff_hl = true,
  keymaps = {
    file_panel = {
      {
        "n", "cc",
        "<Cmd>Git commit <bar> wincmd J<CR>",
        { desc = "Commit staged changes" },
      },
      {
        "n", "ca",
        "<Cmd>Git commit --amend <bar> wincmd J<CR>",
        { desc = "Amend the last commit" },
      },
      {
        "n", "c<space>",
        ":Git commit ",
        { desc = "Populate command line with \":Git commit \"" },
      },
    },
  }
})

-- conform
require("conform").setup({
  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_format = "fallback",
  },
  formatters_by_ft = {
    javascript = { "prettierd", "prettier", stop_after_first = true, lsp_format = "fallback" },
    typescript = { "prettierd", "prettier", stop_after_first = true, lsp_format = "fallback" },
    javascriptreact = { "prettierd", "prettier", stop_after_first = true, lsp_format = "fallback" },
    typescriptreact = { "prettierd", "prettier", stop_after_first = true, lsp_format = "fallback" },
  },
})

-- mini.surround
require('mini.surround').setup()

-- mini.trailspace
require('mini.trailspace').setup()

-- oil.nvim
require("oil").setup()
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- kanagawa.nvim
vim.cmd.colorscheme("kanagawa")

-- vim-test
vim.keymap.set("n", "<leader>tn", ":TestNearest<CR>", { silent = true, desc = "Run nearest test" })
vim.keymap.set("n", "<leader>tl", ":TestLast<CR>",    { silent = true, desc = "Run last test" })
vim.keymap.set("n", "<leader>tf", ":TestFile<CR>",    { silent = true, desc = "Run current file tests" })
