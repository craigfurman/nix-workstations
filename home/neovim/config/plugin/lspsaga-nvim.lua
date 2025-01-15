require('lspsaga').setup({
  lightbulb = {
    enable = false,
  },
  symbol_in_winbar = {
    enable = false,
  },
})

nmap('K', '<cmd>Lspsaga hover_doc<CR>')
nmap('<Leader>ca', '<cmd>Lspsaga code_action<CR>')
