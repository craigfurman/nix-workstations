local lspconfig = require('lspconfig')
local configs = require 'lspconfig.configs'

function lsp_imports(timeout_ms)
  local params = vim.lsp.util.make_range_params()
  params.context = {only = {"source.organizeImports"}}
  local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, timeout_ms)
  for _, res in pairs(result or {}) do
    for _, r in pairs(res.result or {}) do
      if r.edit then
        vim.lsp.util.apply_workspace_edit(r.edit, get_offset_encoding())
      else
        vim.lsp.buf.execute_command(r.command)
      end
    end
  end
end

function get_offset_encoding()
  -- Just use the first client. In the future, perhaps parameterise this with
  -- the desired client name.
  return vim.lsp.buf_get_clients()[1].offset_encoding
end

function lsp_imports_and_format(timeout_ms)
  timeout_ms = timeous_ms or 1000
  lsp_imports(timeout_ms)
  vim.lsp.buf.format({timeout_ms=timeout_ms})
end

-- keymaps: https://github.com/neovim/nvim-lspconfig#keybindings-and-completion
-- some use lspsaga instead
nmap('gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
nmap('gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
nmap('Gd', '<cmd>vsplit<CR><cmd>lua vim.lsp.buf.definition()<CR>')
nmap('gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
imap('<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
nmap('<Leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
nmap('gr', '<cmd>lua vim.lsp.buf.references()<CR>')
nmap('[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
nmap(']d', '<cmd>lua vim.diagnostic.goto_next()<CR>')
nmap('<Leader>e', '<cmd>lua vim.diagnostic.setloclist()<CR>')
nmap('<Leader>F', '<cmd>lua vim.lsp.buf.format({timeout_ms=2500})<CR>')
