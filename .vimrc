" =======================================================================================
" leader
" =======================================================================================
let mapleader = ","


" =======================================================================================
" Plugins " =======================================================================================
call plug#begin('~/.vim/plugged')
  Plug 'kristijanhusak/vim-hybrid-material'
  Plug 'morhetz/gruvbox'
  Plug 'Yggdroot/indentLine'
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'
  Plug 'tpope/vim-surround'
  Plug 'airblade/vim-gitgutter'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-repeat'

  Plug 'w0rp/ale'

  Plug 'vim-scripts/matchit.zip'
  " Plug 'andymass/vim-matchup'
  Plug 'mattn/emmet-vim'

  Plug 'mattn/sonictemplate-vim'
  Plug 'junegunn/vim-easy-align'
  Plug 'tpope/vim-abolish'
  Plug 'easymotion/vim-easymotion'
  Plug 'janko-m/vim-test'
  Plug 'tpope/vim-dispatch'

  Plug 'vim-jp/vimdoc-ja'
  Plug 'kana/vim-altr'
  Plug 'lambdalisue/gina.vim'

  Plug 'kana/vim-submode'
  Plug 'rhysd/clever-f.vim'
  Plug 'tpope/vim-commentary'
  Plug 'thinca/vim-quickrun'
  Plug 'Shougo/defx.nvim'
  Plug 'mbbill/undotree'
  Plug 'Shougo/denite.nvim'
  Plug 'yuttie/comfortable-motion.vim'

  " status line
  Plug 'itchyny/lightline.vim'
  Plug 'shinchu/lightline-gruvbox.vim'
  " Plug 'vim-airline/vim-airline'
  " Plug 'vim-airline/vim-airline-themes'

  " completion
  " Plug 'tbodt/deoplete-tabnine', { 'do': './install.sh' }
  " Plug 'zxqfl/tabnine-vim'
  " Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}
  " if has('nvim')
  "   Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  " else
  "   Plug 'Shougo/deoplete.nvim'
  "   Plug 'roxma/nvim-yarp'
  "   Plug 'roxma/vim-hug-neovim-rpc'
  " endif

  Plug 'prabirshrestha/asyncomplete.vim'
  Plug 'prabirshrestha/async.vim'
  Plug 'prabirshrestha/vim-lsp'
  Plug 'prabirshrestha/asyncomplete-lsp.vim'
  Plug 'prabirshrestha/asyncomplete-buffer.vim'

  " snip
  if !has('nvim')
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
  endif

  Plug 'Shougo/neosnippet.vim'
  Plug 'Shougo/neosnippet-snippets'

  " Plug 'prabirshrestha/asyncomplete-lsp.vim'
  " Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }
  Plug 'junegunn/goyo.vim'
  Plug 'kannokanno/previm'
  Plug 'pocke/cuculus.vim'
  Plug 'edkolev/tmuxline.vim'
  Plug 'liuchengxu/vista.vim'
  Plug 'RRethy/vim-illuminate'
  Plug 'rhysd/try-colorscheme.vim'
  Plug 'tyru/eskk.vim'

  " Plug 'haya14busa/vim-migemo'
  Plug 'rhysd/migemo-search.vim'

  " for ruby
  Plug 'tpope/vim-rails', { 'for': 'ruby' }
  " Plug 'vim-ruby/vim-ruby'
  Plug 'todesking/ruby_hl_lvar.vim', { 'for': 'ruby' }

  " for golang
  Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

  " for vue
  Plug 'posva/vim-vue', { 'for': 'vuejs' }

  " for csv
  Plug 'chrisbra/csv.vim'

  Plug 'machakann/vim-sandwich'
  Plug 'haya14busa/vim-asterisk'

  Plug 'kkoomen/vim-doge'
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
" airline

let g:airline_powerline_fonts = 1
let g:airline_theme = 'hybrid'


" =======================================================================================
" ale
" let g:ale_lint_on_text_changed = 'never'
" let g:ale_lint_on_enter = 0
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
let g:ale_set_balloons = 1
if has('nvim')
  let g:ale_virtualtext_cursor = 1
endif

" =======================================================================================
" sonic template
let g:sonictemplate_vim_template_dir = '$HOME/.vim/template'

" =======================================================================================
" easy align
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" =======================================================================================
" fzf
nnoremap <space><space> :Files<cr>
nnoremap <space>b :Buffers<cr>

" =======================================================================================
" rg
nnoremap - :Rg <c-r>=expand("<cword>")<cr><cr>
nnoremap <space>/ :Rg<space>


" =======================================================================================
" easy motion
nmap <Leader>f <Plug>(easymotion-overwin-f2)

" =======================================================================================
" test
nnoremap <space>tf :TestFile<cr>
nnoremap <space>tn :TestNearest<cr>
let test#strategy = "dispatch"

