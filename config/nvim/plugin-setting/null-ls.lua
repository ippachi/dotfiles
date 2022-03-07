local util = require 'lspconfig/util'

require("null-ls").setup({
  root_dir = util.root_pattern("Gemfile", ".null-ls-root", "Makefile", ".git"),
  sources = {
    require("null-ls").builtins.diagnostics.rubocop.with({
      command = "bundle",
      args = { "exec", "rubocop", "-f", "json", "--stdin", "$FILENAME" }
    }),
    require("null-ls").builtins.formatting.rubocop.with({
      command = "bundle",
      args = { "exec", "rubocop", "--auto-correct", "-f", "quiet", "--stderr", "--stdin", "$FILENAME" }
    })
  },
})
