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
-- So the line below runs ~/.config/nvim/lua/config/lazy.lua
-- btw our file doesn't have to be named lazy.lua we can name it whatever we want
-- it just needs to be in the correct place and if soething requires it the file
-- will be found and the code in it will run

require("config.lazy")
