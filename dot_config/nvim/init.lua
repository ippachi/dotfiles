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
vim.opt.completeopt = { "menu", "menuone", "noselect" }

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
    "sainnhe/gruvbox-material",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme gruvbox-material]])
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
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
    },
    build = ":TSUpdate",
    event = "BufReadPre",
    config = function()
      require("nvim-treesitter.configs").setup({
        highlight = {
          enable = true,
          disable = { "embedded_template" },
        },
        endwise = { enable = true },
      })
    end,
  },
  { "itchyny/vim-qfedit", event = "QuickFixCmdPost" },
  {
    "echasnovski/mini.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    version = false,
    config = function()
      require("mini.pairs").setup()
      require("mini.comment").setup()
      require("mini.surround").setup()
      require("mini.trailspace").setup()
      require("mini.statusline").setup()
      require("mini.files").setup()
      require("mini.ai").setup()
      require("mini.hipatterns").setup()
      require("mini.indentscope").setup()
      require("mini.extra").setup()
      require("mini.pick").setup({
        mappings = {
          choose_marked = "<C-q>",
        },
      })

      vim.keymap.set("n", "<c-p>", function()
        MiniPick.builtin.files()
      end, { noremap = true })
      vim.keymap.set("n", "<c-h>", function()
        MiniPick.builtin.help()
      end, { noremap = true })
      vim.keymap.set("n", "<space>f", function()
        MiniFiles.open(vim.api.nvim_buf_get_name(0))
      end, { noremap = true })
      vim.api.nvim_create_user_command("Buffers", function()
        MiniPick.builtin.buffers()
      end, {})
      vim.api.nvim_create_user_command("Grep", function()
        MiniPick.builtin.grep_live()
      end, {})
      vim.api.nvim_create_user_command("Registers", function()
        MiniExtra.pickers.registers()
      end, {})
    end,
  },
  { "tpope/vim-fugitive", cmd = "Git" },
  {
    "sindrets/diffview.nvim",
    cmd = "DiffviewOpen",
    init = function()
      vim.api.nvim_create_user_command("DO", "DiffviewOpen", {})
    end,
    opts = {
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
          {
            "n",
            "c<space>",
            ":Git commit ",
            { desc = 'Populate command line with ":Git commit "' },
          },
        },
      },
      hooks = {
        view_opened = function() vim.cmd([[CocDisable]]) end,
        view_closed = function()
          vim.cmd([[
            CocEnable
            CocRestart
          ]])
        end
      }
    },
  },
  {
    "neoclide/coc.nvim",
    branch = "release",
    config = function()
      vim.keymap.set("i", "<c-l>", "coc#refresh()", { silent = true, expr = true })

      -- Use `[g` and `]g` to navigate diagnostics
      -- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
      vim.keymap.set("n", "[g", "<Plug>(coc-diagnostic-prev)", { silent = true })
      vim.keymap.set("n", "]g", "<Plug>(coc-diagnostic-next)", { silent = true })

      -- GoTo code navigation
      vim.keymap.set("n", "gd", "<Plug>(coc-definition)", { silent = true })
      vim.keymap.set("n", "gy", "<Plug>(coc-type-definition)", { silent = true })
      vim.keymap.set("n", "gi", "<Plug>(coc-implementation)", { silent = true })
      vim.keymap.set("n", "gr", "<Plug>(coc-references)", { silent = true })

      -- Use K to show documentation in preview window
      function _G.show_docs()
        local cw = vim.fn.expand("<cword>")
        if vim.fn.index({ "vim", "help" }, vim.bo.filetype) >= 0 then
          vim.api.nvim_command("h " .. cw)
        elseif vim.api.nvim_eval("coc#rpc#ready()") then
          vim.fn.CocActionAsync("doHover")
        else
          vim.api.nvim_command("!" .. vim.o.keywordprg .. " " .. cw)
        end
      end

      vim.keymap.set("n", "K", "<CMD>lua _G.show_docs()<CR>", { silent = true })

      -- Highlight the symbol and its references on a CursorHold event(cursor is idle)
      vim.api.nvim_create_augroup("CocGroup", {})
      vim.api.nvim_create_autocmd("CursorHold", {
        group = "CocGroup",
        command = "silent call CocActionAsync('highlight')",
        desc = "Highlight symbol under cursor on CursorHold",
      })

      -- Symbol renaming
      vim.keymap.set("n", "<leader>rn", "<Plug>(coc-rename)", { silent = true })

      -- Formatting selected code
      vim.keymap.set("x", "<leader>f", "<Plug>(coc-format-selected)", { silent = true })
      vim.keymap.set("n", "<leader>f", "<Plug>(coc-format-selected)", { silent = true })

      -- Update signature help on jump placeholder
      vim.api.nvim_create_autocmd("User", {
        group = "CocGroup",
        pattern = "CocJumpPlaceholder",
        command = "call CocActionAsync('showSignatureHelp')",
        desc = "Update signature help on jump placeholder",
      })

      -- Apply codeAction to the selected region
      -- Example: `<leader>aap` for current paragraph
      local opts = { silent = true, nowait = true }
      vim.keymap.set("x", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)
      vim.keymap.set("n", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)

      -- Remap keys for apply code actions at the cursor position.
      vim.keymap.set("n", "<leader>ac", "<Plug>(coc-codeaction-cursor)", opts)
      -- Remap keys for apply source code actions for current file.
      vim.keymap.set("n", "<leader>as", "<Plug>(coc-codeaction-source)", opts)
      -- Apply the most preferred quickfix action on the current line.
      vim.keymap.set("n", "<leader>qf", "<Plug>(coc-fix-current)", opts)

      -- Remap keys for apply refactor code actions.
      vim.keymap.set("n", "<leader>re", "<Plug>(coc-codeaction-refactor)", { silent = true })
      vim.keymap.set("x", "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", { silent = true })
      vim.keymap.set("n", "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", { silent = true })

      -- Run the Code Lens actions on the current line
      vim.keymap.set("n", "<leader>cl", "<Plug>(coc-codelens-action)", opts)

      -- Remap <C-f> and <C-b> to scroll float windows/popups
      ---@diagnostic disable-next-line: redefined-local
      local opts = { silent = true, nowait = true, expr = true }
      vim.keymap.set("n", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
      vim.keymap.set("n", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)
      vim.keymap.set("i", "<C-f>", 'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(1)<cr>" : "<Right>"', opts)
      vim.keymap.set("i", "<C-b>", 'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(0)<cr>" : "<Left>"', opts)
      vim.keymap.set("v", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
      vim.keymap.set("v", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)

      -- Add `:Format` command to format current buffer
      vim.api.nvim_create_user_command("Format", "call CocAction('format')", {})

      -- Add `:OR` command for organize imports of the current buffer
      vim.api.nvim_create_user_command(
        "OR",
        "call CocActionAsync('runCommand', 'editor.action.organizeImport')",
        {}
      )
    end,
  },
})
