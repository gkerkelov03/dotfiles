local keymap = vim.keymap

-- Exit insert mode with jj
keymap.set("i", "jj", "<Esc>")

-- Map 0 to ^
keymap.set({ "n", "x" }, "0", "^")

-- Open new lines without staying in insert mode
keymap.set("n", "o", "o<Esc>")
keymap.set("n", "O", "O<Esc>")

-- Center search results
keymap.set("n", "n", "nzz")
keymap.set("n", "N", "Nzz")

-- Delete all
keymap.set("n", "<leader>da", ":%d<cr>", { desc = "Delete all" })

-- Copy all
keymap.set("n", "<leader>ya", ":%y+<cr>", { desc = "Copy all" })

-- Paste on the line above
keymap.set("n", "P", "kp", { desc = "Paste on line above" })
