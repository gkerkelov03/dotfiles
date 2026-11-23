return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      marksman = { enabled = false },
      markdown_oxide = {
        capabilities = {
          workspace = { didChangeWatchedFiles = { dynamicRegistration = true } },
        },
      },
    },
  },
}
