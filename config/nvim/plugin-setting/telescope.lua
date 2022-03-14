local telescope = require'telescope'
local builtin = require'telescope.builtin'

telescope.setup{
  defaults = {
    mappings = {
      n = {
        ["q"] = require('telescope.actions').close
      },
      i = {
        ["<cr>"] = { "<esc>", type = "command" }
      }
    },
    dynamic_preview_title = true
  },
  extensions = {
    fzf = {
      fuzzy = false,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    }
  }
}

require('telescope').load_extension('fzf')

vim.keymap.set('n', '<c-p>', require('telescope.builtin').find_files, { noremap = true, silent = true })
vim.keymap.set('n', ';g', require('telescope.builtin').live_grep, { noremap = true, silent = true })
vim.keymap.set('n', ';t', require('telescope.builtin').builtin, { noremap = true, silent = true })