" =======================================================================================
" altr
" nmap <C-n> <Plug>(altr-forward)
" nmap <C-p> <Plug>(altr-back)
" call altr#define(
"
"   \   'app/models/%.rb',
"   \   'spec/models/%_spec.rb',
"   \   'config/locales/models/%/ja.yml',
"   \   'spec/factories/%s.rb')
"   call altr#define(
"   \   'app/controllers/%_controller.rb',
"   \   'spec/controllers/%_controller_spec.rb',
"   \   'app/views/%/*.html.erb',
"   \   'app/views/%/*.json.jbuilder',
"   \   'spec/requests/%_spec.rb')
"   call altr#define('app/%/%.rb', 'spec/%/%_spec.rb')
"   call altr#define('lib/%.rb', 'spec/lib/%_spec.rb')
"   call altr#define('lib/tasks/%.rake', 'spec/rake/%_spec.rb')


" =======================================================================================
" gina
nnoremap <Leader>gs :Gina status<CR>
nnoremap <Leader>gc :Gina commit<CR>
nnoremap <Leader>gl :Gina log<CR>
nnoremap <Leader>gb :Gina branch<CR><C-w>L:vertical resize 30<CR>

call gina#custom#command#option('log', '--opener', 'vsplit')
call gina#custom#command#option('branch', '--opener', 'vsplit')
call gina#custom#command#option('status', '--opener', 'tabnew')
call gina#custom#command#option('diff', '--opener', 'split')

" =======================================================================================
" deoplete
" let g:deoplete#enable_at_startup = 1


" =======================================================================================
" submode
call submode#enter_with('winsize', 'n', '', '<C-w>>', '<C-w>>')
call submode#enter_with('winsize', 'n', '', '<C-w><', '<C-w><')
call submode#enter_with('winsize', 'n', '', '<C-w>+', '<C-w>+')
call submode#enter_with('winsize', 'n', '', '<C-w>-', '<C-w>-')
call submode#map('winsize', 'n', '', '>', '<C-w>>')
call submode#map('winsize', 'n', '', '<', '<C-w><')
call submode#map('winsize', 'n', '', '+', '<C-w>+')
call submode#map('winsize', 'n', '', '-', '<C-w>-')

" nnoremap <expr> <Plug>RubyMethodMove b:ruby_method_move

" augroup vimr-ruby-unmap
"   autocmd!
"   autocmd BufRead *.rb let b:ruby_method_move = matchlist(maparg('[m', 'n'), ':<C-U>call \(.*\)<CR>')[1]
"   autocmd BufRead *.rb unmap <buffer>[m
"   autocmd BufRead *.rb call submode#enter_with('move_method', 'n', '', '[m')
"   autocmd BufRead *.rb call submode#map('move_method', 'n', 'r', '[', '<Plug>RubyMethodMove')
" augroup END

" =======================================================================================
" coc-snippets
" Use <C-l> for trigger snippet expand.
" imap <C-l> <Plug>(coc-snippets-expand)
" " Use <C-j> for select text for visual placeholder of snippet.
" vmap <C-j> <Plug>(coc-snippets-select)
" " Use <C-j> for jump to next placeholder, it's default of coc.nvim
" let g:coc_snippet_next = '<c-j>'
" " Use <C-k> for jump to previous placeholder, it's default of coc.nvim
" let g:coc_snippet_prev = '<c-k>'
" " Use <C-j> for both expand and jump (make expand higher priority.)
" imap <C-j> <Plug>(coc-snippets-expand-jump)

" =======================================================================================
" defx
nnoremap <Leader>a :Defx -split=vertical<CR><C-w>H:vertical resize 30<CR>
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
" denite
autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
  nnoremap <silent><buffer><expr> <CR>
  \ denite#do_map('do_action')
  nnoremap <silent><buffer><expr> v
  \ denite#do_map('do_action', 'vsplit')
  nnoremap <silent><buffer><expr> s
  \ denite#do_map('do_action', 'split')
  nnoremap <silent><buffer><expr> d
  \ denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> p
  \ denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr> q
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> i
  \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <Space>
  \ denite#do_map('toggle_select').'j'
  call denite#custom#var('file/rec', 'command',
  \ ['rg', '--files', '--glob', '!.git'])
endfunction

nnoremap <Leader>df :Denite -start-filter file/rec buffer<CR>
nnoremap <Leader>dh :Denite help<CR>i
nnoremap <Leader>ds :Denite tag<CR>i

" =======================================================================================
" previm
let g:previm_open_cmd = 'open -a vivaldi'

" =======================================================================================
" cuclus.vim
" autocmd CursorMoved *.rb call cuculus#display_pair_to_popup()

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
" cmigemo
if executable('cmigemo')
  " cnoremap <expr><CR> migemosearch#replace_search_word()."\<CR>"
