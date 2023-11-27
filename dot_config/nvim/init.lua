local keymap = vim.keymap
local api = vim.api
local augroup = api.nvim_create_augroup("my-vimrc", { clear = true })

vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.backupdir = vim.env.HOME .. "/.config/nvim/backup/"
vim.opt.cmdheight = 2
vim.opt.colorcolumn = "100"
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
vim.opt.title = true
vim.opt.undofile = true
vim.opt.mouse = ""
vim.opt.formatoptions:append({
  t = true,
  m = true,
  M = true,
})
vim.opt.diffopt = { "internal", "filler", "algorithm:histogram", "indent-heuristic", "linematch:60" }
vim.opt.updatetime = 300
vim.opt.grepprg = "rg --vimgrep --no-heading --smart-case"
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.cmd([[set efm+=%f\|%l\ col\ %c\|%m]])

vim.cmd([[packadd Cfilter]])

vim.g.mapleader = ","

keymap.set("n", "j", "gj", { noremap = true })
keymap.set("n", "k", "gk", { noremap = true })
keymap.set("t", "<c-o>", "<c-\\><c-n>", { noremap = true })

vim.api.nvim_create_autocmd("QuickFixcmdPost", {
  group = augroup,
  pattern = { "grep", "vimgrep" },
  callback = function()
    vim.cmd([[cwindow]])
  end,
})

