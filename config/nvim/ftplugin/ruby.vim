if exists("b:did_ftplugin")
  finish
endif
command! -buffer -nargs=0 GrepMethod vim /\s*\zs\(def\ze \|private\)/ %
let b:did_ftplugin = 1
