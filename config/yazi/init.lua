require("git"):setup({
	order = 1500,
})

require("no-status"):setup()

require("fg"):setup({
	default_action = "menu", -- nvim, jump
})

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
