local lspconfig = require('lspconfig')
local configs = require 'lspconfig.configs'

goplsSettings = {
  analyses = {
    composites = false
  }
}
goplsSettings['local'] = os.getenv("GOPLS_SETTINGS_LOCAL") or ''

-- For some repos at my work
goplsSettings['buildFlags'] = {'-tags', 'integration,e2e'}

lspconfig.gopls.setup{
  settings = {
    gopls = goplsSettings
  }
}

lspconfig.golangci_lint_ls.setup{}
