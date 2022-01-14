let g:lexima_accept_pum_with_enter = 0

call lexima#set_default_rules()

call lexima#add_rule({
      \   'char': '(',
      \   'at': '\%#\w',
      \   'input': '('
      \ })

call lexima#add_rule({
      \   'char': '''',
      \   'at': '\%#\w',
      \   'input': ''''
      \ })
