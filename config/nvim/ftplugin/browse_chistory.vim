if exists('b:did_ftplugin')
  finish
endif

nnoremap <buffer> <cr> <cmd>call <SID>apply_change_chistory()<cr>

function! s:apply_change_chistory() abort
  let l:current_line = getline(line('.'))
  if match(l:current_line, '^>') != -1
    bd
    return
  endif

  let l:chistory_number = matchstr(l:current_line, '^\s*error list \zs\d\+\ze of')
  exec l:chistory_number . 'chistory'
  bd
  copen
endfunction

let b:did_ftplugin = 1
