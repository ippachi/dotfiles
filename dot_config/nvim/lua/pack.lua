local hooks = function(ev)
  -- Use available |event-data|
  local name, kind = ev.data.spec.name, ev.data.kind

  -- Run build script after plugin's code has changed
  -- if name == 'plug-1' and (kind == 'install' or kind == 'update') then
  --   -- Append `:wait()` if you need synchronous execution
  --   vim.system({ 'make' }, { cwd = ev.data.path })
  -- end

  -- If action relies on code from the plugin (like user command or
  -- Lua code), make sure to explicitly load it first
  -- if name == 'plug-2' and kind == 'update' then
  --   if not ev.data.active then
  --     vim.cmd.packadd('plug-2')
  --   end
  --   vim.cmd('PlugTwoUpdate')
  --   require('plug2').after_update()
  -- end
end

-- If hooks need to run on install, run this before `vim.pack.add()`
-- To act on install from lockfile, run before very first `vim.pack.add()`
vim.api.nvim_create_autocmd('PackChanged', { callback = hooks })

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
  { src = "https://github.com/mfussenegger/nvim-lint" },
  { src = "https://github.com/coder/claudecode.nvim" },
  { src = "https://github.com/folke/snacks.nvim" },
  { src = "https://github.com/lewis6991/gitsigns.nvim" },
  { src = "https://github.com/tpope/vim-rails" },
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
  view = {
    merge_tool = {
      layout = "diff4_mixed",
    },
  },
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

-- nvim-lint
require('lint').linters_by_ft = {
  typescript = {'eslint_d'},
  typescriptreact = {'eslint_d'},
}
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()
    require("lint").try_lint()
  end,
})

-- claudecode.nvim
require("claudecode").setup({})
vim.keymap.set("n", "<leader>ac", "<cmd>ClaudeCode<cr>", { desc = "Toggle Claude" })
vim.keymap.set("n", "<leader>af", "<cmd>ClaudeCodeFocus<cr>", { desc = "Focus Claude" })
vim.keymap.set("n", "<leader>ar", "<cmd>ClaudeCode --resume<cr>", { desc = "Resume Claude" })
vim.keymap.set("n", "<leader>aC", "<cmd>ClaudeCode --continue<cr>", { desc = "Continue Claude" })
vim.keymap.set("n", "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", { desc = "Select Claude model" })
vim.keymap.set("n", "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", { desc = "Add current buffer" })
vim.keymap.set("v", "<leader>as", "<cmd>ClaudeCodeSend<cr>", { desc = "Send to Claude" })
vim.keymap.set(
  "n",
  "<leader>as",
  "<cmd>ClaudeCodeTreeAdd<cr>",
  {
    desc = "Add file",
    buffer = 0, -- 対象のファイルツリーのバッファでのみ設定する場合
  }
)
vim.keymap.set("n", "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", { desc = "Accept diff" })
vim.keymap.set("n", "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", { desc = "Deny diff" })

-- gitsigns.nvim
require("gitsigns").setup({})
