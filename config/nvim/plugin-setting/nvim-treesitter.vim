lua <<EOF
require'nvim-treesitter.configs'.setup {
  sync_install = true,
  highlight = { enable = true, indent = true }
}
EOF
