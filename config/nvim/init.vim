let g:ippachi_completion_env = "coc"
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
set noswapfile
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

if finddir('.git', '.;') != ''
  set grepprg=git\ grep\ --perl-regexp\ --line-number\ --column
  set grepformat=%f:%l:%c:%m,%f:%l:%m
elseif executable('rg')
  set grepprg=rg\ --vimgrep\ --smart-case\ --pcre2
  set grepformat=%f:%l:%c:%m,%f:%l:%m
end

let mapleader=','

packadd Cfilter

let loaded_matchparen = 1
" }}}

" Base mappings {{{
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k
nnoremap Y y$
nnoremap \ ,
cnoremap <c-x> <C-r>=expand('%')<cr>
tnoremap <c-o> <c-\><c-n>
vnoremap p "_dP
nnoremap gh gT
nnoremap gl gt

nnoremap <s-left> <cmd>-tabmove<cr>
nnoremap <s-right> <cmd>+tabmove<cr>

" 矯正用
" <c-h>を<bs>として使わないようにする
noremap <expr> <c-h> ':h '
noremap! <expr> <c-h> ':h '
tnoremap <expr> <c-h> ':h '
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

augroup vimrc-local
  autocmd!
  autocmd BufNewFile,BufReadPost * call s:vimrc_local(expand('<afile>:p:h'))
augroup END

function! s:vimrc_local(loc)
  let l:token_path = expand('~/.local/share/vimrc-local/token')
  if !filereadable(l:token_path)
    return
  endif

  let l:token = readfile(l:token_path)[0]

  let files = findfile('.vimrc.local', escape(a:loc, ' ') . ';', -1)
  for i in reverse(filter(files, 'filereadable(v:val)'))
    if readfile(i)[0] == l:token
      source `=i`
    endif
  endfor
endfunction
" }}}

" Base command{{{
command! -complete=customlist,ListPluginSetting -nargs=1 ReloadPluginSetting luafile ~/.config/nvim/plugin-setting/<args>

function! ListPluginSetting(a,l,p) abort
  let l:absolute_paths = split(glob('~/.config/nvim/plugin-setting/*'), '\n')
  return map(copy(l:absolute_paths), {_, val -> split(val, '/')[-1]})
endfunction
" }}}

call plug#begin()
Plug 'sainnhe/gruvbox-material'
Plug 'machakann/vim-sandwich'
Plug 'machakann/vim-textobj-delimited'
Plug 'kana/vim-altr'
Plug 'thinca/vim-quickrun'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-lualine/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'lewis6991/gitsigns.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'haringsrob/nvim_context_vt'
Plug 'cohama/lexima.vim'
Plug 'lambdalisue/fern.vim'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'machakann/vim-swap'
Plug 'akinsho/toggleterm.nvim'
Plug 'vim-denops/denops.vim'
Plug 'vim-skk/skkeleton'
Plug 'prettier/vim-prettier'
Plug 'lambdalisue/guise.vim'
Plug 'rbtnn/vim-diffnotify'
Plug 'hashivim/vim-terraform'
Plug 'lambdalisue/gin.vim'
Plug 'TimUntersberger/neogit'
Plug 'sindrets/diffview.nvim'

Plug 'Shougo/ddu.vim'
Plug 'Shougo/ddu-ui-ff'
Plug 'Shougo/ddu-kind-file'
Plug 'Shougo/ddu-filter-matcher_substring'
Plug 'Shougo/ddu-source-file_rec'
Plug 'matsui54/ddu-source-file_external'
Plug 'shun/ddu-source-buffer'
Plug 'shun/ddu-source-rg'
Plug 'Shougo/ddu-commands.vim'

Plug 'vim-test/vim-test'
Plug 'rcarriga/vim-ultest'

if g:ippachi_completion_env == "nvimlsp"
  Plug 'williamboman/nvim-lsp-installer'
  Plug 'neovim/nvim-lspconfig'
  Plug 'kosayoda/nvim-lightbulb'
  Plug 'onsails/lspkind-nvim'
  Plug 'jose-elias-alvarez/null-ls.nvim'

  Plug 'hrsh7th/nvim-cmp'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/cmp-cmdline'
  Plug 'hrsh7th/cmp-vsnip'
  Plug 'hrsh7th/vim-vsnip'
  Plug 'lukas-reineke/cmp-rg'
  Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
else
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
endif
call plug#end()

packadd cfilter

runtime! plugin-setting/*.vim plugin-setting/*.lua

colorscheme gruvbox-material
