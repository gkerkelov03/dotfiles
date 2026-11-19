-- Enforce literal tabs for filetypes that require them (e.g. .snippets, Makefiles),
-- keeping global space-based indentation intact for other buffers.
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("CustomIndentation", { clear = true }),
  pattern = { "snippets", "make" },
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})