vim.api.nvim_create_autocmd("TermOpen", {
  group = augroup,
  pattern = { "*" },
  callback = function()
    vim.cmd([[DisableWhitespace]])
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
    "nvim-lualine/lualine.nvim",
    dependencies = { "kyazdani42/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        sections = {
          lualine_c = {
            {
              "filename",
              path = 1
            },
          },
        },
      })
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>")
          map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>")
          map("n", "<leader>hS", gs.stage_buffer)
          map("n", "<leader>hu", gs.undo_stage_hunk)
          map("n", "<leader>hR", gs.reset_buffer)
          map("n", "<leader>hp", gs.preview_hunk)
          map("n", "<leader>hb", function()
            gs.blame_line({ full = true })
          end)
          map("n", "<leader>tb", gs.toggle_current_line_blame)
          map("n", "<leader>hd", gs.diffthis)
          map("n", "<leader>hD", function()
            gs.diffthis("~")
          end)
          map("n", "<leader>td", gs.toggle_deleted)
        end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "RRethy/nvim-treesitter-endwise",
      "nvim-treesitter/playground",
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        highlight = {
          enable = true,
          disable = { "embedded_template" },
        },
        endwise = { enable = true },
        textobjects = {
          select = {
            enable = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
            },
          },
        },
      })
    end,
  },
  { "itchyny/vim-qfedit" },
  {
    "stevearc/oil.nvim",
    config = true,
  },
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-ghq.nvim",
      "nvim-telescope/telescope-frecency.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      local cycle = require "telescope.cycle" (
        require 'telescope'.extensions.frecency.frecency,
        require "telescope.builtin".find_files
      )
      require("telescope").setup({
        defaults = {
          layout_strategy = "vertical",
          mappings = {
            i = {
              ["<C-l>"] = function () cycle.next() end,
            },
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
          frecency = {
            show_filter_column = false,
            default_workspace = "CWD",
            show_unindexed = false,
            show_scores = true
          }
        },
      })
      require("telescope").load_extension("fzf")
      require("telescope").load_extension("ghq")
      require("telescope").load_extension("frecency")

      vim.keymap.set("n", "<c-p>", function () cycle() end)
      vim.keymap.set("n", "<space>r", "<cmd>Telescope resume<cr>")
      vim.keymap.set("n", ":h<space>", "<cmd>Telescope help_tags<cr>")
      vim.api.nvim_create_user_command("Grep", "Telescope live_grep", { force = true })
    end,
  },
  {
    "neoclide/coc.nvim",
    branch = "release",
    config = function()
      local keymap = vim.keymap

      -- Use <c-l> to trigger completion
      keymap.set("i", "<c-l>", "coc#refresh()", {silent = true, expr = true})

      -- GoTo code navigation
      keymap.set("n", "gd", "<Plug>(coc-definition)", { silent = true })
      keymap.set("n", "gy", "<Plug>(coc-type-definition)", { silent = true })
      keymap.set("n", "gi", "<Plug>(coc-implementation)", { silent = true })
      keymap.set("n", "gr", "<Plug>(coc-references)", { silent = true })

      -- Use K to show documentation in preview window
      function _G.show_docs()
        local cw = vim.fn.expand('<cword>')
        if vim.fn.index({ 'vim', 'help' }, vim.bo.filetype) >= 0 then
          vim.api.nvim_command('h ' .. cw)
        elseif vim.api.nvim_eval('coc#rpc#ready()') then
          vim.fn.CocActionAsync('doHover')
        else
          vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
        end
      end

      keymap.set("n", "K", '<CMD>lua _G.show_docs()<CR>', { silent = true })

      -- Highlight the symbol and its references on a CursorHold event(cursor is idle)
      vim.api.nvim_create_augroup("CocGroup", {})
      vim.api.nvim_create_autocmd("CursorHold", {
        group = "CocGroup",
        command = "silent call CocActionAsync('highlight')",
        desc = "Highlight symbol under cursor on CursorHold"
      })

      -- Symbol renaming
      keymap.set("n", "<leader>rn", "<Plug>(coc-rename)", { silent = true })

      -- Formatting selected code
      keymap.set("x", "<leader>f", "<Plug>(coc-format-selected)", { silent = true })
      keymap.set("n", "<leader>f", "<Plug>(coc-format-selected)", { silent = true })

      -- Setup formatexpr specified filetype(s)
      vim.api.nvim_create_autocmd("FileType", {
        group = "CocGroup",
        pattern = "typescript,json",
        command = "setl formatexpr=CocAction('formatSelected')",
        desc = "Setup formatexpr specified filetype(s)."
      })

      -- Update signature help on jump placeholder
      vim.api.nvim_create_autocmd("User", {
        group = "CocGroup",
        pattern = "CocJumpPlaceholder",
        command = "call CocActionAsync('showSignatureHelp')",
        desc = "Update signature help on jump placeholder"
      })

      -- Apply codeAction to the selected region
      -- Example: `<leader>aap` for current paragraph
      local opts = { silent = true, nowait = true }
      keymap.set("x", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)
      keymap.set("n", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)

      -- Remap keys for apply code actions at the cursor position.
      keymap.set("n", "<leader>ac", "<Plug>(coc-codeaction-cursor)", opts)

      -- Remap keys for apply source code actions for current file.
      keymap.set("n", "<leader>as", "<Plug>(coc-codeaction-source)", opts)

      -- Apply the most preferred quickfix action on the current line.
      keymap.set("n", "<leader>qf", "<Plug>(coc-fix-current)", opts)

      -- Remap keys for apply refactor code actions.
      keymap.set("n", "<leader>re", "<Plug>(coc-codeaction-refactor)", { silent = true })
      keymap.set("x", "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", { silent = true })
      keymap.set("n", "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", { silent = true })

      -- Run the Code Lens actions on the current line
      keymap.set("n", "<leader>cl", "<Plug>(coc-codelens-action)", opts)

      local opts = { silent = true, nowait = true, expr = true }
      keymap.set("n", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
      keymap.set("n", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)
      keymap.set("i", "<C-f>",
        'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(1)<cr>" : "<Right>"', opts)
      keymap.set("i", "<C-b>",
        'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(0)<cr>" : "<Left>"', opts)
      keymap.set("v", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
      keymap.set("v", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)

      -- Add `:Format` command to format current buffer
      vim.api.nvim_create_user_command("Format", "call CocAction('format')", {})

      -- " Add `:Fold` command to fold current buffer
      vim.api.nvim_create_user_command("Fold", "call CocAction('fold', <f-args>)", { nargs = '?' })

      -- Add `:OR` command for organize imports of the current buffer
      vim.api.nvim_create_user_command("OR", "call CocActionAsync('runCommand', 'editor.action.organizeImport')", {})
    end
  },
  {
    'echasnovski/mini.nvim', version = false,
    config = function()
      require('mini.pairs').setup()
      require('mini.comment').setup()
      require('mini.surround').setup()
      require('mini.trailspace').setup()

      vim.api.nvim_set_hl(0, "MiniTrailspace", { link = "@text.danger" })
    end
  },
  { "koron/vim-budoux" },
  {
    "ippachi/vim-kaigyo", dir = "~/ghq/github.com/ippachi/vim-kaigyo",
    config = function()
      vim.opt.formatexpr = 'kaigyo#formatexpr()'
    end
  },

  -- lazy
  { "tpope/vim-fugitive", cmd = "Git" },
})
