" =======================================================================================
" leader
" =======================================================================================
let mapleader = ","

" =======================================================================================
" Plugins
" =======================================================================================
call plug#begin('~/.vim/plugged')
  Plug 'morhetz/gruvbox'
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'
  Plug 'tpope/vim-surround'
  Plug 'airblade/vim-gitgutter'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-repeat'
  Plug 'w0rp/ale'
  Plug 'vim-scripts/matchit.zip'
  Plug 'junegunn/vim-easy-align'
  Plug 'easymotion/vim-easymotion'
  Plug 'rhysd/clever-f.vim'
  Plug 'vim-jp/vimdoc-ja'
  Plug 'kana/vim-submode'
  Plug 'tyru/nextfile.vim'
  Plug 'tpope/vim-commentary'
  Plug 'thinca/vim-quickrun'
  Plug 'mbbill/undotree'
  Plug 'itchyny/lightline.vim'
  Plug 'shinchu/lightline-gruvbox.vim'
  Plug 'liuchengxu/vista.vim'
  Plug 'rhysd/try-colorscheme.vim'
  Plug 'machakann/vim-sandwich'
  Plug 'haya14busa/vim-asterisk'
  Plug 'kkoomen/vim-doge'

  if has('python3')
    Plug 'SirVer/ultisnips'
    Plug 'honza/vim-snippets'
  endif

  if has('nvim')
    Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
  else
    Plug 'Shougo/defx.nvim'
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
  endif

  Plug 'vim-ruby/vim-ruby', { 'for': 'ruby' }
  Plug 'tpope/vim-rails', { 'for': 'ruby' }
  Plug 'posva/vim-vue', { 'for': 'vue' }
  Plug 'chrisbra/csv.vim', { 'for': 'csv' }
  Plug 'mattn/emmet-vim', { 'for': ['html', 'eruby', 'vue'] }
  Plug 'tyru/eskk.vim'
  Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'jwalton512/vim-blade'
call plug#end()

" =======================================================================================
" Plugin settings
" =======================================================================================
" =======================================================================================
" theme
set background=dark
colorscheme gruvbox
let g:gruvbox_contrast_dark = 'hard'
set termguicolors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
let g:enable_italic_font = 1
let g:hybrid_transparent_background = 1
" =======================================================================================
" defx
autocmd FileType defx call s:defx_my_settings()
function! s:defx_my_settings() abort
  " Define mappings
  nnoremap <silent><buffer><expr> <CR>
  \ defx#do_action('open')
  nnoremap <silent><buffer><expr> c
  \ defx#do_action('copy')
  nnoremap <silent><buffer><expr> m
  \ defx#do_action('move')
  nnoremap <silent><buffer><expr> p
  \ defx#do_action('paste')
  nnoremap <silent><buffer><expr> l
  \ defx#do_action('open')
  nnoremap <silent><buffer><expr> E
  \ defx#do_action('open', 'vsplit')
  nnoremap <silent><buffer><expr> P
  \ defx#do_action('open', 'pedit')
  nnoremap <silent><buffer><expr> o
  \ defx#do_action('open_or_close_tree')
  nnoremap <silent><buffer><expr> K
  \ defx#do_action('new_directory')
  nnoremap <silent><buffer><expr> N
  \ defx#do_action('new_file')
  nnoremap <silent><buffer><expr> M
  \ defx#do_action('new_multiple_files')
  nnoremap <silent><buffer><expr> C
  \ defx#do_action('toggle_columns',
  \                'mark:indent:icon:filename:type:size:time')
  nnoremap <silent><buffer><expr> S
  \ defx#do_action('toggle_sort', 'time')
  nnoremap <silent><buffer><expr> d
  \ defx#do_action('remove')
  nnoremap <silent><buffer><expr> r
  \ defx#do_action('rename')
  nnoremap <silent><buffer><expr> !
  \ defx#do_action('execute_command')
  nnoremap <silent><buffer><expr> x
  \ defx#do_action('execute_system')
  nnoremap <silent><buffer><expr> yy
  \ defx#do_action('yank_path')
  nnoremap <silent><buffer><expr> .
  \ defx#do_action('toggle_ignored_files')
  nnoremap <silent><buffer><expr> ;
  \ defx#do_action('repeat')
  nnoremap <silent><buffer><expr> h
  \ defx#do_action('cd', ['..'])
  nnoremap <silent><buffer><expr> ~
  \ defx#do_action('cd')
  nnoremap <silent><buffer><expr> q
  \ defx#do_action('quit')
  nnoremap <silent><buffer><expr> <Space>
  \ defx#do_action('toggle_select') . 'j'
  nnoremap <silent><buffer><expr> *
  \ defx#do_action('toggle_select_all')
  nnoremap <silent><buffer><expr> j
  \ line('.') == line('$') ? 'gg' : 'j'
  nnoremap <silent><buffer><expr> k
  \ line('.') == 1 ? 'G' : 'k'
  nnoremap <silent><buffer><expr> <C-l>
  \ defx#do_action('redraw')
  nnoremap <silent><buffer><expr> <C-g>
  \ defx#do_action('print')
  nnoremap <silent><buffer><expr> cd
  \ defx#do_action('change_vim_cwd')
