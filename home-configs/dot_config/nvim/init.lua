-- NVIM FUNDAMENTALS================================================

-- nvim runs this file at startup. It's the only file loaded
-- by name. It is like the main method for your nvim config
-- everything else runs because something in this file makes it run in some way.

-- RUNTIME PATH
-- The runtimepath is an ordered list of directories that nvim
-- searches whenever it needs something by name: Lua modules (lua/),
-- colorschemes (colors/), plugin scripts (plugin/), filetype settings
-- (ftplugin/), help files (doc/), and so on. This config folder
-- (~/.config/nvim) is always on it and it is essentially the first one
-- in the list and plugin managers work by adding each
-- plugin's folder to the list of runtime paths. And all plugins comply
-- with the folder naming conventions above so their files
-- can be found properly and our .config/nvim config also complies
-- btw the runtimepath is built dynamically every startup only a files
-- directories are in there by default like our .config/nvim everything else
-- goes there because something in our init.lua file makes it go there somehow.

-- MODULES
-- require("a.b") turns the dots into slashes and searches every runtimepath
-- directory for lua/a/b.lua or lua/a/b/init.lua. The first match is run once
-- and its result is cached, so requiring the same module again doesn't re-run it.
-- if it is just require("a") it is searched in lua/a.lua or lua/a/init.lua
-- So require("config.lazy") would run ~/.config/nvim/lua/config/lazy.lua

-- NVIM FUNDAMENTALS END=================================================

-- vim.fn.stdpath stands for standardpath and you pass it what kind of
-- category of files you wanna store there and it gives you the path to place them
-- into. The main categories are data, state, config, cache but there are others
-- the standardpath for config is XDG_CONFIG_HOME/nvim and the standardpath
-- for the others is based on the XDG home directories standard too

-- in this case the variable lazy_plugin_itself_folder_path is gonna be XDG_DATA_HOME/nvim/lazy/lazy.nvim
-- and the lazy.nvim at the end of the path doesn't mean that the path points to a file
-- the path is just a path and whatever we put there first it is gonna become that
-- for example in our case here it is gonna become a directory that just has . in the name
-- because we are gonna clone a repo into it. If we use the path like
-- io.open(path, "w") for example the lazy.nvim at the end of the path is gonna be a file
local lazy_plugins_folder = vim.fn.stdpath("data") .. "/lazy"
local lazy_plugin_itself_folder_path = lazy_plugins_folder .. "/lazy.nvim"

-- vim.uv is libuv (a C library for OS level tasks like file operations, processes, timers and so on)
-- fs_stat returns an object containing info for whatever the path that you passed
-- to it points to or nil(null). In this case we use it only to check if
-- the folder for the lazy.nvim plugin already exists because nil is a falsy value in lua
-- if it doesn't we clone the repo into that folder
if not vim.uv.fs_stat(lazy_plugin_itself_folder_path) then
  local lazy_plugin_repo_url = "https://github.com/folke/lazy.nvim.git"
  local command_output_as_text = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazy_plugin_repo_url,
    lazy_plugin_itself_folder_path,
  })

  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { command_output_as_text, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})

    -- waits for a key press and returns either a string or a number
    -- depending on what was pressed. We use it here so we have time to read
    -- the error message otherwise nvim will close instantly
    vim.fn.getchar()

    -- ends the nvim process with a status code for error
    os.exit(1)
  end
end

vim.opt.rtp:prepend(lazy_plugin_itself_folder_path)

-- looks for a file lua/lazy.lua or lua/lazy/init.lua
-- in all runtime paths and it finds it in lazy_plugin_itself_folder_path
-- it runs that file and caches the result.
-- the result is an object with a few functions and one of them is .setup()
require("lazy").setup({
  -- the list of specs to load. The list of specs defines all the plugins that
  -- lazy.nvim is managing and all their options. For example until now we have
  -- installed lazy.nvim the package manager plugin and we got it running but
  -- if down the chain there is no spec that defines the lazy.nvim plugin itself
  -- then lazy is not gonna manage itself. The fact that we have cloned lazy.nvim
  -- into lazy_plugin_itself_folder_path doesn't mean that lazy is managing that plugin
  -- somewhere in the chain of specs down below someone needs to define a spec for the lazy.nvim
  -- plugin and then lazy is gonna manage itself.
  spec = {
    --tell lazy.nvim that it needs to manage the LazyVim plugin and run all the
    --code in the .lua files from LazyVim/lazyvim/plugins and merge the specs that
    --they return (including the init.lua file if such exists).
    --Import also runs and merges the specs of all the init.lua files
    --of all folders within LazyVim/lazyvim/plugins/<folder>init.lua
    { "LazyVim/LazyVim", import = "lazyvim.plugins", opts = { colorscheme = "caelestia" } },
    -- run all the code from all the .lua files from .config/nvim/lua/plugins
    -- and merge all the specs that they return
    { import = "plugins" },
  },
  -- sets the colorscheme for the installer window to be caelestia because
  -- the installer window shows up when lazy sees that it needs to install
  -- a plugin and this is happening before lazy loads and applies the options
  -- to all plugins so the install window will have some default colorscheme
  install = { colorscheme = { "caelestia" } },
  checker = {
    enabled = true, -- check for plugin updates periodically
    notify = false, -- don't show notifications
    frequency = 1209600, -- check every 14 days (14 days * 24 hours * 60 minutes * 60 seconds)
  },
  performance = {
    rtp = {
      -- disable some nvim builtin plugins that are totally useless and only
      -- slow down our startup time
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

-- Make normal-mode commands work with the Bulgarian phonetic layout
require("config.bulgarian").setup()
