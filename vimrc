" vim-default-settings {{{1
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
set wildignore+=*/node_modules/*,*/tmp/cache/*,*/tmp/storage/*,*/log*

set timeout timeoutlen=3000 ttimeoutlen=100
" set clipboard=unnamedplus
set autoread
set nolist listchars=tab:>.,trail:_,extends:>,precedes:<,eol:$
set backspace=indent,eol,start
set breakindent
set number
set signcolumn=number
set completeopt=menu,menuone,popup,noinsert,noselect
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

if has('vim_starting')
  let &t_SI .= "\e[6 q"
  let &t_EI .= "\e[2 q"
  let &t_SR .= "\e[4 q"
endif

colorscheme default

let mapleader = ","

let g:ruby_path = []

set termguicolors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

if executable('rg')
  set grepprg=rg\ --vimgrep\ --smart-case
endif

" mappings and commands {{{1
noremap j gj
noremap k gk
nnoremap Y y$
nnoremap <Left> gT
nnoremap <right> gt
nnoremap <silent> <esc><esc> <Cmd>nohlsearch<CR>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <C-x> <C-r>=expand('%')<cr>
cnoremap <C-a> **/*
noremap \ ,

nnoremap <silent> ]t :tnext<cr>
nnoremap <silent> [t :tprev<cr>
nnoremap <silent> ]c :cnext<cr>
nnoremap <silent> [c :cprev<cr>
nnoremap <silent> ]l :lnext<cr>
nnoremap <silent> [l :lprev<cr>

augroup vimrc-file-type
  autocmd!
  autocmd BufNewFile,BufRead *.jbuilder,*.jb setlocal filetype=ruby
  autocmd BufNewFile,BufRead *.csv,*.dat  setlocal filetype=csv
  autocmd BufNewFile,BufRead *.es6  setlocal filetype=javascript
  autocmd BufNewFile,BufRead *.blade.php  setlocal filetype=blade
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
  autocmd FileType ruby setlocal regexpengine=1
  autocmd FileType eruby setlocal regexpengine=1
augroup END

augroup vimrc-trim-whitespace
  autocmd!
  autocmd BufWritePre * :%s/\s\+$//ge
augroup END

augroup vimrc-zennkaku
  autocmd!
  autocmd ColorScheme * highlight ZenkakuSpace ctermfg=12 ctermbg=12
  autocmd VimEnter * match ZenkakuSpace /　/
augroup END

function s:new_memo(filename)
  let today = trim(system('date -u +"%Y-%m-%d"'))
  let memo_path = get(g:, 'memo_path', '~/.config/memo/_posts')

  exec 'edit ' . memo_path . '/' . today . '-' . a:filename . '.md'
endfunction

function s:search_memo()
  let memo_path = get(g:, 'memo_path', '~/.config/memo/_posts')

  exec 'edit ' . memo_path
endfunction

function s:memo(filename)
  " remove ^@
  if strlen(a:filename)
    call s:new_memo(a:filename)
  else
    call s:search_memo()
  endif
endfunction

command! -nargs=? Memo call s:memo(<q-args>)

" plugins {{{1
call plug#begin('~/.vim/plugged')
" theme
Plug 'junegunn/seoul256.vim'
Plug 'itchyny/lightline.vim'
Plug 'ghifarit53/tokyonight-vim'
Plug 'morhetz/gruvbox'

" fizzy finder
" Plug 'ctrlpvim/ctrlp.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" git diff
Plug 'airblade/vim-gitgutter'

" quickrun
Plug 'thinca/vim-quickrun'

" alignment
Plug 'junegunn/vim-easy-align'

" diffline
Plug 'AndrewRadev/linediff.vim'

" for writing
Plug 'junegunn/goyo.vim'

" lsp
Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'

Plug 'rubyide/vscode-ruby'

Plug 'machakann/vim-sandwich'
Plug 'machakann/vim-swap'
Plug 'machakann/vim-textobj-delimited'

" test
Plug 'vim-test/vim-test'

" sudo edit
Plug 'lambdalisue/suda.vim'
Plug 'golang/vscode-go'

" undotree
Plug 'simnalamburt/vim-mundo'

" terraform
Plug 'hashivim/vim-terraform'

" indentline
Plug 'Yggdroot/indentLine'
call plug#end()

set background=dark
let g:gruvbox_italic = 1
let g:gruvbox_invert_selection = 0
colorscheme gruvbox

" lightline
let g:lightline = {
  \ 'colorscheme': 'gruvbox',
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

" fzf
nnoremap <c-p> <cmd>FZF<cr>

" gitgutter
let g:gitgutter_map_keys = 0
nmap <leader>hp <Plug>(GitGutterPreviewHunk)
nmap <leader>hu <Plug>(GitGutterUndoHunk)

" vim-easy-align
xmap ga <Plug>(EasyAlign)

" vim-vsnip
imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'

let g:vsnip_snippet_dirs = [
      \ "~/.vim/plugged/vscode-ruby/packages/vscode-ruby/snippets"
      \ ]

let g:vsnip_filetypes = {}

" vim-test
nmap <silent> <leader>tn <cmd>TestNearest<CR>
nmap <silent> <leader>tf <cmd>TestFile<CR>
nmap <silent> <leader>tl :TestLast<CR>
let test#strategy = "basic"

" indentline
let g:indentLine_faster = 1