endfunction


" =======================================================================================
" deoplete
" let g:deoplete#enable_at_startup = 1

" =======================================================================================
" submode
call submode#enter_with('nextfile', 'n', 'r', '<Leader>n', '<Plug>(nextfile-next)')
call submode#enter_with('nextfile', 'n', 'r', '<Leader>p', '<Plug>(nextfile-previous)')
call submode#map('nextfile', 'n', 'r', 'n', '<Plug>(nextfile-next)')
call submode#map('nextfile', 'n', 'r', 'p', '<Plug>(nextfile-previous)')

" =======================================================================================
" airline
let g:airline_powerline_fonts = 1
let g:airline_theme = 'hybrid'

" =======================================================================================
" ale
let g:ale_linters = {
\   'ruby': ['rubocop'],
\   'javascript': ['eslint'],
\   'vue': ['eslint'],
\}
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'ruby': ['rubocop'],
\   'javascript': ['eslint'],
\   'vue': ['eslint'],
\}
nnoremap <space>af :ALEFix<cr>

if has('nvim')
  let g:ale_virtualtext_cursor = 1
endif

" =======================================================================================
" easy align
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" =======================================================================================
" Leaderf
let g:Lf_HideHelp = 1
let g:Lf_UseCache = 0
let g:Lf_UseVersionControlTool = 0
let g:Lf_IgnoreCurrentBufferName = 1
let g:Lf_WindowPosition = 'popup'
let g:Lf_PreviewInPopup = 1
let g:Lf_StlSeparator = { 'left': "\ue0b0", 'right': "\ue0b2", 'font': "DejaVu Sans Mono for Powerline" }
let g:Lf_PreviewResult = {'Function': 0, 'BufTag': 0 }
let g:Lf_ExternalCommand = 'rg --files "%s"'

" =======================================================================================
" fzf

nnoremap <space><space> :<C-u>Leaderf file<cr>
noremap <space>fb :<C-U><C-R>=printf("Leaderf buffer %s", "")<CR><CR>
noremap <space>fm :<C-U><C-R>=printf("Leaderf mru %s", "")<CR><CR>
nnoremap - :Rg <c-r>=expand("<cword>")<cr><cr>

" [[B]Commits] Customize the options used by 'git log':
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

" [Tags] Command to generate tags file
let g:fzf_tags_command = 'ctags -R'

" =======================================================================================
" easy motion
nmap <Leader>f <Plug>(easymotion-overwin-f2)

" =======================================================================================
" vista
function! NearestMethodOrFunction() abort
  return get(b:, 'vista_nearest_method_or_function', '')
endfunction

" let g:vista_default_executive = 'coc'
let g:vista_fzf_preview = ['right:50%']
nnoremap <Leader>v :Vista vim_lsp<CR> 

