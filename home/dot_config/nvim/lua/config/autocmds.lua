-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- auto run chezmoi apply after a file has been saved in ~/dotflies/home
vim.api.nvim_create_autocmd("BufWritePost", {
  group = vim.api.nvim_create_augroup("ChezmoiApply", { clear = true }),
  pattern = vim.fn.expand("~/dotfiles/home") .. "/*",
  callback = function()
    vim.system({ "chezmoi", "apply", "--force" }, { text = true }, function(res)
      vim.schedule(function()
        if res.code == 0 then
          vim.notify("chezmoi apply done")
        else
          vim.notify("chezmoi apply failed:\n" .. res.stderr, vim.log.levels.ERROR)
        end
      end)
    end)
  end,
})

-- auto run chezmoi re-add file when a file is saved from ~/.config if the file is managed by chezmoi
vim.api.nvim_create_autocmd("BufWritePost", {
  group = vim.api.nvim_create_augroup("ChezmoiReAdd", { clear = true }),
  pattern = vim.fn.expand("~/.config") .. "/*",
  callback = function(args)
    local file = args.match

    vim.system({ "chezmoi", "source-path", file }, { text = true }, function(check)
      -- Skip files chezmoi doesn't manage
      if check.code ~= 0 then
        return
      end

      vim.system({ "chezmoi", "re-add", file }, { text = true, timeout = 10000 }, function(res)
        vim.schedule(function()
          if res.code == 0 then
            vim.notify("chezmoi re-add done")
          else
            vim.notify("chezmoi re-add failed:\n" .. res.stderr, vim.log.levels.ERROR)
          end
        end)
      end)
    end)
  end,
})
