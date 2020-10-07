" =======================================================================================
" vim-default-settings
" =======================================================================================

filetype plugin indent on
syntax enable

set title
set expandtab
set tabstop=4
set shiftwidth=2
set softtabstop=2
set smartindent
set hidden
set history=50
set showcmd
set cmdheight=2
set showmatch
set laststatus=2
set wildmode=longest,list,full
set ignorecase
set smartcase
set incsearch
set wrapscan
set hlsearch
set virtualedit=onemore
set autoindent
set pumheight=10
set updatetime=300
set t_ut=
set iminsert=0
set imsearch=-1
set vb t_vb=
set helplang=ja,en
set splitbelow
set splitright
set timeout ttimeout

set timeout timeoutlen=3000 ttimeoutlen=100
" set clipboard=unnamedplus
set autoread
set list listchars=tab:^\ ,trail:_,extends:>,precedes:<
set backspace=indent,eol,start
set breakindent
set signcolumn=yes
set colorcolumn=100
set completeopt=menuone,noselect,noinsert
set fileencodings=utf-8,cp932,shift-jis,euc-jp
set encoding=utf-8
set shortmess+=c
set nocursorline

set backup
set swapfile
set undofile
set backupdir=~/.cache/vim/backup/
set directory=~/.cache/vim/swap/
set undodir=~/.cache/vim/undo/
set scroll=20
set iskeyword+=-

if has('vim_starting')
  let &t_SI .= "\e[6 q"
  let &t_EI .= "\e[2 q"
  let &t_SR .= "\e[4 q"
endif

colorscheme default

let mapleader = ","

let g:ruby_path = []

set diffopt=internal,filler,algorithm:histogram,indent-heuristic,vertical

set termguicolors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

if executable('rg')
  set grepprg=rg\ --vimgrep\ --smart-case
endif

" =======================================================================================
" mappings and commands
" =======================================================================================

noremap j gj
noremap k gk
nnoremap Y y$
nnoremap <Left> gT
nnoremap <right> gt
nnoremap <silent> <Esc><Esc> :<C-u>nohlsearch<CR>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <C-x> <C-r>=expand('%')<cr>
cnoremap <C-a> **/*
noremap \ ,

augroup vimrc-file-type
  autocmd!
  autocmd BufNewFile,BufRead *.jbuilder,*.jb setlocal filetype=ruby
  autocmd BufNewFile,BufRead *.csv,*.dat  setlocal filetype=csv
  autocmd BufNewFile,BufRead *.es6  setlocal filetype=javascript
augroup END

augroup vimrc-file-indent
  autocmd!
  autocmd FileType gitconfig setlocal noexpandtab softtabstop=4 shiftwidth=4
  autocmd FileType php setlocal expandtab softtabstop=4 shiftwidth=4
  autocmd FileType go setlocal noexpandtab softtabstop=4 shiftwidth=4
augroup END

augroup vimrc-set-regexpengine
  autocmd!
  autocmd BufNewFile,BufReadPre *.rb,*.erb,Schemafile setlocal regexpengine=1
augroup END

augroup vimrc-checktime
  autocmd!
  autocmd WinEnter,FocusGained * checktime
augroup END

augroup vimrc-ruby
  autocmd!
  autocmd FileType ruby setlocal iskeyword+=?
  autocmd FileType ruby setlocal iskeyword+=@-@
  autocmd FileType ruby setlocal regexpengine=1
  autocmd FileType eruby setlocal regexpengine=1
augroup END

augroup vimrc-trim-whitespace
  autocmd!
  autocmd BufWritePre * :%s/\s\+$//ge
augroup END

" =======================================================================================
" plugins
" =======================================================================================

call plug#begin('~/.vim/plugged')
" theme
Plug 'junegunn/seoul256.vim'
Plug 'itchyny/lightline.vim'

" fizzy finder
Plug 'junegunn/fzf.vim'

" git diff
Plug 'airblade/vim-gitgutter'

" test
Plug 'vim-test/vim-test'

" quickrun
Plug 'thinca/vim-quickrun'

" asyncrun
Plug 'tpope/vim-dispatch'

" autoclose
Plug 'kana/vim-smartinput'
Plug 'cohama/lexima.vim'

" snippet
Plug 'sirver/UltiSnips'
Plug 'honza/vim-snippets'

" custom text obj
Plug 'kana/vim-textobj-user'
Plug 'nelstrom/vim-textobj-rubyblock'

" extend match
Plug 'andymass/vim-matchup'

" go test file faster
Plug 'kana/vim-altr'

" surround
Plug 'tpope/vim-surround'
call plug#end()

set background=dark
let g:seoul256_background = 236
colorscheme seoul256

" lightline
let g:lightline = {
  \ 'colorscheme': 'seoul256',
  \ 'active': {
  \   'left': [
  \     [ 'mode', 'paste' ],
  \     [ 'ctrlpmark', 'git', 'diagnostic', 'cocstatus', 'filename', 'method' ]
  \   ],
  \   'right':[
  \     [ 'filetype', 'fileencoding', 'lineinfo', 'percent' ]
  \   ],
  \ }
\ }

" vim-test
let test#strategy = 'dispatch'

let test#ruby#rspec#options = {
  \ 'nearest': '--backtrace',
  \ 'file':    '--format failures --no-profile --deprecation-out /dev/null',
  \ 'suite':   '--tag ~slow',
  \}

nnoremap <leader>tn :<c-u>TestNearest<cr>
nnoremap <leader>tf :<c-u>TestFile<cr>

" vim-dispatch
let g:dispatch_compilers = {'bundle exec': 'rake'}

" fzf
nnoremap <c-p> :<c-u>Files<cr>
nnoremap <leader><c-p> :<c-u>GFiles?<cr>

" " smartinput
call smartinput#clear_rules()

" ultisnip
let g:UltiSnipsExpandTrigger="<c-l>"
let g:UltiSnipsJumpForwardTrigger="<c-l>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"

" lexima
let g:lexima_ctrlh_as_backspace = 1

" vim-altr
call altr#define('app/%/%.rb', 'spec/%/%_spec.rb')

nmap <F2>  <Plug>(altr-forward)
nmap <S-F2>  <Plug>(altr-back)
