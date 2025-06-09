require'nvim-tree'.setup({
  disable_netrw = false,
  view = {
    side = "right"
  }
})
nmap('\\', '<cmd>NvimTreeToggle<CR>')
nmap('|', '<cmd>NvimTreeFindFile<CR>')
