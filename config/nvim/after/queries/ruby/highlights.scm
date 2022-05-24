(call
  method: (identifier) @keyword.return
   (#vim-match? @keyword.return "^sig$"))

(call
  method: (identifier) @sorbet-sig
  (#vim-match? @sorbet-sig "^sig$")
    block: (_
             [
              (call
               (call
                 (identifier) @keyword.return)?
                 (identifier) @keyword.return)
              (identifier) @keyword.return
              ]))

