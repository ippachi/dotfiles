lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "all",
  ignore_install = {
    "lalrpop",
    "gleam"
  },
  sync_install = false,
  highlight = { enable = false }
}
EOF
