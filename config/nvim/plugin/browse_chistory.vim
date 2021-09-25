let s:save_cpo = &cpo
set cpo&vim

if exists("g:loaded_browse_chistory")
  finish
endif
let g:loaded_browse_chistory = 1

command! BrowseChistory call browse_chistory#open()

let &cpo = s:save_cpo
unlet s:save_cpo
