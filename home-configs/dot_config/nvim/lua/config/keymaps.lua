-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.keymap

keymap.set({ "n", "x" }, "0", "^") -- Map 0 to ^
keymap.set("n", "o", "o<Esc>") -- Open new lines without staying in insert mode
keymap.set("n", "da", ":%d<cr>", { desc = "Delete all" }) -- Delete all
keymap.set("n", "ya", ":%y+<cr>", { desc = "Copy all" }) -- Copy all
keymap.set("n", "P", "kp", { desc = "Paste on line above" }) -- Paste on the line above
