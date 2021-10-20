 let s:save_cpo = &cpo
 set cpo&vim

 if exists("g:loaded_ruby_lsp_autostart")
   finish
 endif
 let g:loaded_ruby_lsp_autostart = 1

 augroup ruby-lsp-autostart
   autocmd!
   " autocmd BufEnter *.rb call g:ruby_lsp_autostart#start_lsp_client()
 augroup END

 let &cpo = s:save_cpo
 unlet s:save_cpo
