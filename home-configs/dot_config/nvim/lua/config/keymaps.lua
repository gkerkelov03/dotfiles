-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.keymap

keymap.set({ "n", "x" }, "0", "^") -- Map 0 to ^
keymap.set("n", "o", "o<Esc>") -- Open new lines without staying in insert mode
keymap.set("n", "<leader>da", ":%d<cr>", { desc = "Delete all" }) -- Delete all
keymap.set("n", "<leader>ya", ":%y+<cr>", { desc = "Copy all" }) -- Copy all

-- move trough the suggestions in command mode (: mode) with up and down arrow
-- if no suggestions are shown (if you havent typed anything yet) the up arrow key
-- is gonna cycle trough your history of commands that you ran with :
keymap.set("c", "<Down>", "<C-n>", { remap = true, desc = "Next suggestion / history" })
keymap.set("c", "<Up>", "<C-p>", { remap = true, desc = "Previous suggestion / history" })
