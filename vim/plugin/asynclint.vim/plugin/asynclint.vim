if exists("g:loaded_asynclint")
  finish
endif
let g:loaded_asynclint = 1
let s:save_cpo = &cpo
set cpo&vim

call sign_define([
      \ #{name: "AsynctestErrorSign", text: ">>"}
      \ ])

augroup asynclint
  autocmd!
  autocmd BufWritePre *.rb call asynclint#run()
augroup END

let &cpo = s:save_cpo
unlet s:save_cpo
