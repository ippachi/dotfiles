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
  let async_lint_error_content = getbufvar(a:bufnr, "async_lint_error_content")
  let asynclint_errors = s:format_error(a:bufnr, getbufvar(a:bufnr, "async_lint_error_content"))
  call s:update_sign(a:bufnr, asynclint_errors)
endfunction

function! s:format_error(bufnr, content) abort
  return map(json_decode(a:content).files[0].offenses,
        \ { _, v ->
        \   #{
        \     severity: v.severity,
        \     message: v.message,
        \     location: #{
        \       start_lnum: v.location.start_line,
        \       last_lnum: v.location.last_line,
        \       start_col: v.location.column,
        \       last_col: v.location.last_column,
        \     }
        \   }
        \})
endfunction

function! s:update_sign(bufnr, errors) abort
  echom a:errors[0].location
  let a = map(a:errors, { _, v -> #{id: 0, name: "AsynctestErrorSign", buffer: a:bufnr, lnum: v.location.start_line, group: "asynclint"} })
  echom a
  call sign_placelist(map(a:errors, { _, v -> #{id: 0, name: "AsynctestErrorSign", buffer: a:bufnr, lnum: v.location.start_line, group: "asynclint"} }))
endfunction
" function! s:format_error_for_sign(bufnr, content) abort
"   let asynclint_errors = []
"   let sign_list = sign_getplaced(a:bufnr, #{group: "asynclint"})[0].signs
"   let lint_errors = json_decode(a:content).files[0].offenses
"
"   let sign_list_len = len(sign_list)
"   let lint_errors_len = len(lint_errors)
"
"   let i = 0
"   let j = 0
"
"   while i < sign_list_len || j < lint_errors_len
"     if i < sign_list_len
"       let sign_lnum = sign_list[i].lnum
"     endif
"
"     if j < lint_errors_len
"       let lint_lnum = lint_errors[j]
"       echom lint_lnum
"     endif
"
"     if get(l:, "sign_lnum", -1) == get(l:, "lint_lnum", -1)
"       let i += 1
"       let j += 1
"     endif
"
"   " for error in json_decode(a:content).files[0].offenses
"   "   call add(asynclint_errors, #{id: 0, name: "AsynctestErrorSign", buffer: a:bufnr, lnum: error.location.start_line, group: 'asynclint'})
"   " endfor
"
"   return uniq(asynclint_errors)
" endfunction

function! s:diff_sign_lnum(bufnr, next_sign)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
