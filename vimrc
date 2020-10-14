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
set wildignore+=*/node_modules/*,*/tmp/cache/*,*/tmp/storage/*,*/log*

set timeout timeoutlen=3000 ttimeoutlen=100
" set clipboard=unnamedplus
set autoread
set list listchars=tab:^\ ,trail:_,extends:>,precedes:<
set backspace=indent,eol,start
set breakindent
set number
set signcolumn=number
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

augroup vimrc-lint
  autocmd!
  autocmd BufWritePre *.rb call s:exec_lint()
augroup END

function! s:exec_lint() abort
  let s:async_test_error_list = []
  let g:async_test_job = job_start('bundle exec rubocop --format emacs ' . expand('%'),
        \ #{
        \ out_cb: function('s:proccess_line'),
        \ exit_cb: function('s:on_finished_lint')})
endfunction

function! s:proccess_line(a, error_content) abort
  call add(s:async_test_error_list, a:error_content)
endfunction

function! s:on_finished_lint(a, error_content) abort
  call setqflist([], ' ', #{ lines: s:async_test_error_list })
endfunction

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

" =======================================================================================
" plugins
" =======================================================================================

call plug#begin('~/.vim/plugged')
" theme
Plug 'junegunn/seoul256.vim'
Plug 'itchyny/lightline.vim'
Plug 'ghifarit53/tokyonight-vim'
Plug 'karoliskoncevicius/oldbook-vim'

" fizzy finder
Plug 'ctrlpvim/ctrlp.vim'

" git diff
Plug 'airblade/vim-gitgutter'

" quickrun
Plug 'thinca/vim-quickrun'

" asyncrun
Plug 'tpope/vim-dispatch'

" autoclose
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

" filer
Plug 'justinmk/vim-dirvish'

" alignment
Plug 'junegunn/vim-easy-align'


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
nnoremap <leader>tn :<c-u>call AsyncTestNearest()<cr>
nnoremap <leader>tf :<c-u>call AsyncTestFile()<cr>
nnoremap <leader>ta :<c-u>call AsyncTestAll()<cr>
nnoremap <leader>tla :<c-u>call AsyncTestLint()<cr>
nnoremap <leader>tll :<c-u>call AsyncTestLintLocal()<cr>

nnoremap <leader>t<space> :<c-u>AsyncRun RUBYOPT='-W:no-deprecated -W:no-experimental' bundle exec rspec<space>
nnoremap <leader>tc :<c-u>botright cw 20<cr>

hi TestRed term=reverse ctermfg=252 ctermbg=52 guifg=#D9D9D9 guibg=#730B00
hi TestGreen term=bold ctermbg=22 guibg=#006F00

function! AsyncTestNearest() abort
  let g:async_test_running = 1
  call popup_close(get(g:, 'test_bar_popup', 0))
  exec "AsyncRun bundle exec rspec -b %:p:'" . line(".") . "'"
endfunction

function! AsyncTestFile() abort
  let g:async_test_running = 1
  call popup_close(get(g:, 'test_bar_popup', 0))
  exec "AsyncRun bundle exec rspec %:p"
endfunction

function! AsyncTestAll() abort
  let g:async_test_running = 1
  call popup_close(get(g:, 'test_bar_popup', 0))
  exec "AsyncRun bundle exec rspec"
endfunction

function! AsyncTestLint() abort
  let g:async_test_running = 1
  call popup_close(get(g:, 'test_bar_popup', 0))
  exec "AsyncRun bundle exec rubocop"
endfunction

function! AsyncTestLintLocal() abort
  let g:async_test_running = 1
  call popup_close(get(g:, 'test_bar_popup', 0))
  exec "AsyncRun bundle exec rubocop %:p"
endfunction

let s:on_asyncrun_exit =<< trim END
  if !get(g:, 'async_test_running', 0)
    return
  endif

  let g:async_test_running = 0
  cclose
  call popup_close(get(g:, 'test_bar_popup', 0))
  if g:asyncrun_status == "failure"
    let g:test_bar_popup = popup_create("", #{line: 0, col: 1, minwidth: 1, minheight: 20, highlight: 'TestRed'})
    botright cwindow 15
    execute "normal \<c-w>p"
  else
    let g:test_bar_popup = popup_create("", #{line: 0, col: 1, minwidth: 1, minheight: 20, highlight: 'TestGreen'})
  endif
END

let g:asyncrun_exit = join(s:on_asyncrun_exit, "\n")

" vim-dispatch
let g:dispatch_compilers = {'bundle exec': 'rake'}

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

" gitgutter
let g:gitgutter_map_keys = 0
nmap <leader>hp <Plug>(GitGutterPreviewHunk)
nmap <leader>hu <Plug>(GitGutterUndoHunk)

" vim-easy-align
xmap ga <Plug>(EasyAlign)
