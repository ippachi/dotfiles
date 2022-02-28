local telescope = require'telescope'
local builtin = require'telescope.builtin'

telescope.setup{
  defaults = {
    mappings = {
      n = {
        ["q"] = require('telescope.actions').close
      }
    },
    dynamic_preview_title = true
  }
}

telescope.load_extension('termfinder')

vim.api.nvim_set_keymap('n', '<c-p>',  [[<Cmd>lua require('telescope.builtin').find_files()<CR>]], { noremap = true, silent = true })
