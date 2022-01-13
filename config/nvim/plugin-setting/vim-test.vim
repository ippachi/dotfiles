nnoremap <leader>tn :TestNearest<cr><c-\><c-n><c-w>p
nnoremap <leader>tl <cmd>TestLast<cr>
nnoremap <leader>tf :TestFile<cr><c-\><c-n><c-w>p
nnoremap <leader>ts <cmd>TestSuite<cr>

let g:test#ruby#minitest#file_pattern = '^test.*_spec\.rb'
let g:test#strategy = {
  \ 'nearest': 'neovim',
  \ 'file':    'neovim',
  \ 'suite':   'basic',
  \ }
