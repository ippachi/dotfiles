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
set number
set signcolumn=number
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

nnoremap <silent> ]t :tnext<cr>
nnoremap <silent> [t :tprev<cr>
nnoremap <silent> ]q :cnext<cr>
nnoremap <silent> [q :cprev<cr>

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
Plug 'ctrlpvim/ctrlp.vim'

" git diff
Plug 'airblade/vim-gitgutter'

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

" asyncrun
Plug 'skywind3000/asyncrun.vim'
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

" asyncrun
nnoremap <leader>tn :<c-u>AsyncRun RUBYOPT='-W:no-deprecated -W:no-experimental' bundle exec rspec %:p:<c-r>=line('.')<cr><cr>
nnoremap <leader>tf :<c-u>AsyncRun RUBYOPT='-W:no-deprecated -W:no-experimental' bundle exec rspec %:p --format failures<cr>
nnoremap <leader>tl :<c-u>AsyncRun bundle exec rubocop --format emacs<cr>

hi TestRed term=reverse ctermfg=252 ctermbg=52 guifg=#D9D9D9 guibg=#730B00
hi TestGreen term=bold ctermbg=22 guibg=#006F00

let s:on_asyncrun_exit =<< trim END
  call popup_close(get(g:, 'test_bar_popup'), 0)
  if g:asyncrun_status == "failure"
    let g:test_bar_popup = popup_create("", #{line: 10000, minwidth: 10000, time: 10000, highlight: 'TestRed'})
  else
    let g:test_bar_popup = popup_create("", #{line: 10000, minwidth: 10000, time: 10000, highlight: 'TestGreen'})
  endif
END

let g:asyncrun_exit = join(s:on_asyncrun_exit, "\n")

" vim-dispatch
let g:dispatch_compilers = {'bundle exec': 'rake'}

" smartinput
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

" ctrlp
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
let g:ctrlp_types = ['mru', 'fil', 'buf']
