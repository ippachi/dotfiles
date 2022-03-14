" call ddu#custom#patch_global({
"     \ 'ui': 'ff',
"     \ })
"
" call ddu#custom#patch_global({
"     \   'uiParams': {
"     \     'ff': {
"     \       'startFilter': v:true,
"     \       'filterSplitDirection': 'floating',
"     \       'previewVertical': v:true,
"     \       'previewWidth': 80
"     \     }
"     \   }
"     \ })
"
" call ddu#custom#patch_global({
"     \   'kindOptions': {
"     \     'file': {
"     \       'defaultAction': 'open',
"     \     },
"     \   }
"     \ })
"
" call ddu#custom#patch_global({
"     \   'sourceOptions': {
"     \     '_': {
"     \       'matchers': ['matcher_substring'],
"     \       'ignoreCase': v:true
"     \     },
"     \   }
"     \ })
"
" call ddu#custom#alias('source', 'git_ls_files', 'file_external')
" call ddu#custom#patch_global('sourceParams', {
"   \   'git_ls_files': {
"   \     'cmd': ['git', 'ls-files']
"   \   },
"   \   'rg' : {
"   \     'args': ['--column', '--no-heading', '--color', 'never'],
"   \   },
"   \ })
"
" call ddu#custom#alias('source', 'rg_files', 'file_external')
" call ddu#custom#patch_global('sourceParams', {
"   \   'rg_files': {
"   \     'cmd': ['rg', '--files', '--color', 'never']
"   \   },
"   \ })
"
" function! s:ddu_ff_mappings() abort
"   nnoremap <buffer><silent> <CR> <Cmd>call ddu#ui#ff#do_action('itemAction')<CR>
"   nnoremap <buffer><silent> <Space> <Cmd>call ddu#ui#ff#do_action('toggleSelectItem')<CR>
"   nnoremap <buffer><silent> i <Cmd>call ddu#ui#ff#do_action('openFilterWindow')<CR>
"   nnoremap <buffer><silent> q <Cmd>call ddu#ui#ff#do_action('quit')<CR>
"   nnoremap <buffer><silent> p <Cmd>call ddu#ui#ff#do_action('preview')<CR>
" endfunction
"
" function! s:ddu_filter_mappings() abort
"   inoremap <buffer><silent> <CR> <Esc><Cmd>close<CR>
"   nnoremap <buffer><silent> <CR> <Cmd>close<CR>
"   nnoremap <buffer><silent> q <Cmd>call ddu#ui#ff#do_action('quit')<CR>
"   inoremap <buffer><silent> <c-l> <Cmd>call ddu#ui#ff#do_action('updateOptions', { 'sources': [{'name': 'rg_files'}] })<CR>
" endfunction
"
" augroup ddu-ff
"   autocmd!
"   autocmd FileType ddu-ff call s:ddu_ff_mappings()
"   autocmd FileType ddu-ff-filter call s:ddu_filter_mappings()
" augroup END
"
" nnoremap <c-p> <Cmd>Ddu `finddir('.git', ';') != '' ? 'git_ls_files' : 'rg_files'`<cr>
