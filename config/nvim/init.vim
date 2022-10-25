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

call plug#begin()
Plug 'rebelot/kanagawa.nvim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
Plug 'machakann/vim-sandwich'
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
Plug 'windwp/nvim-autopairs'
Plug 'RRethy/nvim-treesitter-endwise'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'lambdalisue/fern.vim'
Plug 'kevinhwang91/nvim-hlslens'

Plug 'renerocksai/telekasten.nvim'
Plug 'renerocksai/calendar-vim'
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
  highlight = { enable = true },
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
let g:deepl#auth_key = $DEEPL_AUTH_KEY
vmap t<C-e> <Cmd>call deepl#v("EN")<CR>
vmap t<C-j> <Cmd>call deepl#v("JA")<CR>
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
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

set tagfunc=CocTagFunc
" }}}

" fern.vim {{{
nnoremap <space>f <Cmd>Fern . -reveal=%<cr>
" }}}

" telekasten.nvim {{{
lua << LUA
local home = vim.fn.expand("~/Documents/private/memo")

require('telekasten').setup({
  home = home,
    -- if true, telekasten will be enabled when opening a note within the configured home
  take_over_my_home = true,

  -- auto-set telekasten filetype: if false, the telekasten filetype will not be used
  --                               and thus the telekasten syntax will not be loaded either
  auto_set_filetype = true,

  -- dir names for special notes (absolute path or subdir name)
  dailies      = home .. '/' .. 'daily',
  weeklies     = home .. '/' .. 'weekly',
  templates    = home .. '/' .. 'templates',

  -- image (sub)dir for pasting
  -- dir name (absolute path or subdir name)
  -- or nil if pasted images shouldn't go into a special subdir
  image_subdir = "img",

  -- markdown file extension
  extension    = ".md",

  -- Generate note filenames. One of:
  -- "title" (default) - Use title if supplied, uuid otherwise
  -- "uuid" - Use uuid
  -- "uuid-title" - Prefix title by uuid
  -- "title-uuid" - Suffix title with uuid
  new_note_filename = "uuid",
  -- file uuid type ("rand" or input for os.date()")
  uuid_type = "%Y%m%d%H%M",
  -- UUID separator
  uuid_sep = "-",

  -- following a link to a non-existing note will create it
  follow_creates_nonexisting = true,
  dailies_create_nonexisting = true,
  weeklies_create_nonexisting = true,

  -- skip telescope prompt for goto_today and goto_thisweek
  journal_auto_open = false,

  -- template for new notes (new_note, follow_link)
  -- set to `nil` or do not specify if you do not want a template
  template_new_note = home .. '/' .. 'templates/new_note.md',

  -- template for newly created daily notes (goto_today)
  -- set to `nil` or do not specify if you do not want a template
  template_new_daily = home .. '/' .. 'templates/daily.md',

  -- template for newly created weekly notes (goto_thisweek)
  -- set to `nil` or do not specify if you do not want a template
  template_new_weekly= home .. '/' .. 'templates/weekly.md',

  -- image link style
  -- wiki:     ![[image name]]
  -- markdown: ![](image_subdir/xxxxx.png)
  image_link_style = "markdown",

  -- default sort option: 'filename', 'modified'
  sort = "filename",

  -- integrate with calendar-vim
  plug_into_calendar = true,
  calendar_opts = {
      -- calendar week display mode: 1 .. 'WK01', 2 .. 'WK 1', 3 .. 'KW01', 4 .. 'KW 1', 5 .. '1'
      weeknm = 4,
      -- use monday as first day of week: 1 .. true, 0 .. false
      calendar_monday = 1,
      -- calendar mark: where to put mark for marked days: 'left', 'right', 'left-fit'
      calendar_mark = 'left-fit',
  },

  -- telescope actions behavior
  close_after_yanking = false,
  insert_after_inserting = true,

  -- tag notation: '#tag', ':tag:', 'yaml-bare'
  tag_notation = "#tag",

  -- command palette theme: dropdown (window) or ivy (bottom panel)
  command_palette_theme = "ivy",

  -- tag list theme:
  -- get_cursor: small tag list at cursor; ivy and dropdown like above
  show_tags_theme = "ivy",

  -- when linking to a note in subdir/, create a [[subdir/title]] link
  -- instead of a [[title only]] link
  subdirs_in_links = true,

  -- template_handling
  -- What to do when creating a new note via `new_note()` or `follow_link()`
  -- to a non-existing note
  -- - prefer_new_note: use `new_note` template
  -- - smart: if day or week is detected in title, use daily / weekly templates (default)
  -- - always_ask: always ask before creating a note
  template_handling = "smart",

  -- path handling:
  --   this applies to:
  --     - new_note()
  --     - new_templated_note()
  --     - follow_link() to non-existing note
  --
  --   it does NOT apply to:
  --     - goto_today()
  --     - goto_thisweek()
  --
  --   Valid options:
  --     - smart: put daily-looking notes in daily, weekly-looking ones in weekly,
  --              all other ones in home, except for notes/with/subdirs/in/title.
  --              (default)
  --
  --     - prefer_home: put all notes in home except for goto_today(), goto_thisweek()
  --                    except for notes with subdirs/in/title.
  --
  --     - same_as_current: put all new notes in the dir of the current note if
  --                        present or else in home
  --                        except for notes/with/subdirs/in/title.
  new_note_location = "smart",

  -- should all links be updated when a file is renamed
  rename_update_links = true,

  vaults = {
      vault2 = {
          -- alternate configuration for vault2 here. Missing values are defaulted to
          -- default values from telekasten.
          -- e.g.
          -- home = "/home/user/vaults/personal",
      },
  },

  -- how to preview media files
  -- "telescope-media-files" if you have telescope-media-files.nvim installed
  -- "catimg-previewer" if you have catimg installed
  media_previewer = "telescope-media-files",
})
LUA
" }}}

" gitsigns.nvim {{{
lua << LUA
require('gitsigns').setup{
  current_line_blame = true,
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Actions
    map({'n', 'v'}, '<leader>hs', ':Gitsigns stage_hunk<CR>')
    map({'n', 'v'}, '<leader>hr', ':Gitsigns reset_hunk<CR>')
    map('n', '<leader>hS', gs.stage_buffer)
    map('n', '<leader>hu', gs.undo_stage_hunk)
    map('n', '<leader>hR', gs.reset_buffer)
    map('n', '<leader>hp', gs.preview_hunk)
    map('n', '<leader>hb', function() gs.blame_line{full=true} end)
    map('n', '<leader>tb', gs.toggle_current_line_blame)
    map('n', '<leader>hd', gs.diffthis)
    map('n', '<leader>hD', function() gs.diffthis('~') end)
    map('n', '<leader>td', gs.toggle_deleted)

    -- Text object
    map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end
}
LUA
" }}}

" nvim-hlslens {{{
lua require("hlslens").setup{}
" }}}
