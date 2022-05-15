lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "all",
  ignore_install = {
    "lalrpop",
    "gleam",
    "phpdoc",
  },
  sync_install = false,
  highlight = { enable = true, indent = true }
}
EOF
