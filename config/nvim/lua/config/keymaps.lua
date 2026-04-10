local keymap = vim.keymap
keymap.set({ "n", "x" }, "0", "^")                                -- Map 0 to ^
keymap.set("n", "o", "o<Esc>")                                    -- Open new lines without staying in insert mode
keymap.set("n", "<leader>da", ":%d<cr>", { desc = "Delete all" }) -- Delete all
keymap.set("n", "<leader>ya", ":%y+<cr>", { desc = "Copy all" })  -- Copy all
keymap.set("n", "P", "kp", { desc = "Paste on line above" })      -- Paste on the line above
