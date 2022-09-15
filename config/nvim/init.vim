set autoindent
set noswapfile
set backup backupdir=~/.config/nvim/backup/
set cmdheight=2
set colorcolumn=120
set completeopt=menu,menuone,noselect
set cursorline
set expandtab tabstop=2 shiftwidth=2
set foldmethod=marker
set ignorecase smartcase
set number signcolumn=number
set pumblend=15
set pumheight=10
set splitright splitbelow
set termguicolors
set title
set undofile
set formatoptions-=ro
set formatoptions+=mM
set diffopt=internal,filler,algorithm:histogram,indent-heuristic
set updatetime=300

let mapleader=','

nnoremap j gj
nnoremap k gk
tnoremap <c-o> <c-\><c-n>

nmap <c-e> <c-e><SID>e
nnoremap <script> <SID>ee <c-e><SID>e
nmap <SID>e <Nop>

nmap <c-y> <c-y><SID>y
nnoremap <script> <SID>yy <c-y><SID>y
nmap <SID>y <Nop>

call plug#begin()
Plug 'rebelot/kanagawa.nvim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
Plug 'machakann/vim-sandwich'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'lewis6991/gitsigns.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'vim-test/vim-test'
Plug 'voldikss/vim-floaterm'
Plug 'pwntester/octo.nvim'
Plug 'kosayoda/nvim-lightbulb'
Plug 'ntpeters/vim-better-whitespace'
Plug 'ryicoh/deepl.vim'
Plug 'sindrets/diffview.nvim'
Plug 'lewis6991/satellite.nvim'
Plug 'windwp/nvim-autopairs'
Plug 'RRethy/nvim-treesitter-endwise'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

set rtp+=~/ghq/github.com/ippachi/nvim-sticky

" kanagawa.nvim {{{
colorscheme kanagawa
" }}}

" lualine.nvim {{{
lua require("lualine").setup()
" }}}

" nvim-treesitter {{{
lua << LUA
require("nvim-treesitter.configs").setup({
  ensure_installed = "all",
  ignore_install = { "phpdoc" },
  highlight = { enable = true },
})
LUA
" }}}

" nvim-tree.lua {{{
lua << LUA
require("nvim-tree").setup()

function open_nvim_tree()
  local previous_buf = vim.api.nvim_get_current_buf()
  require("nvim-tree").open_replacing_current_buffer(vim.fn.getcwd())
  require("nvim-tree").find_file(false, previous_buf)
end

vim.keymap.set("n", "<leader>f", open_nvim_tree, { noremap = true })


require"nvim-tree".setup {
  view = {
    mappings = {
      list = {
        { key = "<CR>", action = "edit_in_place" }
      }
    }
  }
}
LUA
" }}}

" gitsigns.nvim {{{
lua << LUA
require('gitsigns').setup({
  current_line_blame = true,
})
LUA
" }}}

" telescope.nvim {{{
command! LG Telescope live_grep
lua << LUA
require('telescope').setup {
  pickers = {
    oldfiles = {
      mappings = {
        i = {
          ["<C-l>"] = function() require('telescope.builtin').find_files() end
        }
      }
    },
    find_files = {
      mappings = {
        i = {
          ["<C-l>"] = function() require('telescope.builtin').oldfiles({ cwd_only = true }) end
        }
      }
    }
  }
}
vim.keymap.set('n', '<C-p>', require('telescope.builtin').find_files)
LUA
" }}}

" vim-test {{{
let g:test#ruby#minitest#file_pattern = '^test.*_spec\.rb'
let g:test#strategy = {
  \ 'nearest': 'basic',
  \ 'file':    'basic',
  \ 'suite':   'basic',
  \ }
nnoremap <leader>tn <cmd>TestNearest<cr>
nnoremap <leader>tf <cmd>TestFile<cr>
nnoremap <leader>tl <cmd>TestLast<cr>
" }}}

" octo.nvim {{{
lua require"octo".setup()
" }}}

" vim-better-whitespace {{{
augroup vimrc-better-whitespace
  autocmd!
  autocmd TermOpen * DisableWhitespace
augroup END
" }}}

" nvim-sticky {{{
lua vim.keymap.set('n', '<F2>', require('sticky').focus_sticky, { noremap = true })
" }}}

" deepl.vim {{{
let g:deepl#endpoint = "https://api-free.deepl.com/v2/translate"
let g:deepl#auth_key = "c03d8e1b-50d0-c9a3-943c-ec29906ae0fd:fx"
vmap t<C-e> <Cmd>call deepl#v("EN")<CR>
vmap t<C-j> <Cmd>call deepl#v("JA")<CR>
" }}}

" satellite.nvim {{{
lua require('satellite').setup()
" }}}

" nvim-autopairs {{{
lua require("nvim-autopairs").setup {}
" }}}

" nvim-treesitter-endwise {{{
lua require('nvim-treesitter.configs').setup { endwise = { enable = true } }
" }}}

" diffview.nvim {{{
lua << LUA
local actions = require("diffview.actions")

require("diffview").setup({
  keymaps = {
    file_panel = {
      ["q"] = function() vim.fn.execute("qa") end
    }
  }
})
LUA
" }}}

" ident-blankline.nvim {{{
lua << LUA
vim.cmd [[highlight IndentBlanklineIndent1 guifg=#E06C75 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent2 guifg=#E5C07B gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent3 guifg=#98C379 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent4 guifg=#56B6C2 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent5 guifg=#61AFEF gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent6 guifg=#C678DD gui=nocombine]]

require("indent_blankline").setup {
    space_char_blankline = " ",
    show_current_context = true,
    show_current_context_start = true
}
LUA
" }}}

" coc.nvim {{{
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

autocmd CursorHold * silent call CocActionAsync('highlight')

nmap <leader>rn <Plug>(coc-rename)

xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

nmap <leader>ac  <Plug>(coc-codeaction)
nmap <leader>cl  <Plug>(coc-codelens-action)

nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"

command! -nargs=0 Format :call CocActionAsync('format')
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')
" }}}
