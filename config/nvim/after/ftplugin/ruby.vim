if exists('b:did_ftplugin_ruby')
  finish
endif

setlocal isk+=@-@,?

let b:did_ftplugin_ruby = 1
