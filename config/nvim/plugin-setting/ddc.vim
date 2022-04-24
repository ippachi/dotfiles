call ddc#custom#patch_global('sources', ['nvim-lsp', 'around'])

call ddc#custom#patch_global('sourceOptions', {
      \ '_': {
      \   'matchers': ['matcher_head'],
      \   'sorters': ['sorter_rank']},
      \ })

call ddc#custom#patch_global('sourceOptions', {
      \ 'around': {'mark': 'A'},
      \ })

call ddc#custom#patch_global('sourceOptions', {
      \ 'nvim-lsp': {
      \   'mark': 'lsp',
      \   'forceCompletionPattern': '\.\w*|:\w*|->\w*' },
      \ })

call ddc#enable()
