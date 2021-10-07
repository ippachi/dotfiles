" Options {{{
set expandtab
set autoindent
set smartindent
set shiftwidth=2
set tabstop=2
set hidden
set laststatus=2
set ignorecase
set smartcase
set incsearch
set hlsearch
set backspace=indent,eol,start

set autoread
set ttimeout
set signcolumn=yes

set fileencodings=utf-8,cp932,shift-jis,euc-jp
set encoding=utf-8
set undofile
set swapfile
set backupdir=~/.local/share/nvim/backup
set backup
set scrolloff=0
set termguicolors
set splitbelow
set splitright
set dictionary=/usr/share/dict/words
set completeopt=menuone
set updatetime=300
set background=dark
set cursorline
set cmdheight=2
set colorcolumn=120
set diffopt& diffopt+=vertical,algorithm:histogram
set wildmode=longest:full
set pumheight=10

if executable('rg')
  set grepprg=rg\ --vimgrep\ --smart-case\ --pcre2
  set grepformat=%f:%l:%c:%m,%f:%l:%m
end

let mapleader=','

packadd Cfilter
" }}}

" Base mappings {{{
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k
nnoremap Y y$
nnoremap \ ,
nnoremap <esc><esc> <cmd>nohl \| ccl<cr>
cnoremap <c-x> <C-r>=expand('%')<cr>
cnoremap cn<cr> cope \| cn<cr>
cnoremap cp<cr> cope \| cp<cr>
" }}}

" Base augroup {{{
augroup vimrc-trim-whitespace
  autocmd!
  autocmd BufWritePre * :%s/\s\+$//ge
augroup END

augroup vimrc-zennkaku
  autocmd!
  autocmd ColorScheme * highlight ZenkakuSpace ctermfg=12 ctermbg=12
  autocmd VimEnter * match ZenkakuSpace /　/
augroup END

augroup vimrc-quickfix
  autocmd!
  autocmd QuickFixCmdPost vimgrep,grep copen
augroup END

augroup vimrc-vim-marker
  autocmd!
  autocmd BufEnter .vimrc,init.vim setl foldmethod=marker
augroup END
" }}}

"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=/Users/ippachi/.cache/dein/repos/github.com/Shougo/dein.vim

let s:dein_path = '/Users/ippachi/.cache/dein'
let s:dein_toml = '~/.config/nvim/dein.toml'
let s:dein_lazy_toml = '~/.config/nvim/dein_lazy.toml'

if dein#load_state(s:dein_path)
  call dein#begin(s:dein_path, [$MYVIMRC, s:dein_toml, s:dein_lazy_toml])
  call dein#add('/Users/ippachi/.cache/dein/repos/github.com/Shougo/dein.vim')
  call dein#load_toml(s:dein_toml, {'lazy': 0})
  call dein#load_toml(s:dein_lazy_toml, {'lazy': 1})
  call dein#end()
  call dein#save_state()
endif

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif

" set rtp+=~/.cache/dein/repos/github.com/hrsh7th/vim-vsnip
" set rtp+=~/ghq/github.com/ippachi/vim-vsnip-integ/
set rtp+=~/ghq/github.com/ippachi/ddc-yank

syntax enable
filetype plugin indent on

"End dein Scripts-------------------------

colorscheme gruvbox-material
