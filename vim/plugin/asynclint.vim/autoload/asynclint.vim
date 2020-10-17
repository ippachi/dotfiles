let s:save_cpo = &cpo
set cpo&vim

function! asynclint#run() abort
  let b:asynclint_error_messages = []
  let b:asynclint_job = job_start('bundle exec rubocop --format json ' . expand('%'),
        \ #{
        \ out_cb: function('s:collect_message', [bufnr()]),
        \ exit_cb: function('s:on_finished_lint', [bufnr()])})
endfunction

function! s:collect_message(bufnr, _, error_content) abort
  call setbufvar(a:bufnr, 'async_lint_error_content', a:error_content)
endfunction

function! s:on_finished_lint(bufnr, _, code) abort
  let asynclint_errors = s:format_error_for_sign(a:bufnr, b:async_lint_error_content)
  call s:sign_place(a:bufnr, asynclint_errors)
endfunction

function! s:format_error_for_sign(bufnr, content) abort
  let asynclint_errors = []
  echom json_decode(a:content).files[0].offenses[0]
  for error in json_decode(a:content).files[0].offenses
    call add(asynclint_errors, #{id: 0, name: "AsynctestErrorSign", buffer: a:bufnr, lnum: error.location.start_line, group: 'asynclint'})
  endfor
  echom asynclint_errors
  return uniq(asynclint_errors)
endfunction

function! s:sign_place(bufnr, errors) abort
  call sign_placelist(a:errors)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
