let g:deepl#endpoint = 'https://api-free.deepl.com/v2/translate'
let s:auth_key_path = $HOME . '/.local/share/deepl/authkey'

if !filereadable(s:auth_key_path)
  finish
endif

let g:deepl#auth_key = readfile(s:auth_key_path)[0]

vmap t<C-j> <Cmd>call deepl#v("JA")<CR>
vmap t<C-e> <Cmd>call deepl#v("EN")<CR>
