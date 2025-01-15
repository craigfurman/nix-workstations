-- Options
opt.lazyredraw = true
opt.mouse = 'a'
opt.wrap = false
opt.number = true
opt.textwidth = 80
opt.scrolloff = 1
opt.sidescrolloff = 5

-- Tabs vs Spaces
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2

-- lower case search is case insensitive, mixed/upper case search is case
-- sensitive
opt.ignorecase = true
opt.smartcase = true

-- Ensure cursor ends up in what I percieve to be the new split
opt.splitright = true
opt.splitbelow = true

-- Stay in visual mode after changing indentation
vmap('<', '<gv')
vmap('>', '>gv')

-- Keybinds
nmap('<Space>', ':noh<CR>')
nmap('<Leader>s', ':w<CR>')
nmap('<Leader>!', ':qa!<CR>')
nmap('<Leader><Leader>', '<C-^>')
nmap('<Leader>q', ':bdelete<CR>')
vmap('Y', '"+y')
