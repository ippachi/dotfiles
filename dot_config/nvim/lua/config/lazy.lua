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
      "nvim-treesitter/nvim-treesitter-context",
      opts = {},
      init = function()
        vim.keymap.set("n", "<leader>tc", "<Cmd>TSContextToggle<CR>")
      end
    },
    {
      "echasnovski/mini.nvim",
      version = false,
      config = function()
        require("mini.ai").setup()
        require("mini.align").setup()
        require("mini.pairs").setup()
        require("mini.surround").setup()
        require("mini.hipatterns").setup()
        require("mini.indentscope").setup()
        require("mini.trailspace").setup()
        require("mini.completion").setup({
          lsp_completion = { auto_setup = false },
        })

        vim.lsp.config['*'] = vim.tbl_extend("force", vim.lsp.config["*"], {
          capabilities = MiniCompletion.get_lsp_capabilities(),
        })
      end,
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
                reverse_directories = true,
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
    {
      "nvim-lualine/lualine.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      opts = {},
    },
    {
      "vim-test/vim-test",
      keys = {
        { "<leader>ts", "<Cmd>TestSuit<cr>" },
        { "<leader>tn", "<Cmd>TestNearest<cr>" },
        { "<leader>tf", "<Cmd>TestFile<cr>" },
        { "<leader>tl", "<Cmd>TestLast<cr>" },
        { "<leader>ts", "<Cmd>TestSuit<cr>" },
      },
      init = function()
        vim.g["test#strategy"] = "neovim_sticky"
        vim.g["test#neovim_sticky#reopen_window"] = 1
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
          sources = {
            null_ls.builtins.formatting.prettierd,
            null_ls.builtins.diagnostics.hadolint,
            require("none-ls.diagnostics.eslint_d"),
            require("none-ls.code_actions.eslint_d")
          },
        })
      end
    },
    {
      "github/copilot.vim",
      event = { "InsertEnter" },
      init = function()
        vim.g.copilot_settings = { selectedCompletionModel = 'gpt-4o-copilot' }
      end
    },
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
    {
      "yetone/avante.nvim",
      event = "VeryLazy",
      lazy = false,
      version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
      opts = {
        provider = "copilot",
        copilot = {
          -- model = "claude-3.5-sonnet"
          model = "claude-3.7-sonnet"
        },
        file_selector = {
          provider = "telescope"
        },
        mappings = {
          sidebar = {
            close = "q"
          }
        },
        behavior = {
          enable_claude_text_editor_tool_mode = true,
        }
      },
      -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
      build = "make",
      -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
      dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        --- The below dependencies are optional,
        "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
        "hrsh7th/nvim-cmp",              -- autocompletion for avante commands and mentions
        "nvim-tree/nvim-web-devicons",   -- or echasnovski/mini.icons
        "zbirenbaum/copilot.lua",        -- for providers='copilot'
        {
          -- support for image pasting
          "HakonHarnes/img-clip.nvim",
          event = "VeryLazy",
          opts = {
            -- recommended settings
            default = {
              embed_image_as_base64 = false,
              prompt_for_file_name = false,
              drag_and_drop = {
                insert_mode = true,
              },
              -- required for Windows users
              use_absolute_path = true,
            },
          },
        },
        {
          -- Make sure to set this up properly if you have lazy=true
          'MeanderingProgrammer/render-markdown.nvim',
          opts = {
            file_types = { "markdown", "Avante" },
          },
          ft = { "markdown", "Avante" },
        },
      },
    }
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  -- install = { colorscheme = { "blue" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})
