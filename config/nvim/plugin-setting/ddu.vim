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
    \ 'sources': [{'name': 'file', 'params': {}}],
    \ })

nnoremap <leader>q <cmd>call ddu#start({})<cr>

function s:ddu_ui_mappings() abort
  nnoremap <buffer><silent> i <Cmd>call ddu#ui#ff#do_action('openFilterWindow')<CR>
endfunction

autocmd FileType ddu-ff call s:ddu_ui_mappings()
