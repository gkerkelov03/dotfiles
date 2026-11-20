return {
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = { enabled = false },
      explorer = { enabled = false },
    },
    keys = {
      --Disable the keymaps for snacks explorer cuz despite it being Disabled
      --It sitll opens when you press some of its keybindings cuz they are active
      { "<leader>e", false },
      { "<leader>E", false },
      { "<leader>fe", false },
      { "<leader>fE", false },
    },
  },
}
