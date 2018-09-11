" プラグインがインストールされるディレクトリ
let s:dein_dir = expand('~/.cache/dein')
" dein.vim 本体
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" dein.vim がなければ github から落としてくる
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

  " 設定開始
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  " プラグインリストを収めた TOML ファイル
  " 予め TOML ファイルを用意しておく
  let g:rc_dir    = expand("~/.config/nvim/")
  let s:toml      = g:rc_dir . '/dein.toml'
  let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'

  " TOML を読み込み、キャッシュしておく
  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  " 設定終了
  call dein#end()
  call dein#save_state()
endif

  " もし、未インストールものものがあったらインストール
if dein#check_install()
  call dein#install()
endif

let g:python_host_prog = '/home/vagrant/.pyenv/versions/neovim2/bin/python'
let g:python3_host_prog = '/home/vagrant/.pyenv/versions/neovim3/bin/python'

" general
nnoremap j gj
nnoremap k gk
noremap <silent> <C-c> <C-[>
inoremap <silent> <C-c> <C-[>
vnoremap <silent> <C-c> <C-[>
noremap <silent> <C-l> $
noremap <silent> <C-h> 0

" fzf
nnoremap <silent> zj :Files <cr>
nnoremap <silent> zk :Buffers <cr>

" ale
nnoremap <silent> <Space>s :ALEFix <cr>

" easy align
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" easy motion
map  <Space>f <Plug>(easymotion-bd-f)
nmap <Space>f <Plug>(easymotion-overwin-f)
nmap s <Plug>(easymotion-overwin-f2)
map <Space>L <Plug>(easymotion-bd-jk)
nmap <Space>L <Plug>(easymotion-overwin-line)
map  <Space>w <Plug>(easymotion-bd-w)
nmap <Space>w <Plug>(easymotion-overwin-w)

" LSP
nnoremap <F5> :call LanguageClient_contextMenu()<CR>


syntax on
set number
set title
set ambiwidth=double
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
set rtp+=~/.fzf
set inccommand=split
set t_ut=

autocmd FileType vue syntax sync fromstart

augroup fileTypeIndent
  autocmd!
  autocmd BufNewFile,BufRead *.py setlocal tabstop=4 softtabstop=4 shiftwidth=4
  autocmd BufNewFile,BufRead *.go setlocal tabstop=4 softtabstop=4 shiftwidth=4
  autocmd BufNewFile,BufRead *.c setlocal tabstop=4 softtabstop=4 shiftwidth=4
  autocmd BufNewFile,BufRead *.cpp setlocal tabstop=4 softtabstop=4 shiftwidth=4
  autocmd BufNewFile,BufRead *.rb setlocal tabstop=2 softtabstop=2 shiftwidth=2
augroup END

filetype indent on

autocmd BufWritePre * :%s/\s\+$//ge
