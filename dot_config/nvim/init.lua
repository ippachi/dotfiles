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

vim.g.mapleader = ","

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

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme kanagawa]])
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {},
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        auto_install = true,
        highlight = {
          enable = true,
          disable = { "embedded_template" },
        }
      })
    end,
  },
  {
    "echasnovski/mini.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    version = false,
    config = function()
      require("mini.surround").setup()
      require("mini.trailspace").setup()
      require("mini.ai").setup()
      require("mini.hipatterns").setup()
      require("mini.indentscope").setup()
      require("mini.extra").setup()
      require("mini.align").setup()
    end,
  },
  {
    "tpope/vim-fugitive",
    cmd = "Git",
  },
  {
    "sindrets/diffview.nvim",
    lazy = false,
    keys = {
      { "<leader>do", "<cmd>DiffviewOpen<cr>" },
      { "<leader>df", "<cmd>DiffviewFileHistory<cr>" },
    },
    dependencies = {
      "tpope/vim-fugitive",
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
      hooks = {
        view_leave = function(view)
          view:close()
        end
      }
    },
  },
  {
    "AndrewRadev/linediff.vim",
    cmd = "Linediff",
  },
  {
    "rbong/vim-flog",
    cmd = { "Flog", "Flogsplit", "Floggit" },
    dependencies = { "tpope/vim-fugitive" },
  },
  {
    "stevearc/oil.nvim",
    keys = { { "-", "<cmd>Oil<cr>" } },
    opts = {},
  },
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      {
        "<C-p>",
        function()
          require("telescope.builtin").find_files()
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
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      -- You dont need to set any of these options. These are the default ones. Only
      -- the loading is important
      require("telescope").setup({
        defaults = {
          path_display = {
            filename_first = {
              reverse_directories = true,
            },
          },
        },
        pickers = {
          live_grep = {
            additional_args = { "--hidden", "--glob", "!**/.git/*" }
          },
        },
      })
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
  },
  {
    "vim-test/vim-test",
    lazy = false,
    keys = {
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
    "neovim/nvim-lspconfig",
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end)
          vim.keymap.set("n", "<leader>e", function() vim.diagnostic.open_float() end)
          vim.api.nvim_buf_create_user_command(args.buf, "Format",
            function() vim.lsp.buf.format({ async = true }) end, {})
        end,
      })

      local lspconfig = require("lspconfig")
      lspconfig.ruby_lsp.setup {}
      lspconfig.ts_ls.setup {}
      lspconfig.lua_ls.setup {
        on_init = function(client)
          if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if path ~= vim.fn.stdpath('config') and (vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc')) then
              return
            end
          end

          client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
              -- Tell the language server which version of Lua you're using
              -- (most likely LuaJIT in the case of Neovim)
              version = 'LuaJIT'
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME
                -- Depending on the usage, you might want to add additional paths here.
                -- "${3rd}/luv/library"
                -- "${3rd}/busted/library",
              }
              -- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
              -- library = vim.api.nvim_get_runtime_file("", true)
            }
          })
        end,
        settings = {
          Lua = {}
        }
      }
    end
  },
  {
    'saghen/blink.compat',
    -- use the latest release, via version = '*', if you also use the latest release for blink.cmp
    version = '*',
    -- lazy.nvim will automatically load the plugin when it's required by blink.cmp
    lazy = true,
    -- make sure to set opts so that lazy.nvim calls blink.compat's setup
    opts = {},
  },
  {
    'saghen/blink.cmp',
    -- optional: provides snippets for the snippet source
    dependencies = {
      'rafamadriz/friendly-snippets',
      "fang2hou/blink-copilot"
    },

    -- use a release tag to download pre-built binaries
    version = '*',
    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' for mappings similar to built-in completion
      -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
      -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
      -- See the full "keymap" documentation for information on defining your own keymap.
      keymap = { preset = 'default' },

      appearance = {
        -- Sets the fallback highlight groups to nvim-cmp's highlight groups
        -- Useful for when your theme doesn't support blink.cmp
        -- Will be removed in a future release
        use_nvim_cmp_as_default = true,
        -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono'
      },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = { 'copilot', 'lsp', 'path', 'snippets', 'buffer' },
        providers = {
          lsp = {
            fallbacks = {}
          },
          copilot = {
            name = "copilot",
            module = "blink-copilot",
            async = true,
          },
        }
      },

      appearance = {
        kind_icons = {
          Copilot = "",
        },
      },

      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 0,
        },
        menu = { auto_show = function(ctx) return ctx.mode ~= 'cmdline' end },
        list = {
          selection = {
            preselect = false, auto_insert = true
          }
        }
      },
      keymap = {
        preset = 'default',
        ['<C-L>'] = { 'show', 'show_documentation', 'hide_documentation' },
        cmdline = {}
      }
    },
    opts_extend = { "sources.default" }
  },
  {
    "windwp/nvim-ts-autotag",
    opts = {}
  },
  {
    "nvimtools/none-ls.nvim",
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.prettierd,
        },
      })
    end
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
  },
})