" =======================================================================================
" lightline
let g:lightline = {
      \ 'colorscheme': 'gruvbox',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'filename', 'modified', 'method', 'swap' ] ]
      \ },
      \ 'component': {
      \   'swap': '%{get(b:, "swapfile_exists", 0) ? "[swp]" : ""}'
      \ },
      \ 'component_function': {
      \   'method': 'NearestMethodOrFunction'
      \ },
      \ }


" =======================================================================================
" eskk.vim
let g:eskk#directory = "~/.eskk"
let g:eskk#dictionary = { 'path': "~/.skk-jisyo", 'sorted': 0, 'encoding': 'utf-8', }
let g:eskk#large_dictionary = { 'path': "~/.eskk/SKK-JISYO.L", 'sorted': 1, 'encoding': 'euc-jp', }
let g:eskk#enable_completion = 1
let g:eskk#server = {
\   'host': 'localhost',
\   'port': 55100,
\}

" =======================================================================================
" asyncomplete.vim
inoremap <expr> <cr>    pumvisible() ? "\<C-y>\<cr>" : "\<cr>"
set completeopt=menuone,noinsert,noselect,preview

" =======================================================================================
" General settings
" =======================================================================================
" =======================================================================================
" default mappings
noremap j gj
noremap k gk
nnoremap Y y$
nnoremap <C-w>* <C-w>s*
nnoremap <C-w># <C-w>s#
nnoremap <C-w><Space>s :sp<CR>:Files<CR>
nnoremap <C-w><Space>v :vs<CR>:Files<CR>
nnoremap / /\v
nnoremap ? ?\v
map *  <Plug>(asterisk-z*)
map #  <Plug>(asterisk-z#)
map g* <Plug>(asterisk-gz*)
map g# <Plug>(asterisk-gz#)
map z*  <Plug>(asterisk-z*)
map gz* <Plug>(asterisk-gz*)
map z#  <Plug>(asterisk-z#)
map gz# <Plug>(asterisk-gz#)
nnoremap <silent> <Esc><Esc> :<C-u>nohlsearch<CR>

nnoremap <Leader>bn :bnext<CR>
nnoremap <Leader>bp :bprev<CR>
nnoremap <Leader>tn :tabnew<CR>
nnoremap <Leader>tc :tabclose<CR>
nnoremap <Leader>src :source $HOME/.vimrc<CR>
nmap <Leader>ts ds'ds"i:<ESC>

nnoremap <Left> gT
nnoremap <right> gt

nnoremap <C-j> 3j
nnoremap <C-k> 3k

vnoremap <C-j> 3j
vnoremap <C-k> 3k

imap <C-j> <Plug>(eskk:toggle)

" =======================================================================================
" default sets
filetype plugin indent on
syntax enable

set title
set expandtab
set tabstop=8
set shiftwidth=2
set softtabstop=2
set smartindent
set hidden
set history=50
set wildmenu
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
set helplang=ja,en
set splitbelow
set splitright
set timeout ttimeout
set timeout timeoutlen=3000 ttimeoutlen=100
set clipboard+=unnamed
set autoread
set list listchars=tab:^\ ,trail:_,extends:>,precedes:<
set backspace=indent,eol,start
set breakindent
set signcolumn=yes
set colorcolumn=80
highlight ColorColumn ctermbg=9

if has('nvim')
  set pumblend=10
endif

