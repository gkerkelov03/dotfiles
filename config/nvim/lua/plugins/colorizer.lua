return {
    "NvChad/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = {
        filetypes = { "*", "!lazy", "!mason" }, -- Don't colorize the package manager screens
        user_default_options = {
            RGB = true, -- #RGB hex codes
            RRGGBB = true, -- #RRGGBB hex codes
            names = false, -- Disables "Blue", "Red" names to avoid accidental highlights
            RRGGBBAA = true, -- #RRGGBBAA hex codes
            rgb_fn = true, -- CSS rgb() and rgba() functions
            hsl_fn = true, -- CSS hsl() and hsla() functions
            css = true, -- Enable all CSS features
            mode = "virtualtext",
            virtualtext = " ", -- The square symbol you wanted
        },
    },
}
