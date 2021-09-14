if exists('b:did_ftplugin_git')
  finish
endif

function! s:line_branch_name(_, line_num)
  return trim(getline(a:line_num))
endfunction

function! s:delete_branch(start_line_num, end_line_num, bang) abort
  let l:delete_branches = map(range(a:start_line_num, a:end_line_num), function('s:line_branch_name'))

  if a:bang == '!'
    let l:delete_command = 'Git branch -D ' . join(l:delete_branches)
  else
    let l:delete_command = 'Git branch -d ' . join(l:delete_branches)
  endif
  exec l:delete_command
endfunction

command! -bang -buffer -range DeleteBranch call <SID>delete_branch(<line1>, <line2>, <q-bang>) | Git ++curwin branch

let b:did_ftplugin_git = 1
