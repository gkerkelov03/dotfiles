-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Track in-flight chezmoi jobs so we can wait for them on exit (:wq, :x, ZZ)
local pending = {}

local function run(cmd, opts, on_exit)
  local job
  job = vim.system(cmd, opts, function(res)
    pending[job] = nil
    if on_exit then
      on_exit(res)
    end
  end)
  pending[job] = true
  return job
end

vim.api.nvim_create_autocmd("VimLeavePre", {
  group = vim.api.nvim_create_augroup("ChezmoiWaitOnExit", { clear = true }),
  callback = function()
    -- Loop with next() rather than pairs(): waiting can spawn new jobs
    -- (source-path check -> re-add), which adds keys mid-iteration.
    local job = next(pending)
    while job do
      job:wait(10000)
      pending[job] = nil
      job = next(pending)
    end
  end,
})

-- auto run chezmoi apply <file> after a file has been saved in ~/dotfiles
vim.api.nvim_create_autocmd("BufWritePost", {
  group = vim.api.nvim_create_augroup("ChezmoiApply", { clear = true }),
  pattern = {
    vim.fn.expand("~/dotfiles/home-configs") .. "/*",
    vim.fn.expand("~/dotfiles/system-configs") .. "/*",
  },
  callback = function(args)
    local file = args.match
    if file:find("/.chezmoi", 1, true) then
      return
    end

    run({ "chezmoi", "apply", "--force", "--source-path", file }, { text = true }, function(res)
      vim.schedule(function()
        if res.code == 0 then
          vim.notify("chezmoi apply done: " .. vim.fn.fnamemodify(file, ":t"))
        else
          vim.notify("chezmoi apply failed:\n" .. res.stderr, vim.log.levels.ERROR)
        end
      end)
    end)
  end,
})

-- auto run chezmoi re-add when a chezmoi-managed file under ~ is saved
vim.api.nvim_create_autocmd("BufWritePost", {
  group = vim.api.nvim_create_augroup("ChezmoiReAdd", { clear = true }),
  pattern = vim.fn.expand("~") .. "/*",
  callback = function(args)
    local file = args.match

    run({ "chezmoi", "source-path", file }, { text = true }, function(check)
      if check.code ~= 0 then
        return
      end
      run({ "chezmoi", "re-add", file }, { text = true, timeout = 10000 }, function(res)
        vim.schedule(function()
          if res.code == 0 then
            vim.notify("chezmoi re-add done: " .. vim.fn.fnamemodify(file, ":t"))
          else
            vim.notify("chezmoi re-add failed:\n" .. res.stderr, vim.log.levels.ERROR)
          end
        end)
      end)
    end)
  end,
})
