local keymap = vim.keymap

-- Exit insert mode with jj
keymap.set("i", "jj", "<Esc>")

-- Map 0 to ^
keymap.set({ "n", "x" }, "0", "^")

-- Open new lines without staying in insert mode
keymap.set("n", "<leader>o", "o<Esc>")
keymap.set("n", "<leader>O", "O<Esc>")

-- Center search results
keymap.set("n", "n", "nzz")
keymap.set("n", "N", "Nzz")
