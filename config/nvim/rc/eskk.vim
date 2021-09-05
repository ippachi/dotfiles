let g:eskk#dictionary = {
\	'path': "~/.local/share/skk/skk-jisyo",
\	'sorted': 0,
\	'encoding': 'utf-8',
\}

let g:eskk#large_dictionary = {
\	'path': "~/.local/share/skk/SKK-JISYO.L",
\	'sorted': 1,
\	'encoding': 'euc-jp',
\}

let g:eskk#enable_completion = 0

augroup vimrc-eskk
  autocmd!
  autocmd User eskk-enable-post lmap <buffer> l <Plug>(eskk:disable)
augroup END