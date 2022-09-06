set autoindent
set noswapfile
set backup backupdir=~/.config/nvim/backup/
set cmdheight=2
set colorcolumn=120
set completeopt=menu,menuone,noselect
set cursorline
set expandtab tabstop=2 shiftwidth=2
set foldmethod=marker
set ignorecase smartcase
set number signcolumn=number
set pumblend=15
set pumheight=10
set splitright splitbelow
set termguicolors
set title
set undofile
set formatoptions-=ro
set formatoptions+=mM
set diffopt=internal,filler,algorithm:histogram,indent-heuristic

let mapleader=','

nnoremap j gj
nnoremap k gk
tnoremap <c-o> <c-\><c-n>

nmap <c-e> <c-e><SID>e
nnoremap <script> <SID>ee <c-e><SID>e
nmap <SID>e <Nop>

nmap <c-y> <c-y><SID>y
nnoremap <script> <SID>yy <c-y><SID>y
nmap <SID>y <Nop>

call plug#begin()
Plug 'rebelot/kanagawa.nvim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
Plug 'machakann/vim-sandwich'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'lewis6991/gitsigns.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'vim-test/vim-test'
Plug 'voldikss/vim-floaterm'
Plug 'pwntester/octo.nvim'
Plug 'kosayoda/nvim-lightbulb'
Plug 'ntpeters/vim-better-whitespace'
Plug 'ryicoh/deepl.vim'
Plug 'sindrets/diffview.nvim'
Plug 'lewis6991/satellite.nvim'
Plug 'windwp/nvim-autopairs'
Plug 'RRethy/nvim-treesitter-endwise'
Plug 'lukas-reineke/indent-blankline.nvim'

Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'onsails/lspkind.nvim'

Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-vsnip'
Plug 'tzachar/cmp-tabnine', { 'do': './install.sh' }
Plug 'lukas-reineke/cmp-rg'
Plug 'hrsh7th/vim-vsnip'
call plug#end()

set rtp+=~/ghq/github.com/ippachi/nvim-sticky

" kanagawa.nvim {{{
colorscheme kanagawa
" }}}

" lualine.nvim {{{
lua require("lualine").setup()
" }}}

" nvim-lspconfig {{{
lua << LUA
-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

vim.diagnostic.config({
  float = {
    border = "rounded"
  }
})

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
  vim.lsp.buf.format { async = true }
end

local util = require('lspconfig.util')
local configs = require('lspconfig.configs')
local capabilities = require('cmp_nvim_lsp').update_capabilities(
  vim.lsp.protocol.make_client_capabilities()
)

if not configs["ruby-lsp"] then
  configs["ruby-lsp"] = {
    default_config = {
      cmd = { "ruby-lsp" },
      filetypes = { 'ruby' },
      root_dir = util.root_pattern("Gemfile", ".git"),
      settings = {},
    },
  }
end

for _, server in ipairs({ "vimls", "tsserver", "eslint", "yamlls", "jsonls", "terraformls", "tflint" }) do
  require('lspconfig')[server].setup{
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

require('lspconfig')['sorbet'].setup{
  on_attach = on_attach,
  capabilities = capabilities,
  root_dir = util.root_pattern("sorbet/config"),
  cmd = { "bundle", "exec", "srb", "tc", "--lsp", "--enable-all-beta-lsp-features" }
}
LUA
" }}}

" mason.nvim {{{
lua << LUA
require("mason").setup()
require("mason-lspconfig").setup()
LUA
" }}}

" null-ls.nvim {{{
lua << LUA
require("null-ls").setup({
  sources = {
    require("null-ls").builtins.formatting.prettier,
    -- require("null-ls").builtins.diagnostics.cspell,
  }
})
LUA
" }}}

" nvim-cmp {{{
lua << LUA
local cmp = require'cmp'
local lspkind = require('lspkind')

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-x><C-o>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  matching = {
    disallow_fuzzy_matching = true
  },
  sources = cmp.config.sources({
  },
  {
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    {
      name = 'buffer',
      option = {
        get_bufnrs = function()
          return vim.api.nvim_list_bufs()
        end
      }
    },
    {
      name = 'rg',
      keyword_length = 3
    }
  }, {
    { name = 'path' },
  }),
  experimental = {
    ghost_text = true,
  },
	formatting = {
		format = function(entry, vim_item)
      local source_mapping = {
        buffer = "[Buffer]",
        nvim_lsp = "[LSP]",
        vsnip = "[Snip]",
        cmp_tabnine = "[TN]",
        path = "[Path]",
        rg = "[RG]",
      }

			vim_item.kind = lspkind.presets.default[vim_item.kind]
			local menu = source_mapping[entry.source.name]
			if entry.source.name == 'cmp_tabnine' then
				if entry.completion_item.data ~= nil and entry.completion_item.data.detail ~= nil then
					menu = entry.completion_item.data.detail .. ' ' .. menu
				end
				vim_item.kind = ''
			end
			vim_item.menu = menu
			return vim_item
		end
	},
})

cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})
LUA
" }}}

" vim-vsnip {{{
imap <expr> <C-l> vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<C-l>'
smap <expr> <C-l> vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<C-l>'
imap <expr> <C-j> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<C-j>'
smap <expr> <C-j> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<C-j>'
" }}}

" nvim-treesitter {{{
lua << LUA
require("nvim-treesitter.configs").setup({
  ensure_installed = "all",
  ignore_install = { "phpdoc" },
  highlight = { enable = true },
})
LUA
" }}}

" nvim-tree.lua {{{
lua << LUA
require("nvim-tree").setup()

function open_nvim_tree()
  local previous_buf = vim.api.nvim_get_current_buf()
  require("nvim-tree").open_replacing_current_buffer(vim.fn.getcwd())
  require("nvim-tree").find_file(false, previous_buf)
end

vim.keymap.set("n", "<leader>f", open_nvim_tree, { noremap = true })


require"nvim-tree".setup {
  view = {
    mappings = {
      list = {
        { key = "<CR>", action = "edit_in_place" }
      }
    }
  }
}
LUA
" }}}

" gitsigns.nvim {{{
lua << LUA
require('gitsigns').setup({
  current_line_blame = true,
})
LUA
" }}}

" telescope.nvim {{{
command! LG Telescope live_grep
lua << LUA
require('telescope').setup {
  pickers = {
    oldfiles = {
      mappings = {
        i = {
          ["<C-l>"] = function() require('telescope.builtin').find_files() end
        }
      }
    },
    find_files = {
      mappings = {
        i = {
          ["<C-l>"] = function() require('telescope.builtin').oldfiles({ cwd_only = true }) end
        }
      }
    }
  }
}
vim.keymap.set('n', '<C-p>', require('telescope.builtin').find_files)
LUA
" }}}

" vim-test {{{
let g:test#ruby#minitest#file_pattern = '^test.*_spec\.rb'
let g:test#strategy = {
  \ 'nearest': 'basic',
  \ 'file':    'basic',
  \ 'suite':   'basic',
  \ }
nnoremap <leader>tn <cmd>TestNearest<cr>
nnoremap <leader>tf <cmd>TestFile<cr>
nnoremap <leader>tl <cmd>TestLast<cr>
" }}}

" octo.nvim {{{
lua require"octo".setup()
" }}}

" nvim-lightbulb {{{
lua require('nvim-lightbulb').setup({autocmd = {enabled = true}})
" }}}

" vim-better-whitespace {{{
augroup vimrc-better-whitespace
  autocmd!
  autocmd TermOpen * DisableWhitespace
augroup END
" }}}

" nvim-sticky {{{
lua vim.keymap.set('n', '<F2>', require('sticky').focus_sticky, { noremap = true })
" }}}

" deepl.vim {{{
let g:deepl#endpoint = "https://api-free.deepl.com/v2/translate"
let g:deepl#auth_key = "c03d8e1b-50d0-c9a3-943c-ec29906ae0fd:fx"
vmap t<C-e> <Cmd>call deepl#v("EN")<CR>
vmap t<C-j> <Cmd>call deepl#v("JA")<CR>
" }}}

" satellite.nvim {{{
lua require('satellite').setup()
" }}}

" nvim-autopairs {{{
lua require("nvim-autopairs").setup {}
" }}}

" nvim-treesitter-endwise {{{
lua require('nvim-treesitter.configs').setup { endwise = { enable = true } }
" }}}

" diffview.nvim {{{
lua << LUA
local actions = require("diffview.actions")

require("diffview").setup({
  keymaps = {
    file_panel = {
      ["q"] = function() vim.fn.execute("qa") end
    }
  }
})
LUA
" }}}

" ident-blankline.nvim {{{
lua << LUA
vim.cmd [[highlight IndentBlanklineIndent1 guifg=#E06C75 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent2 guifg=#E5C07B gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent3 guifg=#98C379 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent4 guifg=#56B6C2 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent5 guifg=#61AFEF gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent6 guifg=#C678DD gui=nocombine]]

require("indent_blankline").setup {
    space_char_blankline = " ",
    show_current_context = true,
    show_current_context_start = true
}
LUA
" }}}

