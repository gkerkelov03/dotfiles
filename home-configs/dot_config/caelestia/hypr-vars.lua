return {
	fileExplorer = "kitty -1 yazi",
	editor = "kitty -1 nvim",
	terminal = "kitty -1",
	kbTerminal = "SUPER + Return",
	kbLock = "SUPER + CTRL + ALT + L",

	volumeStep = 5,
	kbGoToWs = "SUPER",
	kbMoveWinToWs = "SUPER + ALT",

	kbMoveWinToWsSpecial = { "SUPER + ALT + S", "CTRL + SUPER + SHIFT + Up" },
	kbMoveWinFromWsSpecial = "CTRL + SUPER + SHIFT + Down",

	kbSpecialWs = "SUPER + S",
	kbSystemMonitorWs = "CTRL + SHIFT + Escape",
	kbMusicWs = "SUPER + M",
	kbCommunicationWs = "SUPER + D",
	kbTodoWs = "SUPER + R",

	kbToggleGroup = "SUPER + Comma",
	kbWindowGroupCycleNext = "CTRL + ALT + TAB",
	kbWindowGroupCyclePrev = "CTRL + SHIFT + ALT + TAB",

	kbWindowDecreaseWidth = { "SUPER + Minus", "SUPER + ALT + Left" },
	kbWindowIncreaseWidth = { "SUPER + Equal", "SUPER + ALT + Right" },

	--this triggers language change cuz of super space
	kbToggleWindowFloating = "SUPER + ALT + Space",
	kbMoveWindow = "SUPER + Z",
	kbResizeWindow = "SUPER + X",
	kbWindowFullscreen = "SUPER + F",
	kbWindowBorderedFullscreen = "SUPER + ALT + F",
	kbCloseWindow = "SUPER + Q",
}
