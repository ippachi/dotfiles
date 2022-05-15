call ddu#custom#patch_global({
    \ 'ui': 'ff',
    \ })

call ddu#custom#patch_global({
    \   'kindOptions': {
    \     'file': {
    \       'defaultAction': 'open',
    \     },
    \   }
    \ })

call ddu#custom#patch_global({
    \   'sourceOptions': {
    \     '_': {
    \       'matchers': ['matcher_substring'],
    \     },
    \   }
    \ })

call ddu#custom#patch_global({
    \   'uiParams': {
    \     'ff': {
    \       'startFilter': v:true,
    \       'split': 'floating',
    \       'floatingBorder': 'single',
    \       'reversed': v:false,
    \       'filterSplitDirection': 'floating',
    \       'filterFloatingPosition': 'top',
    \     },
    \   }
    \ })

call ddu#custom#patch_global({
    \   'sourceParams' : {
    \     'rg' : {
    \       'args': ['--column', '--no-heading', '--color', 'never'],
    \     },
    \   },
    \ })

call ddu#custom#alias('source', 'file_rg', 'file_external')

call ddu#custom#patch_global('sourceParams', {
  \   'file_rg': {
  \     'cmd': ['rg', '--files', '--color', 'never']
  \   },
  \ })

autocmd FileType ddu-ff call s:ddu_ff_my_settings()
function! s:ddu_ff_my_settings() abort
  nnoremap <buffer> <CR>
  \ <Cmd>call ddu#ui#ff#do_action('itemAction')<CR>
  nnoremap <buffer> <Space>
  \ <Cmd>call ddu#ui#ff#do_action('toggleSelectItem')<CR>
  nnoremap <buffer> i
  \ <Cmd>call ddu#ui#ff#do_action('openFilterWindow')<CR>
  nnoremap <buffer> q
  \ <Cmd>call ddu#ui#ff#do_action('quit')<CR>
endfunction

autocmd FileType ddu-ff-filter call s:ddu_filter_my_settings()
function! s:ddu_filter_my_settings() abort
  inoremap <buffer> <CR>
  \ <Esc><Cmd>close<CR>
  nnoremap <buffer> <CR>
  \ <Cmd>close<CR>
  nnoremap <buffer> q
  \ <Cmd>call ddu#ui#ff#do_action('quit')<CR>
endfunction

nnoremap <c-p> <cmd>Ddu file_old file_rg<cr>
