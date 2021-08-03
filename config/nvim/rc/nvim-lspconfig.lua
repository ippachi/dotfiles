lsp = require'lspconfig'
util = require'lspconfig/util'

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
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
  buf_set_keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  require'lsp_signature'.on_attach({
    bind = true,
    fix_post = true
  })
end

lsp.solargraph.setup{
  cmd = { "bundle", "exec", "solargraph", "stdio" },
  root_dir = util.root_pattern(".solargraph.yml"),
  settings = {
    solargraph = {
      diagnostics = true,
      useBundler = true,
      bundlerPath = "~/.asdf/shims/bundler"
    }
  },
  on_attach = on_attach,
}

lsp.sorbet.setup{
  cmd = { "bundle", "exec", "srb", "tc", "--lsp" },
  root_dir = util.root_pattern("sorbet/config"),
  on_attach = on_attach,
}

lsp.vimls.setup{
  on_attach = on_attach,
}

local sumneko_root_path = "/Users/ippachi/ghq/github.com/sumneko/lua-language-server"
local runtime_path = vim.split(package.path, ';')

lsp.sumneko_lua.setup {
  cmd = {sumneko_root_path .. "/bin/macOS/lua-language-server", "-E", sumneko_root_path .. "/main.lua"};
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = runtime_path,
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
  on_attach = on_attach
}

require'lspconfig'.tsserver.setup{
  on_attach = on_attach
}

require'lspconfig'.pylsp.setup{
  on_attach = on_attach
}
require'lspconfig'.diagnosticls.setup{
  on_attach = on_attach,
  filetypes = { 'ruby', 'typescriptreact', 'typescript' },
  init_options = {
    filetypes = {
      ruby = "rubocop",
      typescript = "eslint",
      typescriptreact = "eslint"
    },
    linters = {
      rubocop = {
        command = "bundle",
        sourceName = "rubocop",
        debounce = 100,
        args = {
          "exec",
          "rubocop",
          "--format",
          "json",
          "--force-exclusion",
          "--stdin",
          "%filepath"
        },
        parseJson = {
          errorsRoot = "files[0].offenses",
          line = "location.start_line",
          endLine = "location.last_line",
          column = "location.start_column",
          endColumn = "location.end_column",
          message = "[${cop_name}] ${message}",
          security = "severity"
        },
        securities = {
          fatal = "error",
          error = "error",
          warning = "warning",
          convention = "info",
          refactor = "info",
          info = "info"
        }
      },
      eslint ={
        command ="./node_modules/.bin/eslint",
        rootPatterns = {
          "package.json"
        },
        debounce =100,
        args ={
          "--stdin",
          "--stdin-filename",
          "%filepath",
          "--format",
          "json"
        },
        sourceName ="eslint",
        parseJson = {
          errorsRoot ="[0].messages",
          line ="line",
          column ="column",
          endLine ="endLine",
          endColumn ="endColumn",
          message ="${message} [${ruleId}]",
          security ="severity"
        },
        securities ={
          ["2"] ="error",
          ["1"] ="warning"
        }
      }
    },
    formatFiletypes = {
      ruby = "rubocop"
    },
    formatters = {
      rubocop = {
        command = "bundle",
        args = {
          "exec",
          "rubocop",
          "--force-exclusion",
          "-A",
          "%filepath",
        },
        isStdout = false,
        isStderr = false,
        doesWriteToFile = true
      },
      prettier_eslint = {
        command = "./node_modules/.bin/prettier-eslint",
        args = {"--stdin"},
        rootPatterns = {"package.json"}
      }
    }
  }
}
