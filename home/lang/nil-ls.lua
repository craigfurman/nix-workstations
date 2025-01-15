require('lspconfig').nil_ls.setup {
  settings = {
    ['nil'] = {
      formatting = {
        command = {"nixfmt"},
      },
    },
  },
}
