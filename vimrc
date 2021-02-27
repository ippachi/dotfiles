filetype plugin indent on
syntax enable
set title
set expandtab
set tabstop=8
set shiftwidth=2
set softtabstop=2
set autoindent
set smartindent
set hidden
set showcmd
set cmdheight=2
set showmatch
set laststatus=2
set wildmenu wildmode=list:longest,full
set ignorecase
set smartcase
set incsearch
set hlsearch
set helplang=ja,en
set wildignore+=*/node_modules/*,*/tmp/cache/*,*/tmp/storage/*,*/log*

set clipboard=unnamed
set autoread
set number
set ttimeout
set signcolumn=number
set completeopt=menuone,noinsert,noselect,preview
set fileencodings=utf-8,cp932,shift-jis,euc-jp
set encoding=utf-8

set backup
set swapfile
set undofile
set backupdir=~/.cache/vim/backup/
set directory=~/.cache/vim/swap/
set undodir=~/.cache/vim/undo/
set pumheight=10
set diffopt+=algorithm:histogram,indent-heuristic

let mapleader = ","

if executable('rg')
  set grepprg=rg\ --vimgrep\ --smart-case
endif

" mappings and commands {{{1
noremap j gj
noremap k gk
nnoremap Y y$
nnoremap <Left> gT
nnoremap <right> gt
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <C-x> <C-r>=expand('%')<cr>
noremap \ ,

nnoremap <silent> ]c :cnext<cr>
nnoremap <silent> [c :cprev<cr>

augroup vimrc-ruby
  autocmd!
  autocmd BufNewFile,BufRead *.jbuilder,*.jb,Steepfile setlocal filetype=ruby
  autocmd FileType ruby setlocal regexpengine=1
  autocmd FileType eruby setlocal regexpengine=1
augroup END

augroup vimrc-gitconfig
  autocmd!
  autocmd FileType gitconfig setlocal noexpandtab shiftwidth=8
augroup END

augroup vimrc-csv
  autocmd!
  autocmd BufNewFile,BufRead *.csv,*.dat  setlocal filetype=csv
augroup END

augroup vimrc-js
  autocmd!
  autocmd BufNewFile,BufRead *.es6  setlocal filetype=javascript
augroup END

augroup vimrc-php
  autocmd!
  autocmd BufNewFile,BufRead *.blade.php  setlocal filetype=blade
augroup END

augroup vimrc-checktime
  autocmd!
  autocmd WinEnter,FocusGained * checktime
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
command! -nargs=0 CopyPath let @*=expand("%")

" plugins {{{1
call plug#begin('~/.vim/plugged')
" theme
Plug 'itchyny/lightline.vim'
Plug 'morhetz/gruvbox'

" fizzy finder
Plug 'ctrlpvim/ctrlp.vim'

" git diff
Plug 'airblade/vim-gitgutter'

" quickrun
Plug 'thinca/vim-quickrun'

" alignment
Plug 'junegunn/vim-easy-align'

" diffline
Plug 'AndrewRadev/linediff.vim'

" for writing
Plug 'machakann/vim-sandwich'
Plug 'machakann/vim-swap'
Plug 'machakann/vim-textobj-delimited'

" test
Plug 'vim-test/vim-test'

" undotree
Plug 'simnalamburt/vim-mundo'

" indentline
Plug 'Yggdroot/indentLine'

Plug 'vim-jp/vimdoc-ja'

Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'

Plug 'hashivim/vim-terraform'

Plug 'thinca/vim-themis'
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
  \     [ 'readonly', 'filename', 'modified' ]
  \   ],
  \   'right':[
  \     [ 'filetype', 'fileencoding', 'lineinfo', 'percent' ]
  \   ],
  \ },
  \ }

" gitgutter
let g:gitgutter_map_keys = 0
nmap <leader>hp <Plug>(GitGutterPreviewHunk)
nmap <leader>hu <Plug>(GitGutterUndoHunk)

" vim-easy-align
xmap ga <Plug>(EasyAlign)

" vim-test
nmap <silent> <leader>tn <cmd>TestNearest<CR>
nmap <silent> <leader>tf <cmd>TestFile<CR>
nmap <silent> <leader>tl :TestLast<CR>
let test#strategy = "vimterminal"

" indentline
let g:indentLine_faster = 1

" polyglot
let g:vim_markdown_conceal = 0
let g:vim_markdown_conceal_code_blocks = 0

" ctrlp
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

" vim-lsp
function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=number
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> <leader>gs <plug>(lsp-document-symbol-search)
    nmap <buffer> <leader>gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <Plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <Plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)

    let g:lsp_format_sync_timeout = 1000
    autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')

    " refer to doc to add more commands
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_diagnostics_float_cursor = 1

inoremap <expr> <cr> pumvisible() ? asyncomplete#close_popup() . "\<cr>" : "\<cr>"
let g:asyncomplete_popup_delay = 200

" let g:lsp_log_verbose = 1
" let g:lsp_log_file = expand('~/vim-lsp.log')
