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
vim.opt.completeopt = { "menu", "menuone", "noselect", "popup", "fuzzy" }
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

vim.lsp.config('*', {
  root_markers = { '.git' },
})

vim.lsp.config("ruby-lsp", {
  root_markers = { 'Gemfile' },
  cmd = { "ruby-lsp" },
  filetypes = { "ruby" },
  init_options = {
    addonSettings = {
      ["Ruby LSP Rails"] = {
        enablePendingMigrationsPrompt = false,
      },
    },
  },
})

vim.lsp.config("ts-ls", {
  root_markers = { 'package.json' },
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
})

vim.lsp.config("lua-ls", {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT"
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME
        }
      }
    }
  },
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if path ~= vim.fn.stdpath('config') and (vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc')) then
        return
      end
    end
  end
})

vim.lsp.enable({ "ruby-lsp", "ts-ls", "lua-ls" })

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end)
    vim.keymap.set("n", "<leader>e", function() vim.diagnostic.open_float() end)
    vim.api.nvim_buf_create_user_command(args.buf, "Format",
      function() vim.lsp.buf.format({ async = true }) end, {})

    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    if client:supports_method("textDocument/completion") then
      vim.bo.completefunc = "v:lua.MiniCompletion.completefunc_lsp"
    end

    vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
      buffer = args.buf,
      callback = function()
        vim.lsp.codelens.refresh({ bufnr = args.buf })
      end
    })
  end,
})

vim.diagnostic.config({
  virtual_text = { current_line = true }
})

require("config.lazy")
