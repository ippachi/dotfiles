function! ruby_lsp_autostart#start_lsp_client() abort
lua << EOF
local util = require 'lspconfig/util'

local function lsp_configs(server, config)
  local configs = {
    solragraph = {
      cmd = { "solargraph", "stdio" }
    },
    sorbet = {
      cmd = { "bundle", "exec", "srb", "tc", "--lsp", "--enable-all-experimental-lsp-features" },
      root_dir = util.root_pattern("sorbet/config")
    }
  }
  return vim.tbl_deep_extend('force', config, configs[server] or {})
end

local function is_started_lsp_client(name)
  for _, client in ipairs(vim.lsp.get_active_clients()) do
    if client.name == name then
      return true
    end
  end

  return false
end

local function start_lsp_client(name, config_override)
  if not is_started_lsp_client(name) then
    local config = M.make_config()
    config = vim.tbl_deep_extend('force', config, config_override or {})
    require'lspconfig'[name].setup(lsp_configs(name, config))
    vim.cmd('e')
    print("Start " .. name .. " LSP client")
  end
end

if vim.fn.findfile('config', 'sorbet;') == 'sorbet/config' then
  start_lsp_client('sorbet')

  local solargraph_config = {
    init_options = {
      completion = false,
      definitions = false,
      hover = false,
      references = false,
      rename = false,
      symbols = false
    }
  }
  start_lsp_client('solargraph', solargraph_config)
else
  start_lsp_client('solargraph')
end
EOF
endfunction
