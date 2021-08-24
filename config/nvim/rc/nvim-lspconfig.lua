require("null-ls").config({
    -- you must define at least one source for the plugin to work
    sources = {
      require("null-ls").builtins.formatting.eslint,
      require("null-ls").builtins.diagnostics.eslint,
      require("null-ls").builtins.code_actions.eslint,
    }
})

local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'solargraph' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end

local function lsp_settings(key)
  local settings = {}
  return settings[key] or {}
end

local function setup_servers()
  require'lspinstall'.setup()
  local servers = require'lspinstall'.installed_servers()
  for _, server in pairs(servers) do
    local config = { on_attach = on_attach }
    for k,v in pairs(lsp_settings(server)) do config[k] = v end
    nvim_lsp[server].setup{
      on_attach = on_attach
    }
  end
end

setup_servers()

-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
require'lspinstall'.post_install_hook = function ()
  setup_servers() -- reload installed servers
  vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end

nvim_lsp["null-ls"].setup{
  on_attach = on_attach,
  root_dir = vim.loop.cwd
}


local util = require 'lspconfig/util'

nvim_lsp.sorbet.setup{
  cmd = { "bundle", "exec", "srb", "tc", "--lsp", "--enable-all-experimental-lsp-features" },
  root_dir = util.root_pattern("sorbet/config")
}
--
-- nvim_lsp.diagnosticls.setup{
--   on_attach = on_attach,
--   filetypes = { 'typescriptreact' },
--   init_options = {
--     filetypes = {
--       typescriptreact = 'eslint'
--     },
--     linters = {
--       eslint = {
--         command = './node_modules/.bin/eslint',
--         rootPatterns = {
--           '.eslintrc.js',
--           '.eslintrc.json'
--         },
--         debounce = 100,
--         args = {
--           '--stdin',
--           '--stdin-filename',
--           '%filepath',
--           '--format',
--           'json'
--         },
--         sourceName = 'eslint',
--         parseJson = {
--           errorsRoot = '[0].messages',
--           line = 'line',
--           column = 'column',
--           endLine = 'endLine',
--           endColumn = 'endColumn',
--           message = '${message} [${ruleId}]',
--           security = 'severity'
--         },
--         securities = {
--           ['2'] = 'error',
--           ['1'] = 'warning'
--         }
--       }
--     },
--     formatFiletypes = {
--       typescriptreact = 'prettier'
--     },
--     formatters = {
--       prettier =  {
--         command =  "./node_modules/.bin/prettier",
--         args =  {"--stdin-filepath", "%filepath"},
--         rootPatterns =  {
--           ".prettierrc",
--           ".prettierrc.json",
--           ".prettierrc.toml",
--           ".prettierrc.json",
--           ".prettierrc.yml",
--           ".prettierrc.yaml",
--           ".prettierrc.json5",
--           ".prettierrc.js",
--           ".prettierrc.cjs",
--           "prettier.config.js",
--           "prettier.config.cjs",
--           ".eslintrc.js",
--           ".eslintrc.json"
--         }
--       }
--     }
--   }
-- }
