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

vim.cmd [[packadd Cfilter]]

vim.g.mapleader = ","

keymap.set("n", "j", "gj", { noremap = true })
keymap.set("n", "k", "gk", { noremap = true })
keymap.set("t", "<c-o>", "<c-\\><c-n>", { noremap = true })

vim.api.nvim_create_autocmd("QuickFixcmdPost", {
  group = augroup,
  pattern = { "grep", "vimgrep" },
  callback = function() vim.cmd [[cwindow]] end
})

vim.api.nvim_create_autocmd("TermOpen", {
  group = augroup,
  pattern = { "*" },
  callback = function() vim.cmd [[DisableWhitespace]] end
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
    config = function() vim.cmd [[colorscheme kanagawa]] end
  },
  {
    "nvim-lualine/lualine.nvim",
    config = true,
    dependencies = { "kyazdani42/nvim-web-devicons" }
  },
  {
    "ntpeters/vim-better-whitespace",
    init = function()
      vim.api.nvim_create_autocmd("TermOpen", {
        group = augroup,
        pattern = "*",
        callback = function() vim.cmd [[DisableWhitespace]] end
      })
    end
  },
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
    dependencies = {
      "RRethy/nvim-treesitter-endwise",
      "nvim-treesitter/playground",
      "nvim-treesitter/nvim-treesitter-textobjects"
    },
    build = ":TSUpdate",
    config = function()
      require('nvim-treesitter.configs').setup {
        highlight = {
          enable = true,
          disable = { "embedded_template" }
        },
        indent = { enable = true },
        endwise = { enable = true },
        textobjects = {
          select = {
            enable = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
            }
          }
        }
      }
    end
  },
  "lukas-reineke/indent-blankline.nvim",
  {
    "neoclide/coc.nvim",
    branch = "release",
    init = function()
      local keyset = vim.keymap.set
      keyset("i", "<c-j>", "<Plug>(coc-snippets-expand-jump)")

      keyset("i", "<c-l>", "coc#refresh()", { silent = true, expr = true })

      keyset("n", "[g", "<Plug>(coc-diagnostic-prev)", { silent = true })
      keyset("n", "]g", "<Plug>(coc-diagnostic-next)", { silent = true })

      keyset("n", "gd", "<Plug>(coc-definition)", { silent = true })
      keyset("n", "gy", "<Plug>(coc-type-definition)", { silent = true })
      keyset("n", "gi", "<Plug>(coc-implementation)", { silent = true })
      keyset("n", "gr", "<Plug>(coc-references)", { silent = true })

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

      keyset("n", "K", '<CMD>lua _G.show_docs()<CR>', { silent = true })
      -- Highlight the symbol and its references on a CursorHold event(cursor is idle)
      vim.api.nvim_create_augroup("CocGroup", {})
      vim.api.nvim_create_autocmd("CursorHold", {
        group = "CocGroup",
        command = "silent call CocActionAsync('highlight')",
        desc = "Highlight symbol under cursor on CursorHold"
      })

      -- Symbol renaming
      keyset("n", "<leader>rn", "<Plug>(coc-rename)", { silent = true })

      -- Formatting selected code
      keyset("x", "<leader>f", "<Plug>(coc-format-selected)", { silent = true })
      keyset("n", "<leader>f", "<Plug>(coc-format-selected)", { silent = true })

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
      keyset("x", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)
      keyset("n", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)

      -- Remap keys for apply code actions at the cursor position.
      keyset("n", "<leader>ac", "<Plug>(coc-codeaction-cursor)", opts)
      -- Remap keys for apply code actions affect whole buffer.
      keyset("n", "<leader>as", "<Plug>(coc-codeaction-source)", opts)
      -- Remap keys for applying codeActions to the current buffer
      keyset("n", "<leader>ac", "<Plug>(coc-codeaction)", opts)
      -- Apply the most preferred quickfix action on the current line.
      keyset("n", "<leader>qf", "<Plug>(coc-fix-current)", opts)

      -- Remap keys for apply refactor code actions.
      keyset("n", "<leader>re", "<Plug>(coc-codeaction-refactor)", { silent = true })
      keyset("x", "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", { silent = true })
      keyset("n", "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", { silent = true })

      -- Run the Code Lens actions on the current line
      keyset("n", "<leader>cl", "<Plug>(coc-codelens-action)", opts)


      -- Map function and class text objects
      -- NOTE: Requires 'textDocument.documentSymbol' support from the language server
      keyset("x", "if", "<Plug>(coc-funcobj-i)", opts)
      keyset("o", "if", "<Plug>(coc-funcobj-i)", opts)
      keyset("x", "af", "<Plug>(coc-funcobj-a)", opts)
      keyset("o", "af", "<Plug>(coc-funcobj-a)", opts)
      keyset("x", "ic", "<Plug>(coc-classobj-i)", opts)
      keyset("o", "ic", "<Plug>(coc-classobj-i)", opts)
      keyset("x", "ac", "<Plug>(coc-classobj-a)", opts)
      keyset("o", "ac", "<Plug>(coc-classobj-a)", opts)


      -- Remap <C-f> and <C-b> to scroll float windows/popups
      ---@diagnostic disable-next-line: redefined-local
      local opts = { silent = true, nowait = true, expr = true }
      keyset("n", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
      keyset("n", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)
      keyset("i", "<C-f>",
        'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(1)<cr>" : "<Right>"', opts)
      keyset("i", "<C-b>",
        'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(0)<cr>" : "<Left>"', opts)
      keyset("v", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
      keyset("v", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)

      -- Use CTRL-S for selections ranges
      -- Requires 'textDocument/selectionRange' support of language server
      keyset("n", "<C-s>", "<Plug>(coc-range-select)", { silent = true })
      keyset("x", "<C-s>", "<Plug>(coc-range-select)", { silent = true })

      vim.api.nvim_create_user_command("Format", "call CocAction('format')", {})
      vim.api.nvim_create_user_command("Fold", "call CocAction('fold', <f-args>)", { nargs = '?' })
      vim.api.nvim_create_user_command("OR", "call CocActionAsync('runCommand', 'editor.action.organizeImport')", {})
    end
  },
  { "itchyny/vim-qfedit" },
  {
    "xiyaowong/transparent.nvim",
    config = true
  },
  {
    "stevearc/oil.nvim",
    config = true,
  },

  -- lazy
  { "machakann/vim-sandwich", keys = { "sr", "sd" } },
  { "windwp/nvim-autopairs",  event = "InsertEnter", config = true },
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim", "nvim-telescope/telescope-ghq.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      { "danielfalk/smart-open.nvim", branch = "0.2.x", dependencies = { "kkharji/sqlite.lua" } }
    },
    init = function()
      vim.keymap.set("n", "<c-p>", "<cmd>Telescope find_files<cr>")
      vim.keymap.set("n", "<space>r", "<cmd>Telescope resume<cr>")
      vim.api.nvim_create_user_command("Grep", "Telescope live_grep", { force = true })
    end,
    config = function()
      require('telescope').setup {
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
          smart_open = {
            match_algorithm = "fzf"
          }
        }
      }
      require('telescope').load_extension('fzf')
      require('telescope').load_extension('ghq')
      require('telescope').load_extension('smart_open')
    end,
    cmd = { "Telescope" },
  },
  {
    -- "sindrets/diffview.nvim",
    "3699394/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    init = function()
      keymap.set("n", "<leader>g", function()
        vim.cmd([[
        CocDisable
        DiffviewOpen
        ]])
      end, { noremap = true })
    end,
    config = function()
      require("diffview").setup({
        hooks = {
          view_closed = function() vim.cmd [[CocEnable]] end
        }
      })
    end,
    cmd = "DiffviewOpen"
  },
  { "tpope/vim-fugitive", cmd = "Git" },
  {
    "akinsho/git-conflict.nvim",
    cmd = "GitConflictListQf",
    config = true
  },
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode"
  }
})
