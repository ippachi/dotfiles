" =======================================================================================
" leader
let mapleader = ","
" =======================================================================================

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
  Plug 'vim-jp/vimdoc-ja'
  Plug 'kana/vim-submode'
  Plug 'tpope/vim-commentary'
  Plug 'thinca/vim-quickrun'
  Plug 'mbbill/undotree'
  Plug 'itchyny/lightline.vim'
  Plug 'shinchu/lightline-gruvbox.vim'
  Plug 'rhysd/try-colorscheme.vim'
  Plug 'machakann/vim-sandwich'
  Plug 'haya14busa/vim-asterisk'

  if has('python3')
    Plug 'SirVer/ultisnips'
    Plug 'honza/vim-snippets'
  endif

  Plug 'vim-ruby/vim-ruby', { 'for': 'ruby' }
  Plug 'tpope/vim-rails', { 'for': 'ruby' }
  Plug 'posva/vim-vue', { 'for': 'vue' }
  Plug 'chrisbra/csv.vim', { 'for': 'csv' }
  Plug 'mattn/emmet-vim', { 'for': ['html', 'eruby', 'vue'] }

  Plug 'whiteinge/diffconflicts'
  Plug 'AndrewRadev/linediff.vim'

  Plug 'ruby-formatter/rufo-vim'

  Plug 'prabirshrestha/async.vim'
  Plug 'prabirshrestha/vim-lsp'

  Plug 'pbogut/fzf-mru.vim'
  Plug 'justinmk/vim-dirvish'
  Plug 'tpope/vim-eunuch'
  Plug 'lilydjwg/colorizer'
  Plug 'rhysd/reply.vim'
  Plug 'tyru/eskk.vim'
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
  " Plug 'lighttiger2505/deoplete-vim-lsp'
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
" deoplete.nvim
let g:deoplete#enable_at_startup = 1
call deoplete#custom#option('auto_complete_delay', 0)
let g:lsp_preview_autoclose = 1

" =======================================================================================
" eskk.vim
let g:eskk#directory = "~/.eskk"
let g:eskk#dictionary = "~/.eskk/eskk-jisyo"
let g:eskk#large_dictionary = { 'path': "~/.eskk/SKK-JISYO.L", 'sorted': 1, 'encoding': 'euc-jp' }
let g:eskk#start_completion_length = 1

augroup vimrc-lsp-clangd
  if executable('clangd')
    au!
    au User lsp_setup call lsp#register_server({
            \ 'name': 'clangd',
            \ 'cmd': {server_info->['clangd', '-background-index']},
            \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
            \ })
  endif
augroup END

augroup vimrc-lsp-solargraph
  if executable('solargraph')
      " gem install solargraph
      au!
      au User lsp_setup call lsp#register_server({
          \ 'name': 'solargraph',
          \ 'cmd': {server_info->[&shell, &shellcmdflag, 'solargraph stdio']},
          \ 'whitelist': ['ruby'],
          \ })
      autocmd FileType ruby setlocal omnifunc=lsp#complete
  endif
augroup END

let g:lsp_async_completion = 1

nnoremap gd :<C-u>LspDefinition<cr>

" =======================================================================================
" ultisnips
let g:UltiSnipsExpandTrigger="<C-k>"

" =======================================================================================
" submode
call submode#enter_with('nextfile', 'n', 'r', '<Leader>n', '<Plug>(nextfile-next)')
call submode#enter_with('nextfile', 'n', 'r', '<Leader>p', '<Plug>(nextfile-previous)')
call submode#map('nextfile', 'n', 'r', 'n', '<Plug>(nextfile-next)')
call submode#map('nextfile', 'n', 'r', 'p', '<Plug>(nextfile-previous)')

call submode#enter_with('winsize', 'n', '', '<C-w>-', '<C-w>-')
call submode#enter_with('winsize', 'n', '', '<C-w>+', '<C-w>+')
call submode#enter_with('winsize', 'n', '', '<C-w>>', '<C-w>>')
call submode#enter_with('winsize', 'n', '', '<C-w><', '<C-w><')
call submode#map('winsize', 'n', '', '-', '<C-w>-')
call submode#map('winsize', 'n', '', '+', '<C-w>+')
call submode#map('winsize', 'n', '', '>', '<C-w>>')
call submode#map('winsize', 'n', '', '<', '<C-w><')

" =======================================================================================
" " ale
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

nnoremap <leader>af :ALEFix<cr>

" =======================================================================================
" easy align
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" =======================================================================================
" fzf

nnoremap <space><space> :<C-u>FZFMru<cr>
nnoremap <space>ff :<C-u>Files<cr>
noremap <space>fb :<C-U>Buffers<CR>

let g:fzf_buffers_jump = 1

" [[B]Commits] Customize the options used by 'git log':
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

" [Tags] Command to generate tags file
let g:fzf_tags_command = 'ctags -R'

" [Commands] --expect expression for directly executing the command
let g:fzf_commands_expect = 'alt-enter,ctrl-x'

let g:fzf_mru_relative = 1

command! -nargs=0 Fq call fzf#run({
      \ 'source': 'ghq list --full-path',
      \ 'options': '--reverse --height 20%',
      \ 'down': '10%',
      \ 'sink': 'lcd'
      \ })

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

nnoremap <Leader>tn :tabnew<CR>
nnoremap <Leader>src :source $HOME/.vimrc<CR>

nnoremap <Left> gT
nnoremap <right> gt
inoremap <expr><cr> pumvisible() ? "\<C-y>\<cr>" : "\<cr>"

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
set completeopt=menuone,noselect,noinsert,popup

highlight ColorColumn ctermbg=9

set t_ZH=^[[3m
set t_ZR=^[[23m

let g:mucomplete#enable_auto_at_startup = 1

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

augroup vimrc-session
  autocmd!
  autocmd VimLeave * call s:make_session()
  autocmd VimEnter * call s:restore_session()

  function! s:make_session()
    let l:path = split(getcwd(), '/')
    let l:filename = l:path[l:path->len() - 1] . '_session.vim'
    let l:dirpath = filter(l:path, 'v:key !=# l:path->len() - 1')
    let l:session_dir_path = $HOME . '/.vim/sessions/' . join(l:dirpath, '/')
    call mkdir(l:session_dir_path, 'p')
    execute 'mksession! ' . l:session_dir_path . '/' . l:filename
  endfunction

  function! s:restore_session()
    if v:argv->len() > 1
      return
    endif

    let l:path = split(getcwd(), '/')
    let l:filename = l:path[l:path->len() - 1] . '_session.vim'
    let l:dirpath = filter(l:path, 'v:key !=# l:path->len() - 1')
    let l:session_dir_path = $HOME . '/.vim/sessions/' . join(l:dirpath, '/')
    if filereadable(l:session_dir_path . '/' . l:filename)
      execute 'source ' . l:session_dir_path . '/' . l:filename
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

augroup vimrc-set-regexpengine
  autocmd!
  autocmd BufNewFile,BufReadPre *.rb,*.erb,Schemafile setlocal regexpengine=1
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
augroup END

augroup vimrc-trim-whitespace
  autocmd!
  autocmd BufWritePre * :%s/\s\+$//ge
augroup END


let &t_ZH="\e[3m"
let &t_ZR="\e[23m"

if has('vim_starting')
  let &t_SI .= "\e[6 q"
  let &t_EI .= "\e[2 q"
  let &t_SR .= "\e[4 q"
endif

