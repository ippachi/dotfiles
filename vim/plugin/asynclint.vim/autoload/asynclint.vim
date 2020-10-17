let s:save_cpo = &cpo
set cpo&vim

function! asynclint#run() abort
  let b:asynclint_error_messages = []
  echom 'bundle exec rubocop --format emacs ' . expand('%')
  let b:asynclint_job = job_start('bundle exec rubocop --format json ' . expand('%'),
        \ #{
        \ out_cb: function('s:collect_message', [bufnr()]),
        \ exit_cb: function('s:on_finished_lint', [bufnr()])})
endfunction

function! s:collect_message(bufnr, _, error_content) abort
  call setbufvar(a:bufnr, 'async_lint_error_content', a:error_content)
endfunction

function! s:on_finished_lint(bufnr, _, code) abort
  call s:format_error(a:bufnr, b:async_lint_error_content)
endfunction

function! s:format_error(bufnr, content) abort
  return map(
        \ json_decode(a:content).files[0].offenses, {_, v -> #{
        \   location: #{
        \     start_lnum: v.location.start_line,
        \     end_lnum: v.location.last_line,
        \     start_col: v.location.start_column,
        \     end_col: v.location.last_column
        \   },
        \   name: v.cop_name,
        \   message: v.message,
        \   type: v.severity
        \ }}
        \ )
endfunction

" function! s:sign_place(bufnr) abort
"   let a = map(getbufvar(a:bufnr, 'async_error_list'), {v -> v.location})
"   echom a
" endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
