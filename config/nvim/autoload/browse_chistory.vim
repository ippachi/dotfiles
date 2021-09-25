function! browse_chistory#open() abort
  let l:content = ''
  redir => l:content
  silent chistory
  redir END
  new
  call setline(1, split(l:content, '\n'))
  setlocal buftype=nofile nomodifiable
  setlocal ft=browse_chistory
endfunction
