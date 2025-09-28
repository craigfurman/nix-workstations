function lsp_imports(timeout_ms)
  -- The position_encoding param defaults to the encoding of the first attached
  -- client. This introduces the possibility of a bug in which the first client
  -- has a non-standard position encoding but does not support code actions. We
  -- will send that irrelevant and possibly-wrong position encoding to the
  -- clients that actually do support code actions.
  local params = vim.lsp.util.make_range_params()
  params.context = {only = {"source.organizeImports"}}

  local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, timeout_ms)
  for client_id, res in pairs(result or {}) do
    if res.error then
      local msg = string.format("LSP error code %d: %s", res.error.code, res.error.message)
      vim.notify(msg)
      return
    end

    if not res.result then
      return
    end

    for _, codeAction in ipairs(res.result) do
      if codeAction.edit then
        local offset_encoding = vim.lsp.get_client_by_id(client_id).offset_encoding
        vim.lsp.util.apply_workspace_edit(codeAction.edit, offset_encoding)
      end
      if codeAction.command then
        vim.lsp.buf.execute_command(codeAction.command)
      end
    end
  end
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
