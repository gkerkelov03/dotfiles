return {
  "atdma/caelestia-nvim",
  lazy = false,
  priority = 1000,
  config = function(plugin)
    package.path = package.path .. ";" .. plugin.dir .. "/?.lua"
    package.path = package.path .. ";" .. plugin.dir .. "/?/init.lua"
    dofile(plugin.dir .. "/init.lua")
    require("caelestia").setup()
  end,
}
