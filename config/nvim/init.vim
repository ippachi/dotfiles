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
set updatetime=300
set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
set grepformat=%f:%l:%c:%m
set fileencodings=iso-2022-jp,euc-jp,sjis,utf-8

let mapleader=','

nnoremap j gj
nnoremap k gk
tnoremap <c-o> <c-\><c-n>

augroup quickfix
  autocmd!
  autocmd QuickFixCmdPost * copen
augroup END

call plug#begin()
Plug 'rebelot/kanagawa.nvim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
Plug 'machakann/vim-sandwich'
Plug 'lewis6991/gitsigns.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'vim-test/vim-test'
Plug 'pwntester/octo.nvim'
Plug 'kosayoda/nvim-lightbulb'
Plug 'ntpeters/vim-better-whitespace'
Plug 'ryicoh/deepl.vim'
Plug 'sindrets/diffview.nvim'
Plug 'windwp/nvim-autopairs'
Plug 'RRethy/nvim-treesitter-endwise'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'lambdalisue/fern.vim'
Plug 'kevinhwang91/nvim-hlslens'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }

Plug 'vim-denops/denops.vim'
Plug 'vim-denops/denops-shared-server.vim'

Plug 'Shougo/ddc.vim'
Plug 'Shougo/ddc-ui-native'
Plug 'Shougo/ddc-ui-pum'
Plug 'Shougo/ddc-around'
Plug 'Shougo/ddc-matcher_head'
Plug 'Shougo/ddc-sorter_rank'
Plug 'Shougo/ddc-nvim-lsp'
Plug 'Shougo/ddc-rg'
Plug 'ippachi/ddc-yank'
Plug 'matsui54/denops-signature_help'
Plug 'matsui54/denops-popup-preview.vim'

Plug 'Shougo/ddu.vim'
Plug 'Shougo/ddu-ui-ff'
Plug 'Shougo/ddu-kind-file'
Plug 'Shougo/ddu-filter-matcher_substring'
Plug 'Shougo/ddu-source-file'
Plug 'Shougo/ddu-commands.vim'
Plug 'Shougo/ddu-source-file_rec'
Plug 'matsui54/ddu-source-file_external'
Plug 'shun/ddu-source-rg'
Plug 'Shougo/pum.vim'

Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'

Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'glepnir/lspsaga.nvim', { 'branch': 'main' }
call plug#end()

set rtp+=~/ghq/github.com/ippachi/nvim-sticky

" kanagawa.nvim {{{
colorscheme kanagawa
" }}}

" lualine.nvim {{{
lua require("lualine").setup()
" }}}

" nvim-treesitter {{{
lua << LUA
require("nvim-treesitter.configs").setup({
  ensure_installed = "all",
  highlight = {
    enable = true,
    disable = { "vim" }
  },
})
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
let g:deepl#auth_key = $DEEPL_AUTH_KEY
vmap t<C-e> <Cmd>call deepl#v("EN")<CR>
vmap t<C-j> <Cmd>call deepl#v("JA")<CR>
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

" fern.vim {{{
nnoremap <space>f <Cmd>Fern . -reveal=%<cr>
" }}}

" gitsigns.nvim {{{
lua << LUA
require('gitsigns').setup{
  current_line_blame = true,
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Actions
    map({'n', 'v'}, '<leader>hs', ':Gitsigns stage_hunk<CR>')
    map({'n', 'v'}, '<leader>hr', ':Gitsigns reset_hunk<CR>')
    map('n', '<leader>hS', gs.stage_buffer)
    map('n', '<leader>hu', gs.undo_stage_hunk)
    map('n', '<leader>hR', gs.reset_buffer)
    map('n', '<leader>hp', gs.preview_hunk)
    map('n', '<leader>hb', function() gs.blame_line{full=true} end)
    map('n', '<leader>tb', gs.toggle_current_line_blame)
    map('n', '<leader>hd', gs.diffthis)
    map('n', '<leader>hD', function() gs.diffthis('~') end)
    map('n', '<leader>td', gs.toggle_deleted)

    -- Text object
    map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end
}
LUA
" }}}

" nvim-hlslens {{{
lua require("hlslens").setup{}
" }}}

" denops.vim {{{
" let g:denops_server_addr = '127.0.0.1:32123'
" }}}

" ddc.vim {{{
call ddc#custom#patch_global('ui', 'pum')
call ddc#custom#patch_global('sources', ['nvim-lsp', 'around', 'rg'])
call ddc#custom#patch_global('sourceOptions', {
      \ '_': {
      \   'matchers': ['matcher_head'],
      \   'sorters': ['sorter_rank']},
      \ })
call ddc#custom#patch_global('sourceOptions', {
      \ 'around': {'mark': 'A'},
      \ 'nvim-lsp': {'mark': 'lsp'},
      \ 'rg': {'mark': 'rg', 'minAutoCompleteLength': 4,},
      \ })
