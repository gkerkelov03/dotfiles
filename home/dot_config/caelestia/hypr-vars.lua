return {
	terminal = "foot",
	browser = "qutebrowser",

	editor = "foot nvim",

	--the loading of the caelestia colors needs to be here explicitly because this is not interactive shell
	--and they are not gonna be loaded otherwise. If they are loaded in every shell it causes bugs with tv
	--so in the fish config we only load the caelestia colors in interactive terminals now.
	fileExplorer = "foot fish -c 'cat ~/.local/state/caelestia/sequences.txt 2>/dev/null; exec yazi'",

	kbTerminal = "SUPER + Return",
	kbLock = "SUPER + CTRL + ALT + L",
}
