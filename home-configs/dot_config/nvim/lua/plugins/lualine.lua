-- Make lualine background transparent
return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    local theme = require("lualine.utils.loader").load_theme("auto")
    for _, mode in pairs(theme) do
      for _, section in ipairs({ "b", "c" }) do
        if mode[section] then
          mode[section].bg = "NONE"
        end
      end
    end
    opts.options = opts.options or {}
    opts.options.theme = theme
  end,
}