call ddc#enable()
" }}}

" denops-signature_help {{{
call signature_help#enable()
" }}}

" denops-popup-preview.vim {{{
call popup_preview#enable()
" }}}

" vim-vsnip {{{
imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
" }}}

" ddu.vim {{{
call ddu#custom#patch_global({
    \ 'ui': 'ff',
    \ })
call ddu#custom#patch_global({
    \   'kindOptions': {
    \     'file': {
    \       'defaultAction': 'open',
    \     },
    \   }
    \ })
call ddu#custom#patch_global({
    \   'uiParams': {
    \     'ff': {
    \       'startFilter': v:true,
    \     },
    \   }
    \ })
call ddu#custom#patch_global({
    \   'sourceOptions': {
    \     '_': {
    \       'matchers': ['matcher_substring'],
    \     },
    \   }
    \ })

call ddu#custom#alias('source', 'file_rg', 'file_external')
call ddu#custom#patch_global({
    \   'sourceParams': {
    \     'file_rg': {
    \       'cmd': ['rg', '--files', '--glob', '!.git',
    \               '--color', 'never', '--no-messages'],
    \       'updateItems': 50000,
    \     },
    \   }
    \ })
call ddu#custom#patch_global({
    \   'sourceParams' : {
    \     'rg' : {
    \       'args': ['--column', '--no-heading', '--color', 'never'],
    \     },
    \   },
    \ })

autocmd FileType ddu-ff call s:ddu_ff_my_settings()
function! s:ddu_ff_my_settings() abort
  nnoremap <buffer> <CR> <Cmd>call ddu#ui#ff#do_action('itemAction')<CR>
  nnoremap <buffer> i <Cmd>call ddu#ui#ff#do_action('openFilterWindow')<CR>
  nnoremap <buffer> <C-q> <Cmd>call ddu#ui#ff#do_action('itemAction', { 'name': 'quickfix' })<CR>
  nnoremap <buffer> <Tab> <Cmd>call ddu#ui#ff#do_action('toggleSelectItem')<CR>
  nnoremap <buffer> q <Cmd>call ddu#ui#ff#do_action('quit')<CR>
endfunction

autocmd FileType ddu-ff-filter call s:ddu_ff_filter_my_settings()
function! s:ddu_ff_filter_my_settings() abort
  nnoremap <buffer> q <Cmd>call ddu#ui#ff#close()<CR>
  inoremap <buffer> <cr> <esc><Cmd>call ddu#ui#ff#close()<CR>
endfunction

command! DduRgLive call <SID>ddu_rg_live()
function! s:ddu_rg_live() abort
  call ddu#start({
        \   'volatile': v:true,
        \   'sources': [{
        \     'name': 'rg',
        \     'options': {'matchers': []},
        \   }],
        \   'uiParams': {'ff': {
        \     'ignoreEmpty': v:false,
        \     'autoResize': v:false,
        \   }},
        \ })
endfunction

nnoremap <c-p> <Cmd>Ddu file_rg<cr>
" }}}

" nvim-lspconfig {{{
lua << LUA
require("mason").setup()
require("mason-lspconfig").setup()

local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end

local util = require 'lspconfig.util'
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

require('lspconfig')['sorbet'].setup{
  cmd = { "bundle", "exec", "srb", "tc", "--lsp", "--enable-all-experimental-lsp-features" },
  root_dir = util.root_pattern("sorbet/config"),
  on_attach = on_attach,
  capabilities = capabilities,
}
require('lspconfig')['terraformls'].setup{
  on_attach = on_attach,
  capabilities = capabilities,
}
require('lspconfig')['tsserver'].setup{
  on_attach = on_attach,
  capabilities = capabilities,
}
LUA
" }}}

" lspsaga.nvim {{{
lua << LUA
local keymap = vim.keymap.set
local saga = require('lspsaga')

keymap({"n","v"}, "<leader>ca", "<cmd>Lspsaga code_action<CR>", { silent = true })
keymap("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", { silent = true })
keymap("n", "gd", "<cmd>Lspsaga peek_definition<CR>", { silent = true })
keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>", { silent = true })
LUA
" }}}

" pum.vim {{{
inoremap <C-n>   <Cmd>call pum#map#insert_relative(+1)<CR>
inoremap <C-p>   <Cmd>call pum#map#insert_relative(-1)<CR>
inoremap <C-y>   <Cmd>call pum#map#confirm()<CR>
inoremap <C-e>   <Cmd>call pum#map#cancel()<CR>
inoremap <PageDown> <Cmd>call pum#map#insert_relative_page(+1)<CR>
inoremap <PageUp>   <Cmd>call pum#map#insert_relative_page(-1)<CR>

call pum#set_option({
      \ 'highlight_matches': '@string'
      \ })
" }}}
