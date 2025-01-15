
-- need a leading newline to avoid this going onto the same line as the sourcing of viml config
-- globals
cmd = vim.cmd
fn = vim.fn
g = vim.g
opt = vim.opt
api = vim.api

-- vim helper functions
function map(mode, lhs, rhs, opts)
  opts = opts or {noremap=true, silent=true}
  api.nvim_set_keymap(mode, lhs, rhs, opts)
end

vmap = function(lhs, rhs, opts) map('v', lhs, rhs, opts) end
nmap = function(lhs, rhs, opts) map('n', lhs, rhs, opts) end
imap = function(lhs, rhs, opts) map('i', lhs, rhs, opts) end

-- map the leader before we call any mapping functions
g.mapleader = ','
