" let test#ruby#minitest#executable = 'bundle exec rake test VIM=1'
let g:dispatch_compilers = {'bundle exec': ''}
command! -nargs=0 TestRunnerMinitest let test#ruby#minitest#file_pattern = '_spec\.rb'

let test#ruby#minitest#file_pattern = 'test\/.*_spec\.rb'
let test#strategy = {
  \ 'nearest': 'neovim',
  \ 'file':    'neovim',
  \ 'suite':   'basic',
\}
