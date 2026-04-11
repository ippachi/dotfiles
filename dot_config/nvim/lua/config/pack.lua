vim.g.mapleader = ","
vim.g.maplocalleader = "_"

vim.opt.packpath:append(vim.fn.stdpath('data') .. '/site')

local gh = function(x) return 'https://github.com/' .. x end

vim.pack.add({
  gh("rebelot/kanagawa.nvim"),
  gh("lewis6991/gitsigns.nvim"),
  gh("tpope/vim-fugitive"),
  gh("nvim-tree/nvim-web-devicons"),
  gh("dlyongemallo/diffview.nvim"),
  gh("rbong/vim-flog"),
  gh("stevearc/oil.nvim"),
  gh("nvim-telescope/telescope.nvim"),
  gh("nvim-lua/plenary.nvim"),
  gh("nvim-telescope/telescope-frecency.nvim"),
  gh("vim-test/vim-test"),
  gh("windwp/nvim-ts-autotag"),
  gh("nvimtools/none-ls.nvim"),
  gh("nvimtools/none-ls-extras.nvim"),
  gh("tpope/vim-dispatch"),
  gh("stevearc/quicker.nvim"),
  gh("tpope/vim-rails"),
  {
    src = gh("saghen/blink.cmp"),
    version = vim.version.range("1.*")
  },
  gh("rafamadriz/friendly-snippets"), -- for blink.cmp
}, {
  load = true,
  confirm = false
})

vim.cmd.colorscheme('kanagawa')

require('gitsigns').setup {}
require("quicker").setup {}

vim.keymap.set('n', '<leader>do', '<cmd>DiffviewOpen<cr>')
require('diffview').setup {
  enhanced_diff_hl = true,
  use_icons = true,
  view = {
    merge_tool = { layout = "diff4_mixed" },
  },
  keymaps = {
    file_panel = {
      {
        "n",
        "cc",
        "<Cmd>Git commit <bar> wincmd J<CR>",
        { desc = "Commit staged changes" },
      },
      {
        "n",
        "ca",
        "<Cmd>Git commit --amend <bar> wincmd J<CR>",
        { desc = "Amend the last commit" },
      },
    },
  }
}

require('oil').setup {}
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

vim.keymap.set("n", "<C-p>", function() require("telescope").extensions.frecency.frecency {} end)
vim.keymap.set("n", "<leader>gg", function() require("telescope.builtin").live_grep() end)
vim.keymap.set("n", ":h ", function() require("telescope.builtin").help_tags() end)
local telescope = require("telescope")
telescope.setup({
  defaults = {
    path_display = {
      filename_first = {
        reverse_directories = false,
      },
    },
  },
  pickers = {
    live_grep = {
      additional_args = { "--hidden", "--glob", "!**/.git*" }
    },
  },
  extensions = {
    frecency = {
      default_workspace = "CWD",
      workspaces = {
        NVIM = "~/.config/nvim"
      },
      unregister_hidden = true,
      show_scores = true,
      db_version = "v2"
    }
  },
})
telescope.load_extension("frecency")

vim.g["test#strategy"] = "dispatch"
vim.keymap.set("n", "<leader>ts", "<Cmd>TestSuit<cr>")
vim.keymap.set("n", "<leader>tn", "<Cmd>TestNearest<cr>")
vim.keymap.set("n", "<leader>tf", "<Cmd>TestFile<cr>")
vim.keymap.set("n", "<leader>tl", "<Cmd>TestLast<cr>")

local null_ls = require("null-ls")
null_ls.setup({
  debounce = 2000,
  sources = {
    null_ls.builtins.formatting.prettierd,
    null_ls.builtins.diagnostics.hadolint,
    require("none-ls.diagnostics.eslint_d"),
    require("none-ls.code_actions.eslint_d")
  },
  should_attach = function(bufnr)
    local name = vim.api.nvim_buf_get_name(bufnr)
    if name:match("^diffview://") then
      return false
    end
    return true
  end,
})

require("blink.cmp").setup {
  -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
  -- 'super-tab' for mappings similar to vscode (tab to accept)
  -- 'enter' for enter to accept
  -- 'none' for no mappings
  --
  -- All presets have the following mappings:
  -- C-space: Open menu or open docs if already open
  -- C-n/C-p or Up/Down: Select next/previous item
  -- C-e: Hide menu
  -- C-k: Toggle signature help (if signature.enabled = true)
  --
  -- See :h blink-cmp-config-keymap for defining your own keymap
  keymap = { preset = 'default' },

  appearance = {
    -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
    -- Adjusts spacing to ensure icons are aligned
    nerd_font_variant = 'mono'
  },

  -- (Default) Only show the documentation popup when manually triggered
  completion = {
    list = { selection = { preselect = false } },
    documentation = { auto_show = false }
  },

  -- Default list of enabled providers defined so that you can extend it
  -- elsewhere in your config, without redefining it, due to `opts_extend`
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
  },

  -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
  -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
  -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
  --
  -- See the fuzzy documentation for more information
  fuzzy = { implementation = "prefer_rust_with_warning" }
}

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
