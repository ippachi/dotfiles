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
      opts = {
        auto_install = true,
        highlight = {
          enable = true
        }
      },
    },
    {
      "echasnovski/mini.nvim",
      version = false,
      config = function()
        require("mini.align").setup()
        require("mini.pairs").setup()
        require("mini.surround").setup()
        require("mini.hipatterns").setup()
        require("mini.indentscope").setup()
        require("mini.trailspace").setup()
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
              additional_args = { "--hidden", "--glob", "!**/.git/*" }
            },
          },
          extensions = {
            frecency = {
              default_workspace = "CWD",
              workspaces = {
                NVIM = "~/.config/nvim"
              }
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
      "neovim/nvim-lspconfig",
      dependencies = {
        "hrsh7th/cmp-nvim-lsp"
      },
      config = function()
        vim.api.nvim_create_autocmd('LspAttach', {
          callback = function(args)
            vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end)
            vim.keymap.set("n", "<leader>e", function() vim.diagnostic.open_float() end)
            vim.api.nvim_buf_create_user_command(args.buf, "Format",
              function() vim.lsp.buf.format({ async = true }) end, {})
          end,
        })

        local lspconfig = require("lspconfig")
        local capabilities = require('cmp_nvim_lsp').default_capabilities()

        lspconfig.ruby_lsp.setup {
          capabilities = capabilities
        }
        lspconfig.ts_ls.setup {
          capabilities = capabilities
        }
        lspconfig.lua_ls.setup {
          capabilities = capabilities,
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
      "windwp/nvim-ts-autotag",
      ft = { "html", "typescriptreact", "javascriptreact", "typescript", "javascript" },
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
      "hrsh7th/nvim-cmp",
      dependencies = {
        {
          "hrsh7th/cmp-nvim-lsp",
          dependencies = {
            "neovim/nvim-lspconfig",
          },
          "hrsh7th/cmp-buffer",
          "hrsh7th/cmp-path",
          "hrsh7th/cmp-cmdline",
          "hrsh7th/cmp-vsnip",
          "hrsh7th/vim-vsnip"
        }
      },
      event = { "InsertEnter", "CmdlineEnter" },
      config = function()
        local cmp = require 'cmp'

        cmp.setup({
          snippet = {
            expand = function(args)
              vim.fn["vsnip#anonymous"](args.body)
            end,
          },
          mapping = cmp.mapping.preset.insert({
            ['<C-b>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-l>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.abort(),
            ['<C-y>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          }),
          sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'vsnip' },
          }, {
            { name = 'path' }
          }, {
            { name = 'buffer' },
          })
        })

        -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline({ '/', '?' }, {
          mapping = cmp.mapping.preset.cmdline(),
          sources = {
            { name = 'buffer' }
          }
        })

        -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline(':', {
          mapping = cmp.mapping.preset.cmdline(),
          sources = cmp.config.sources({
            { name = 'path' }
          }, {
            { name = 'cmdline' }
          }),
          matching = { disallow_symbol_nonprefix_matching = false }
        })
      end
    },
    {
      "github/copilot.vim",
      event = { "InsertEnter" }
    }
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  -- install = { colorscheme = { "blue" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})