set t_ZH=^[[3m
set t_ZR=^[[23m

" temr color
let g:terminal_ansi_colors = [
\ '#073642',
\ '#dc322f',
\ '#859900',
\ '#b58900',
\ '#268bd2',
\ '#d33682',
\ '#2aa198',
\ '#eee8d5',
\ '#002b36',
\ '#cb4b16',
\ '#586e75',
\ '#657b83',
\ '#839496',
\ '#6c71c4',
\ '#93a1a1',
\ '#fdf6e3',
\ ]


" =======================================================================================
" backup.
set backup
set backupdir=~/.cache/vim/backup//
" Paths of swap file and backup file.
if $TMP !=# ''
  execute 'set backupdir+=' . escape(expand($TMP), ' \')
elseif has('unix')
  set backupdir+=/tmp
endif
set directory=~/.cache/vim/swap//
if has('persistent_undo')
  set undodir=~/.cache/vim/undo
  augroup vimrc-undofile
    autocmd!
    autocmd BufReadPre ~/* setlocal undofile
    if has('win32')
      autocmd BufReadPre D:/* setlocal undofile
    endif
  augroup END
endif
set backupcopy=yes
set viewdir=~/.cache/vim/view

call mkdir(expand('~/.cache/vim/backup'), 'p')
call mkdir(expand('~/.cache/vim/swap'), 'p')
call mkdir(expand('~/.cache/vim/undo'), 'p')

" =======================================================================================
" profile cursor move
function! ProfileCursorMove() abort
  let profile_file = expand('~/work/log/vim-profile.log')
  if filereadable(profile_file)
    call delete(profile_file)
  endif

  normal! gg
  normal! zR

  execute 'profile start ' . profile_file
  profile func *
  profile file *

  augroup ProfileCursorMove
    autocmd!
    autocmd CursorHold <buffer> profile pause | q
  augroup END

  for i in range(100)
    call feedkeys('j')
  endfor
endfunction

" =======================================================================================
" profile
command! ProfileStart call s:profile_start()
command! ProfilePause call s:profile_pause()

function! s:profile_start()
  profile start profile.log
  profile file *
  profile func *
endfunction

function! s:profile_pause()
  profile pause
  noautocmd qall!
endfunction

" =======================================================================================
" Rename
command! -nargs=1 Rename call s:rename(<q-args>)

function! s:rename(new_filename)
  execute('!mv % %:h/' . a:new_filename)
  execute('e %:h/' . a:new_filename)
endfunction

if has('vim_starting')
  let &t_SI .= "\e[6 q"
  let &t_EI .= "\e[2 q"
  let &t_SR .= "\e[4 q"
endif


" =======================================================================================
" augroup
" augroup vimrc-rm-whitespace
"   autocmd BufWritePre * %s/\s\+$//e
" augroup END

augroup vimrc-auto-cursorline
  autocmd!
  autocmd CursorMoved,CursorMovedI * call s:auto_cursorline('CursorMoved')
  autocmd CursorHold,CursorHoldI * call s:auto_cursorline('CursorHold')
  autocmd WinEnter * call s:auto_cursorline('WinEnter')
  autocmd WinLeave * call s:auto_cursorline('WinLeave')

  let s:cursorline_lock = 0
  function! s:auto_cursorline(event)
    if a:event ==# 'WinEnter'
      setlocal cursorline
      let s:cursorline_lock = 2
    elseif a:event ==# 'WinLeave'
      setlocal nocursorline
    elseif a:event ==# 'CursorMoved'
      if s:cursorline_lock
        if 1 < s:cursorline_lock
          let s:cursorline_lock = 1
        else
          setlocal nocursorline
          let s:cursorline_lock = 0
        endif
      endif
    elseif a:event ==# 'CursorHold'
      setlocal cursorline
      let s:cursorline_lock = 1
    endif
  endfunction
augroup END

augroup vimrc-file-type
  autocmd!
  autocmd BufNewFile,BufRead *.jbuilder setlocal filetype=ruby
  autocmd BufNewFile,BufRead *.csv,*.dat  setlocal filetype=csv
augroup END

augroup vimrc-file-indent
  autocmd!
  autocmd BufNewFile,BufRead *.gitconfig setlocal noexpandtab softtabstop=8 shiftwidth=8
  autocmd BufNewFile,BufRead *.php setlocal expandtab softtabstop=4 shiftwidth=4
augroup END

augroup vimrc-checktime
  autocmd WinEnter,FocusGained * checktime
augroup END

let &t_ZH="\e[3m"
let &t_ZR="\e[23m"
