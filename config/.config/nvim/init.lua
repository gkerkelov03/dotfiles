-- Enable syntax highlighting
vim.cmd("syntax on")

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Indentation
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true

-- Backups
vim.opt.backup = false

-- Scrolling
vim.opt.scrolloff = 10

-- Display
vim.opt.wrap = false

-- Search
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true

-- UI
vim.opt.showcmd = true
vim.opt.showmode = true
vim.opt.showmatch = true

-- History
vim.opt.history = 1000

-- Keymaps
local keymap = vim.keymap

-- Exit insert mode with jj
keymap.set("i", "jj", "<Esc>", { noremap = true })

-- Map 0 to ^
keymap.set("n", "0", "^", { noremap = true })
keymap.set("x", "0", "^", { noremap = true })

-- Open new lines without staying in insert mode
keymap.set("n", "o", "o<Esc>", { noremap = true })
keymap.set("n", "O", "O<Esc>", { noremap = true })

-- Yank to end of line
keymap.set("n", "Y", "y$", { noremap = true })

-- Center search results
keymap.set("n", "n", "nzz", { noremap = true })
keymap.set("n", "N", "Nzz", { noremap = true })
