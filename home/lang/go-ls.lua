goplsSettings = {
  analyses = {
    composites = false
  }
}
goplsSettings['local'] = os.getenv("GOPLS_SETTINGS_LOCAL") or ''
vim.lsp.config('gopls', {
  settings = {
    gopls = goplsSettings
  }
})
vim.lsp.enable('gopls')

vim.lsp.enable('golangci_lint_ls')
