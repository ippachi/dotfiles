call ddc#custom#patch_global('sources', ['nvim-lsp', 'file', 'yank', 'around', 'rg'])

call ddc#custom#patch_global('sourceOptions', {
      \ '_': {
      \   'matchers': ['matcher_head'],
      \   'sorters': ['sorter_rank']},
      \ 'around': {'mark': 'A'},
      \ 'nvim-lsp': {
      \   'mark': 'lsp',
      \   'forceCompletionPattern': '\.\w*|:\w*|->\w*' },
      \ 'file': {
      \   'mark': 'F',
      \   'isVolatile': v:true,
      \   'forceCompletionPattern': '\S/\S*'},
      \ 'rg': {'mark': 'rg', 'minAutoCompleteLength': 4,},
      \ 'yank': {'mark': 'Y'},
      \ })

call ddc#enable()
call signature_help#enable()
call popup_preview#enable()
