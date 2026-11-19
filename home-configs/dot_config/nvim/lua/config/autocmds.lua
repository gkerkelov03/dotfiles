-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- load all the .lua files from ./autocmds automatically and recursively
-- so all ./autocmds/*.lua and ./autocmds/*/.lua will be loaded automatically
local autocmd_dir = vim.fn.stdpath("config") .. "/lua/config/autocmds"
for path, type in vim.fs.dir(autocmd_dir, { depth = math.huge }) do
  if type == "file" and path:sub(-4) == ".lua" then
    -- Convert relative path like "git/chezmoi.lua" to module "config.autocmds.git.chezmoi"
    local module = path:sub(1, -5):gsub("[/\\]", ".")
    require("config.autocmds." .. module)
  end
end
