-- yazi-rs/plugins:git
require("git"):setup({
	order = 1500,
})

-- yazi-rs/plugins:no-status
require("no-status"):setup()

require("relative-motions"):setup({
	show_numbers = "relative",
	show_motion = false,
})
