let g:ippachi_ddc_normal_sources = ['nvim-lsp', 'file', 'around', 'buffer', 'rg']
let g:ippachi_ddc_cmdline_sources = ['cmdline', 'cmdline-history', 'around']

call ddc#custom#patch_global('sources', g:ippachi_ddc_normal_sources)

call ddc#custom#patch_global('sourceOptions', {
      \ '_': {
      \   'matchers': ['matcher_head'],
      \   'sorters': ['sorter_rank']},
      \ })

call ddc#custom#patch_global('sourceOptions', {
      \ 'around': {'mark': 'A'},
      \ 'nvim-lsp': {
      \   'mark': 'lsp',
      \   'forceCompletionPattern': '\.\w*|:\w*|->\w*' },
      \ 'file': {
      \   'mark': 'F',
      \   'isVolatile': v:true,
      \   'forceCompletionPattern': '\S/\S*',
      \ },
      \ 'rg': {'mark': 'rg', 'minAutoCompleteLength': 4,},
      \ 'cmdline': {'mark': 'cmdline'},
      \ 'cmdline-history': {'mark': 'history'},
      \ })

call ddc#custom#patch_global('completionMenu', 'pum.vim')
call ddc#custom#patch_global('autoCompleteEvents',
    \ ['InsertEnter', 'TextChangedI', 'TextChangedP', 'CmdlineChanged'])

nnoremap :       <Cmd>call CommandlinePre()<CR>:

function! CommandlinePre() abort
  " Overwrite sources
  let s:prev_buffer_config = ddc#custom#get_buffer()
  call ddc#custom#patch_buffer('sources', g:ippachi_ddc_cmdline_sources)

  autocmd User DDCCmdlineLeave ++once call CommandlinePost()

  " Enable command line completion
  call ddc#enable_cmdline_completion()
endfunction
function! CommandlinePost() abort
  " Restore sources
  call ddc#custom#set_buffer(s:prev_buffer_config)
endfunction

call pum#set_option('highlight_matches', 'Green')

call ddc#enable()
call signature_help#enable()
call popup_preview#enable()

noremap! <C-n>   <Cmd>call pum#map#insert_relative(+1)<CR>
noremap! <C-p>   <Cmd>call pum#map#insert_relative(-1)<CR>
noremap! <C-y>   <Cmd>call pum#map#confirm()<CR>
noremap! <C-e>   <Cmd>call pum#map#cancel()<CR>
inoremap <PageDown> <Cmd>call pum#map#insert_relative_page(+1)<CR>
inoremap <PageUp>   <Cmd>call pum#map#insert_relative_page(-1)<CR>
