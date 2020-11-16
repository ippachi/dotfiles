set encoding=utf-8
scriptencoding utf-8
" =======================================================================================
" vim-default-settings
" =======================================================================================

filetype plugin indent on
syntax enable set title
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
set list listchars=tab:^\ ,trail:_,extends:>,precedes:<,eol:$
set backspace=indent,eol,start
set breakindent
set number
set signcolumn=number
set completeopt=menuone,noinsert,noselect
set fileencodings=utf-8,cp932,shift-jis,euc-jp
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

let mapleader = ','

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
nnoremap <silent> <Esc><Esc> <cmd>nohlsearch<CR>
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
  autocmd ColorScheme * highlight ZenkakuSpace ctermfg=237 ctermbg=237 guifg=#D9D9D9 guibg=#730B00
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

" surround
Plug 'tpope/vim-surround'

" alignment
Plug 'junegunn/vim-easy-align'

" diffline
Plug 'AndrewRadev/linediff.vim'

" for writing
Plug 'junegunn/goyo.vim'

" treesitter
Plug 'nvim-treesitter/nvim-treesitter'
" Plug 'nvim-treesitter/completion-treesitter'

" auto completion
Plug 'nvim-lua/completion-nvim'

" lsp
Plug 'neovim/nvim-lspconfig'

" filer
Plug 'lambdalisue/fern.vim'

" snippet
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'

Plug 'aca/completion-tabnine', { 'do': './install.sh' }

" spell checker
Plug 'kamykn/spelunker.vim'

" test runner
Plug 'vim-test/vim-test'

Plug 'neomake/neomake'

Plug 'vim-ruby/vim-ruby'

Plug 'steelsojka/completion-buffers'
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
  \     [ 'usa_president_2020', 'filetype', 'fileencoding', 'lineinfo', 'percent' ]
  \   ],
  \   'component_function': {
  \     'usa_president_2020': 'usa_president_2020#status',
  \   },
  \ }
\ }

" ctrlp
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
let g:ctrlp_types = ['mru', 'fil', 'buf']

" gitgutter
let g:gitgutter_map_keys = 0
nmap <leader>hp <Plug>(GitGutterPreviewHunk)
nmap <leader>hu <Plug>(GitGutterUndoHunk)

" vim-easy-align
xmap ga <Plug>(EasyAlign)

" treesitter
lua <<EOS
require'nvim-treesitter.configs'.setup {
  ensure_installed = "all",     -- one of "all", "language", or a list of languages
  highlight = {
    enable = true,              -- false will disable the whole extension
  },
}
EOS

" completion-nvim
let g:completion_chain_complete_list = {
      \'default' : {
      \ 'default' : [
      \  {'complete_items' : ['lsp', 'snippet']},
      \  {'mode' : 'file'}
      \ ],
      \ 'comment' : [],
      \ 'string' : []
      \ },
      \ 'go': [
      \   {'complete_items' : ['lsp', 'snippet']}
      \ ],
      \ 'ruby': [
      \   {'complete_items' : ['lsp', 'snippet', 'buffers']}
      \ ]
      \}

augroup completion-nvim
  autocmd!
  autocmd BufEnter * lua require'completion'.on_attach()
augroup END

let g:completion_confirm_key = "\<c-y>"

inoremap <cr> <c-x><cr>


" lsp
lua <<EOS
local lspconfig = require'lspconfig'

lspconfig.gopls.setup{
  capabilities = {
    textDocument = {
      completion = {
        completionItem = {
          snippetSupport = true
        }
      }
    }
  },
  settings = {
    gopls = {
      usePlaceholders = true
    }
  }
}
lspconfig.sumneko_lua.setup{}
lspconfig.pyls.setup{}
lspconfig.intelephense.setup{}
lspconfig.vimls.setup{}
lspconfig.solargraph.setup{}

lspconfig.diagnosticls.setup{
  filetypes = { "markdown", "ruby", "vim" },
  init_options = {
    filetypes = {
      markdown = "textlint",
      ruby = "rubocop",
      vim = "vint"
    },
    linters = {
      textlint = {
        sourceName = "textlint",
        command = "textlint",
        args = {
          "--stdin",
          "--stdin-filename",
          "%filepath",
          "--format",
          "json"
        },
        parseJson = {
          errorsRoot = "[0].messages",
          line = "line",
          column = "column",
          security = "severity",
          message = "${ruleId} ${message}"
        }
      },
      rubocop = {
        sourceName = "rubocop",
        command = "rubocop",
        args = {
          "--stdin",
          "%filepath",
          "--format",
          "json",
          "--force-exclusion"
        },
        parseJson = {
          errorsRoot = "files[0].offenses",
          line = "location.line",
          endLine = "location.last_line",
          column = "location.column",
          endColumn = "location.last_column",
          security = "severity",
          message = "${cop_name} ${message}"
        },
        securities = {
          convention = "info"
        }
      },
      vint = {
        sourceName = "vint",
        command = "vint",
        args = {
          "-",
          "--json",
          "--enable-neovim"
        },
        parseJson = {
          errorsRoot = "",
          line = "line_number",
          column = "column_number",
          severity = "severity",
          message = "${policy_name} ${description}"
        }
      }
    },
    formatters = {
      rubocop = {
        command = "rubocop",
        args = {
          "--stdin",
          "%filepath",
          "-a",
          "--force-exclusion"
        }
      }
    }
  }
}
EOS

command! Format lua vim.lsp.buf.formatting()

nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>

augroup vimrc-auto-format
  autocmd!
  autocmd BufWritePre *.go lua vim.lsp.buf.formatting_sync()
augroup END

" snippet
let g:UltiSnipsExpandTrigger='<c-k>'
let g:UltiSnipsJumpForwardTrigger='<c-k>'
let g:UltiSnipsJumpBackwardTrigger='<c-j>'
let g:completion_enable_snippet = 'UltiSnips'

" vim-vsnip
" Expand or jump
imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'

" vim-test
nnoremap <silent> <leader>tn :TestNearest<cr>
nnoremap <silent> <leader>tl :TestLast<cr>
nnoremap <silent> <leader>tf :TestFile<cr>
