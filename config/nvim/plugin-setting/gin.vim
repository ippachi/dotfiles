nnoremap <leader>gs <cmd>tabnew\|GinStatus<cr>

function! s:gin_status_mapping() abort
  nnoremap <buffer> q <cmd>tabc<cr>
endfunction

augroup vimrc-ginn-mappings
  autocmd!
  autocmd FileType gin-status call <SID>gin_status_mapping()
augroup END
