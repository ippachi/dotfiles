-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = ","
vim.g.maplocalleader = "_"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    {
      "rebelot/kanagawa.nvim",
      lazy = false,
      priority = 1000,
      init = function()
        vim.cmd [[colorscheme kanagawa]]
      end
    },
    {
      "lewis6991/gitsigns.nvim",
      opts = {
        on_attach = function(bufnr)
          local gitsigns = require('gitsigns')
          vim.keymap.set('n', '<leader>hp', gitsigns.preview_hunk, { buffer = bufnr })
        end
      }
    },
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      main = "nvim-treesitter.configs",
      init = function()
        vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      end,
      opts = {
        auto_install = true,
        highlight = {
          enable = true
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            node_incremental = "v",
            node_decremental = "V",
          }
        }
      },
    },
    {
      "echasnovski/mini.nvim",
      version = false,
      config = function()
        require("mini.ai").setup()
        require("mini.align").setup()
        require("mini.surround").setup()
        require("mini.hipatterns").setup()
        require("mini.indentscope").setup()
        require("mini.trailspace").setup()
        require("mini.statusline").setup()
        -- require("mini.completion").setup({
        --   lsp_completion = { auto_setup = false },
        -- })

        -- vim.lsp.config['*'] = vim.tbl_extend("force", vim.lsp.config["*"], {
        --   capabilities = MiniCompletion.get_lsp_capabilities(),
        -- })
      end,
    },
    {
      'saghen/blink.cmp',
      -- optional: provides snippets for the snippet source
      dependencies = { 'rafamadriz/friendly-snippets' },

      -- use a release tag to download pre-built binaries
      version = '1.*',
      -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
      -- build = 'cargo build --release',
      -- If you use nix, you can build from source using latest nightly rust with:
      -- build = 'nix run .#build-plugin',

      ---@module 'blink.cmp'
      ---@type blink.cmp.Config
      opts = {
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
          documentation = { auto_show = true },
          list = { selection = { preselect = false, auto_insert = true } },
        },

        -- Default list of enabled providers defined so that you can extend it
        -- elsewhere in your config, without redefining it, due to `opts_extend`
        sources = {
          default = { 'lsp', 'path', 'snippets', 'buffer' },
          providers = {
            -- defaults to `{ 'buffer' }`
            lsp = { fallbacks = {} }
          }
        },

        -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
        -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
        -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
        --
        -- See the fuzzy documentation for more information
        fuzzy = { implementation = "prefer_rust_with_warning" }
      },
      opts_extend = { "sources.default" }
    },
    {
      "tpope/vim-fugitive",
      cmd = "Git",
    },
    {
      "sindrets/diffview.nvim",
      dependencies = {
        "tpope/vim-fugitive",
      },
      cmd = { "DiffviewOpen", "DiffviewFileHistory" },
      keys = {
        { "<leader>do", "<cmd>DiffviewOpen<cr>" },
        { "<leader>df", "<cmd>DiffviewFileHistory<cr>" },
      },
      opts = {
        view = {
          merge_tool = {
            layout = "diff4_mixed",
          },
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
        },
      },
    },
    {
      "AndrewRadev/linediff.vim",
      cmd = "Linediff",
    },
    {
      "rbong/vim-flog",
      dependencies = { "tpope/vim-fugitive" },
      cmd = { "Flog", "Flogsplit", "Floggit" },
    },
    {
      "stevearc/oil.nvim",
      opts = {},
      init = function()
        vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
      end
    },
    {
      "nvim-telescope/telescope.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        {
          "nvim-telescope/telescope-frecency.nvim",
          version = "*"
        }
      },
      cmd = "Telescope",
      keys = {
        {
          "<C-p>",
          function()
            require("telescope").extensions.frecency.frecency {}
          end,
        },
        {
          "<leader>gg",
          function()
            require("telescope.builtin").live_grep()
          end,
        },
        {
          ":h ",
          function()
            require("telescope.builtin").help_tags()
          end,
        },
      },
      config = function()
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
      end,
    },
    -- {
    --   "nvim-lualine/lualine.nvim",
    --   dependencies = { "nvim-tree/nvim-web-devicons" },
    --   opts = {},
    -- },
    {
      "vim-test/vim-test",
      keys = {
        { "<leader>ts", "<Cmd>TestSuit<cr>" },
        { "<leader>tn", "<Cmd>TestNearest<cr>" },
        { "<leader>tf", "<Cmd>TestFile<cr>" },
        { "<leader>tl", "<Cmd>TestLast<cr>" },
      },
      init = function()
        vim.g["test#strategy"] = "dispatch"
        -- vim.g["test#neovim_sticky#reopen_window"] = 1
      end
    },
    {
      "windwp/nvim-ts-autotag",
      ft = { "html", "typescriptreact", "javascriptreact", "typescript", "javascript" },
      opts = {}
    },
    {
      "nvimtools/none-ls.nvim",
      dependencies = {
        "nvimtools/none-ls-extras.nvim",
      },
      config = function()
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
      end
    },
    -- {
    --   "github/copilot.vim",
    --   event = { "InsertEnter" },
    --   init = function()
    --     vim.g.copilot_settings = { selectedCompletionModel = 'gpt-4o-copilot' }
    --     vim.keymap.set('i', '<C-L>', '<Plug>(copilot-accept-word)')
    --   end
    -- },
    {
      'folke/snacks.nvim',
      priority = 1000,
      lazy = false,
      opts = {
        input = { enabled = true }
      },
    },
    {
      "j-hui/fidget.nvim",
      opts = {}
    },
    {
      'nvimdev/lspsaga.nvim',
      dependencies = {
        'nvim-treesitter/nvim-treesitter', -- optional
        'nvim-tree/nvim-web-devicons',     -- optional
      },
      keys = {
        { "gra", "<Cmd>Lspsaga code_action<cr>" }
      },
      config = function()
        require('lspsaga').setup({})
      end,
    },
    { "tpope/vim-rails" },
    { "tpope/vim-dispatch" }
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  -- install = { colorscheme = { "blue" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})
