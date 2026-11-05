-- yazi-rs/plugins:git
require("git"):setup({
	order = 1500,
})

-- yazi-rs/plugins:no-status
require("no-status"):setup()

-- ahkohd/eza-preview
require("eza-preview"):setup({
	default_tree = true,
	level = 2,
	icons = true,
	follow_symlinks = true,
	dereference = false,
	all = true,
	ignore_glob = { ".git" },
	git_ignore = true,
	git_status = true,
})
