local builtin = require'telescope.builtin'
vim.keymap.set('n', '<c-p>', builtin.find_files, { noremap = true })
vim.keymap.set('n', '<leader>eg', builtin.git_status, { noremap = true })
vim.keymap.set('n', '<leader>er', builtin.resume, { noremap = true })
vim.keymap.set('n', '<leader>eo', function() builtin.oldfiles({ only_cwd = true }) end, { noremap = true })

require('telescope').setup{
  defaults = {
    mappings = {
      n = {
        ["q"] = require('telescope.actions').close
      }
    }
  }
}
