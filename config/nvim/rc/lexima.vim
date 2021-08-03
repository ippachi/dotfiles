let g:lexima_accept_pum_with_enter = 0
call lexima#clear_rules()
let g:lexima#default_rules = [
\ {'char': '(', 'input_after': ')', 'except': '\%#\w'},
\ {'char': '(', 'at': '\\\%#'},
\ {'char': ')', 'at': '\%#)', 'leave': 1},
\ {'char': '<BS>', 'at': '(\%#)', 'delete': 1},
\ {'char': '{', 'input_after': '}', 'except': '\%#\w'},
\ {'char': '}', 'at': '\%#}', 'leave': 1},
\ {'char': '<BS>', 'at': '{\%#}', 'delete': 1},
\ {'char': '[', 'input_after': ']', 'except': '\%#\w'},
\ {'char': '[', 'at': '\\\%#'},
\ {'char': ']', 'at': '\%#]', 'leave': 1},
\ {'char': '<BS>', 'at': '\[\%#\]', 'delete': 1},
\ ]

let g:lexima#default_rules += [
\ {'char': '"', 'input_after': '"', 'except': '\%#\w'},
\ {'char': '"', 'at': '\%#"', 'leave': 1},
\ {'char': '"', 'at': '\\\%#'},
\ {'char': '"', 'at': '^\s*\%#', 'filetype': 'vim'},
\ {'char': '"', 'at': '\%#\s*$', 'filetype': 'vim'},
\ {'char': '<BS>', 'at': '"\%#"', 'delete': 1},
\ {'char': '"', 'at': '""\%#', 'input_after': '"""'},
\ {'char': '"', 'at': '\%#"""', 'leave': 3},
\ {'char': '<BS>', 'at': '"""\%#"""', 'input': '<BS><BS><BS>', 'delete': 3},
\ {'char': "'", 'input_after': "'", 'except': '\%#\w'},
\ {'char': "'", 'at': '\%#''', 'leave': 1},
\ {'char': "'", 'at': '\w\%#''\@!'},
\ {'char': "'", 'at': '\\\%#'},
\ {'char': "'", 'at': '\\\%#', 'leave': 1, 'filetype': ['vim', 'sh', 'csh', 'ruby', 'tcsh', 'zsh']},
\ {'char': "'", 'filetype': ['haskell', 'lisp', 'clojure', 'ocaml', 'reason', 'scala', 'rust']},
\ {'char': '<BS>', 'at': "'\\%#'", 'delete': 1},
\ {'char': "'", 'at': "''\\%#", 'input_after': "'''"},
\ {'char': "'", 'at': "\\%#'''", 'leave': 3},
\ {'char': '<BS>', 'at': "'''\\%#'''", 'input': '<BS><BS><BS>', 'delete': 3},
\ {'char': '`', 'input_after': '`'},
\ {'char': '`', 'at': '\%#`', 'leave': 1},
\ {'char': '<BS>', 'at': '`\%#`', 'delete': 1},
\ {'char': '`', 'filetype': ['ocaml', 'reason']},
\ {'char': '`', 'at': '``\%#', 'input_after': '```'},
\ {'char': '`', 'at': '\%#```', 'leave': 3},
\ {'char': '<BS>', 'at': '```\%#```', 'input': '<BS><BS><BS>', 'delete': 3},
\ ]

let g:lexima#newline_rules = [
\ {'char': '<CR>', 'at': '(\%#)', 'input_after': '<CR>'},
\ {'char': '<CR>', 'at': '(\%#$', 'input_after': '<CR>)', 'except': '\C\v^(\s*)\S.*%#\n%(%(\s*|\1\s.+)\n)*\1\)'},
\ {'char': '<CR>', 'at': '{\%#}', 'input_after': '<CR>'},
\ {'char': '<CR>', 'at': '{\%#$', 'input_after': '<CR>}', 'except': '\C\v^(\s*)\S.*%#\n%(%(\s*|\1\s.+)\n)*\1\}'},
\ {'char': '<CR>', 'at': '\[\%#]', 'input_after': '<CR>'},
\ {'char': '<CR>', 'at': '\[\%#$', 'input_after': '<CR>]', 'except': '\C\v^(\s*)\S.*%#\n%(%(\s*|\1\s.+)\n)*\1\]'},
\ ]

let g:lexima#space_rules = [
\ {'char': '<Space>', 'at': '(\%#)', 'input_after': '<Space>'},
\ {'char': ')', 'at': '\%# )', 'leave': 2},
\ {'char': '<BS>', 'at': '( \%# )', 'delete': 1},
\ {'char': '<Space>', 'at': '{\%#}', 'input_after': '<Space>'},
\ {'char': '}', 'at': '\%# }', 'leave': 2},
\ {'char': '<BS>', 'at': '{ \%# }', 'delete': 1},
\ {'char': '<Space>', 'at': '\[\%#]', 'input_after': '<Space>'},
\ {'char': ']', 'at': '\%# ]', 'leave': 2},
\ {'char': '<BS>', 'at': '\[ \%# ]', 'delete': 1},
\ ]

call lexima#set_default_rules()

call lexima#add_rule({
  \   'char': '<Bar>',
  \   'at': 'do \%#',
  \   'input': '<Bar><Bar><Left>',
  \   'filetype': ['ruby']
  \ })

call lexima#add_rule({
  \   'char': '<Bar>',
  \   'at': 'do |.*\%#|',
  \   'input': '<Right>',
  \   'filetype': ['ruby']
  \ })
