if exists('b:did_ftplugin_ruby')
  finish
endif

setlocal isk+=@-@,?
command! -buffer -nargs=0 GrepMethod vim /\s*\zs\(def\ze \|private\)/ %
command! -buffer -nargs=0 RefMethod grep '\.<cword>'

let b:did_ftplugin_ruby = 1
