call plug#begin('~/.vim/plugged')
  Plug 'kristijanhusak/vim-hybrid-material'
  Plug 'vim-airline/vim-airline'
  Plug 'Yggdroot/indentLine'
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'
  if has('nvim')
    " Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  else
    " Plug 'Shougo/deoplete.nvim'
    " Plug 'roxma/nvim-yarp'
    " Plug 'roxma/vim-hug-neovim-rpc'
  endif
  Plug 'Shougo/denite.nvim'
  Plug 'tpope/vim-surround'
  Plug 'airblade/vim-gitgutter'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-repeat'


  Plug 'w0rp/ale'
  Plug 'vim-airline/vim-airline-themes'

  Plug 'prabirshrestha/asyncomplete.vim'
  Plug 'prabirshrestha/vim-lsp'
  Plug 'prabirshrestha/async.vim'
  Plug 'prabirshrestha/asyncomplete-lsp.vim'
  Plug 'terryma/vim-multiple-cursors'

  Plug 'SirVer/ultisnips'
  Plug 'honza/vim-snippets'

  Plug 'posva/vim-vue'
  Plug 'andymass/vim-matchup'

  Plug 'mattn/emmet-vim'
call plug#end()

let g:loaded_matchit = 1
augroup matchup_matchparen_highlight
  autocmd!
  autocmd ColorScheme * hi MatchWord guifg=lightblue cterm=italic gui=italic
augroup end

let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

let g:deoplete#enable_at_startup = 1

set background=dark
colorscheme hybrid_material
set termguicolors
let g:enable_italic_font = 1

let g:airline_powerline_fonts = 1
let g:airline_theme = 'hybrid'

let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 0


if executable('solargraph')
    " gem install solargraph
    au User lsp_setup call lsp#register_server({
        \ 'name': 'solargraph',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'solargraph stdio']},
        \ 'initialization_options': {"diagnostics": "true"},
        \ 'whitelist': ['ruby'],
        \ })
endif

if executable('pyls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls']},
        \ 'whitelist': ['python'],
        \ })
endif

if executable('clangd-6.0')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'clangd',
        \ 'cmd': {server_info->['clangd-6.0']},
        \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
        \ })
endif

let g:lsp_signs_enabled = 1         " enable signs
let g:lsp_diagnostics_echo_cursor = 1 " enable echo under cursor when in normal mode
let g:asyncomplete_smart_completion = 1

nnoremap <space><space> :Files<cr>
nnoremap - :Rg <c-r>=expand("<cword>")<cr><cr>
nnoremap <space>/ :Rg

nnoremap j gj
nnoremap k gk


filetype plugin indent on
syntax enable

set number
set title
" set ambiwidth=double
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set smartindent
set hidden
set history=50
set wildmenu
set noswapfile
set nobackup
set showcmd
set showmatch
set laststatus=2
set wildmode=list:longest
set ignorecase
set smartcase
set incsearch
set wrapscan
set hlsearch
set virtualedit=onemore
set autoindent
set pumheight=10
set updatetime=500
set t_ut=
set iminsert=0
set imsearch=-1
set vb t_vb=
autocmd InsertEnter,InsertLeave * set cul!

if has('vim_starting')
    let &t_SI .= "\e[6 q"
    let &t_EI .= "\e[2 q"
    let &t_SR .= "\e[4 q"
endif

autocmd BufWritePre * %s/\s\+$//e
