call ddc#custom#patch_global('sources', ['nvim-lsp', 'around', 'buffer', 'rg', 'yank', 'file'])
call ddc#custom#patch_global('sourceOptions', {
      \   '_': {
      \     'matchers': ['matcher_head'],
      \     'sorters': ['sorter_rank'],
      \     'converters': ['converter_remove_overlap', 'converter_truncate'],
      \   },
      \   'around': { 'mark': 'A' },
      \   'nvim-lsp': {'mark': 'lsp', 'forceCompletionPattern': '\.\w*|:\w*|->\w*', 'keywordPattern': '\k*'},
      \   'buffer': { 'mark': 'B' },
      \   'rg': { 'mark': 'RG', 'minAutoCompleteLength': 4 },
      \   'deoppet': { 'mark': 'dp' },
      \   'yank': { 'mark': 'Y' },
      \   'cmdline-history': { 'mark': 'history' },
      \   'cmdline': { 'mark': 'cmdline' },
      \   'file': {
      \     'mark': 'F',
      \     'isVolatile': v:true,
      \     'forceCompletionPattern': '\S/\S*',
      \   }
      \ })
call ddc#custom#patch_global('sourceParams', {
      \ 'nvim-lsp': {'useIcon': v:true},
      \ })

call ddc#custom#patch_global('filterParams', {
    \ 'buffer': {'requireSameFiletype': v:false},
    \ 'converter_truncate': {'maxInfoWidth': 20}
    \ })

call ddc#custom#patch_global('sourceOptions', {
      \   '_': {
      \     'matchers': ['matcher_head'],
      \     'sorters': ['sorter_rank'],
      \     'converters': ['converter_remove_overlap'],
      \   }
      \ })

call ddc#enable()
