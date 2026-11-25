-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.keymap
local map = require("config.bulgarian").map

map({ "n", "x" }, "0", "^") -- Map 0 to ^
map("n", "o", "o<Esc>") -- Open new lines without staying in insert mode
map("n", "<leader>da", ":%d<cr>", { desc = "Delete all" }) -- Delete all
map("n", "<leader>ya", ":%y+<cr>", { desc = "Copy all" }) -- Copy all

-- these don't involve letters, so plain keymap.set is enough
keymap.set("c", "<Down>", "<C-n>", { remap = true, desc = "Next suggestion / history" })
keymap.set("c", "<Up>", "<C-p>", { remap = true, desc = "Previous suggestion / history" })
