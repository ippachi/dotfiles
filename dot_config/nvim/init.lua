local keymap = vim.keymap
local api = vim.api
local augroup = api.nvim_create_augroup("my-vimrc", { clear = true })

vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.swapfile = false
vim.opt.backup = true
vim.opt.backupdir = vim.env.HOME .. "/.config/nvim/backup/"
vim.opt.cmdheight = 2
vim.opt.colorcolumn = "120"
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.splitbelow = true
vim.opt.splitright = true
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
vim.opt.formatoptions:append({
  t = true,
  m = true,
  M = true,
})
vim.opt.diffopt = { "internal", "filler", "algorithm:histogram", "indent-heuristic" }
vim.opt.updatetime = 300
vim.opt.grepprg = "rg --vimgrep --no-heading --smart-case"
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.cmd [[set efm+=%f\|%l\ col\ %c\|%m]]

vim.g.mapleader = ","

keymap.set("n", "j", "gj", { noremap = true })
keymap.set("n", "k", "gk", { noremap = true })
keymap.set("t", "<c-o>", "<c-/><c-n>", { noremap = true })

vim.api.nvim_create_autocmd("QuickFixcmdPost", {
  group = augroup,
  pattern = { "grep", "vimgrep" },
  callback = function() vim.cmd [[cwindow]] end
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
  { "rebelot/kanagawa.nvim", lazy = false, priority = 1000, config = function() vim.cmd [[colorscheme kanagawa]] end },
  { "nvim-lualine/lualine.nvim", config = true, dependencies = { "kyazdani42/nvim-web-devicons" } },
  "ntpeters/vim-better-whitespace",
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require('gitsigns').setup({
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)

          end

          map({ 'n', 'v' }, '<leader>hs', ':Gitsigns stage_hunk<CR>')
          map({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<CR>')
          map('n', '<leader>hS', gs.stage_buffer)
          map('n', '<leader>hu', gs.undo_stage_hunk)
          map('n', '<leader>hR', gs.reset_buffer)
          map('n', '<leader>hp', gs.preview_hunk)
          map('n', '<leader>hb', function() gs.blame_line { full = true } end)
          map('n', '<leader>tb', gs.toggle_current_line_blame)
          map('n', '<leader>hd', gs.diffthis)
          map('n', '<leader>hD', function() gs.diffthis('~') end)
          map('n', '<leader>td', gs.toggle_deleted)
        end
      })
    end
  },
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = { "RRethy/nvim-treesitter-endwise" },
    build = ":TSUpdate",
    config = function()
      require('nvim-treesitter.configs').setup {
        highlight = { enable = true },
        indent = { enable = true },
        endwise = { enable = true },
      }
    end
  },
  "lukas-reineke/indent-blankline.nvim",
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim", { "j-hui/fidget.nvim", config = true },
        "hrsh7th/cmp-nvim-lsp", { "folke/neodev.nvim", config = true } },
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup()

      local opts = { noremap = true, silent = true }

      vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
      vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)

      -- Use an on_attach function to only map the following keys
      -- after the language server attaches to the current buffer
      local on_attach = function(client, bufnr)
        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local bufopts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
        vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
        vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
        vim.keymap.set('n', '<leader>wl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, bufopts)
        vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
        vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, bufopts)
      end

      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- Mason
      for _, name in ipairs({ 'sumneko_lua', 'tsserver', 'eslint' }) do
        require('lspconfig')[name].setup {
          on_attach = on_attach,
          capabilities = capabilities,
        }
      end

      -- Manual
      for _, name in ipairs({ 'solargraph' }) do
        require('lspconfig')[name].setup {
          on_attach = on_attach,
          capabilities = capabilities,
        }
      end
    end
  },
  { "stevearc/dressing.nvim", config = true },
  { "xiyaowong/nvim-transparent", opts = { enable = true } },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { { "nvim-tree/nvim-web-devicons", name = "nvim-tree-nvim-web-devicons" } },
    tag = "nightly",
    init = function() vim.keymap.set("n", "<space>f", "<cmd>NvimTreeFindFileToggle<cr>") end,
    opts = {
      actions = {
        open_file = {
          quit_on_open = true,
        },
      },
    }
  },

  -- lazy
  { "machakann/vim-sandwich", keys = { "sr", "sd" } },
  { "windwp/nvim-autopairs", event = "InsertEnter", config = true },
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    init = function()
      vim.keymap.set("n", "<c-p>", "<cmd>Telescope find_files<cr>")
      vim.keymap.set("n", "<space>r", "<cmd>Telescope resume<cr>")
      vim.api.nvim_create_user_command("Grep", "Telescope live_grep", { force = true })
    end,
    cmd = { "Telescope" },
  },
  {
    "vimwiki/vimwiki",
    init = function()
      vim.g.vimwiki_list = {
        {
          path = "~/Documents/private/wiki/",
          ext = ".md",
          syntax = "markdown",
          template_path = "~/Documents/private/wiki/templates",
          template_default = "def_template",
          template_ext = ".md",
        },
      }
      vim.keymap.set("n", "<leader>ww", "<cmd>VimwikiIndex<cr>")
    end,
    cmd = "VimwikiIndex",
  },
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    init = function()
      keymap.set("n", "<leader>g", "<Cmd>DiffviewOpen<CR>", { noremap = true })
    end,
    cmd = "DiffviewOpen"
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = { "hrsh7th/cmp-buffer", "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-path" },
    config = function()
      local cmp = require 'cmp'

      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ['<C-e>'] = cmp.mapping.abort(),
          ['<C-y>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        }),
        sources = cmp.config.sources({
          { name = "buffer", option = {
            get_bufnrs = function()
              return vim.api.nvim_list_bufs()
            end
          } }
        })
      })

      keymap.set("i", "<C-x><C-o>", cmp.mapping.complete({ config = { sources = { { name = "nvim_lsp" } } } }))
    end
  },
  {
    "tpope/vim-fugitive", cmd = "Git"
  },
  { "iamcco/markdown-preview.nvim", ft = { "vimwiki" }, build = function() vim.fn["mkdp#util#install"]() end },
})
