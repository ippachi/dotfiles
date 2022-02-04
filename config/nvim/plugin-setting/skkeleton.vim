imap <C-j> <Plug>(skkeleton-enable)
cmap <C-j> <Plug>(skkeleton-enable)

augroup vimrc_eskk
  autocmd!
  autocmd User skkeleton-enable-post lmap <buffer> l <Plug>(skkeleton-disable)
augroup END

call skkeleton#config({
      \ 'globalJisyo': '~/.local/share/skk/SKK-JISYO.L',
      \ 'userJisyo': '~/.local/share/skk/skk-jisyo'
      \ })