endif

" =======================================================================================
" comfortable-motion.vim
nnoremap <silent> <C-d> :call comfortable_motion#flick(100)<CR>
nnoremap <silent> <C-u> :call comfortable_motion#flick(-100)<CR>

nnoremap <silent> <C-f> :call comfortable_motion#flick(400)<CR>
nnoremap <silent> <C-b> :call comfortable_motion#flick(-400)<CR>

" =======================================================================================
" neosnippet
" Plugin key-mappings.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
"imap <expr><TAB>
" \ pumvisible() ? "\<C-n>" :
" \ neosnippet#expandable_or_jumpable() ?
" \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

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
" indentLine.vim
let g:indentLine_char_list = ['.', '|']

" =======================================================================================
" asyncomplete
call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
    \ 'name': 'buffer',
    \ 'whitelist': ['*'],
    \ 'blacklist': [],
    \ 'completor': function('asyncomplete#sources#buffer#completor'),
    \ 'config': {
    \    'max_buffer_size': 5000000,
    \  },
    \ }))

inoremap <expr> <CR> pumvisible() ? asyncomplete#close_popup() . "\<CR>" :  "\<CR>"

" =======================================================================================
" vim-lsp
augroup vimrc-lsp
  autocmd!
  if executable('solargraph')
      " gem install solargraph
      au User lsp_setup call lsp#register_server({
          \ 'name': 'solargraph',
          \ 'cmd': {server_info->[&shell, &shellcmdflag, 'solargraph stdio']},
          \ 'initialization_options': {"diagnostics": "true"},
          \ 'whitelist': ['ruby'],
          \ })
  endif

  " if executable('vls')
  "     au User lsp_setup call lsp#register_server({
  "         \ 'name': 'vls',
  "         \ 'cmd': {server_info->[&shell, &shellcmdflag, 'vls --stdio']},
  "         \ 'whitelist': ['vue'],
  "         \ })
  " endif
  if executable('ccls')
     au User lsp_setup call lsp#register_server({
        \ 'name': 'ccls',
        \ 'cmd': {server_info->['ccls']},
        \ 'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'compile_commands.json'))},
        \ 'initialization_options': {},
        \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp', 'cc'],
        \ })
  endif
augroup END

let g:lsp_diagnostics_enabled = 0         " disable diagnostics support

" =======================================================================================
" ruby_hl_lvar.vim
highlight link RubyLocalVariable GruvboxOrange
let g:ruby_hl_lvar_hl_group = 'RubyLocalVariable'


" plugend

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
set clipboard=unnamedplus
set autoread


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
" Swap
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
" Swap

set swapfile

augroup vimrc-swapfile
  autocmd!
  autocmd SwapExists * call s:on_SwapExists()
augroup END

function! s:on_SwapExists() abort
  if !filereadable(expand('<afile>'))
    let v:swapchoice = 'd'
    return
  endif
  let v:swapchoice = get(b:, 'swapfile_choice', 'o')
  unlet! b:swapfile_choice
  if v:swapchoice !=# 'd'
    let b:swapfile_exists = 1
  endif
endfunction

command! SwapfileRecovery call s:swapfile_recovery()
command! SwapfileDelete call s:swapfile_delete()

function! s:swapfile_recovery() abort
  if get(b:, 'swapfile_exists', 0)
    let b:swapfile_choice = 'r'
    unlet b:swapfile_exists
    edit
  endif
endfunction

function! s:swapfile_delete() abort
  if get(b:, 'swapfile_exists', 0)
    let b:swapfile_choice = 'd'
    unlet b:swapfile_exists
    edit
  endif
endfunction

" =======================================================================================
" yank cmd message
command! YankMessage call s:yank_message()

function! s:yank_message()
  redir @"
  1message
  redir END
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
" Rubocop Disable
command! DisableRubocop  call s:disable_rubocop()

function! s:disable_rubocop()
  let l:message = execute('1message')

  if l:message == ''
    return
  endif

  let l:disable_target = split(l:message, ':')[0]

  call setline('.', getline('.') . ' # rubocop:disable ' . l:disable_target)
endfunction

" =======================================================================================
" Rubocop Disable
command! RubyLength call s:ruby_length_calc()

function! s:ruby_length_calc()
  let l:func_start = search('\sdef .*\((\|;\|\s\|\n\)', 'nb')
  let l:func_end = search('\send\(\s\|\n\)', 'n')
  echom l:func_end - l:func_start
endfunction




" =======================================================================================
" augroup
augroup vimrc-rm-whitespace
  autocmd BufWritePre * %s/\s\+$//e
augroup END

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
augroup END

augroup vimrc-checktime
  autocmd WinEnter,FocusGained * checktime
augroup END

let &t_ZH="\e[3m"
let &t_ZR="\e[23m"
