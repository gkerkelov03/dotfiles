import os

# Define the global variables that are available so the ide knows and about them and doesn't mark all lines as errors
c: Keymerger = c  # noqa: F821, E0602
config: ConfigAPI = config  # noqa: F821, E0602
allModes = ["command", "insert", "hint", "caret", "passthrough", "prompt", "yesno"]

config.load_autoconfig(False)  # Don't allow config outside of this file
c.bindings.default = {}  # Unbind all default keybingings
c.colors.webpage.preferred_color_scheme = "dark"  # Set dark mode prefference

config.bind("i", "mode-enter insert", mode="normal")
config.bind(":", "cmd-set-text :", mode="normal")
config.bind("<Return>", "prompt-accept", mode="prompt")
config.bind("<Return>", "command-accept", mode="command")
config.bind("<Up>", "completion-item-focus prev", mode="command")
config.bind("<Down>", "completion-item-focus next", mode="command")
for mode in allModes:
    config.bind("<Ctrl-[>", "mode-leave", mode=mode)


config.bind("o", "cmd-set-text -s :open")
config.bind("O", "cmd-set-text -s :open -t")

# Write your text in in nvim
c.editor.command = ["foot", "nvim", "{file}"]
config.bind("<Ctrl-e>", "edit-text", mode="insert")
config.bind("<Ctrl-e>", "edit-command", mode="command")

# Scrolling
config.bind("h", "scroll left")
config.bind("j", "scroll down")
config.bind("k", "scroll up")
config.bind("l", "scroll right")
config.bind("gg", "scroll-to-perc 0")
config.bind("G", "scroll-to-perc 100")

# Tab Management
config.bind("x", "tab-close")
config.bind("u", "undo")
config.bind("J", "back")
config.bind("K", "forward")
config.bind("H", "tab-prev")  # Focus prev tab
config.bind("L", "tab-next")  # Focus next tab
config.bind("gh", "tab-move -")  # Move tab to the left
config.bind("gl", "tab-move +")  # Move tab to the right
config.bind("a", "config-cycle tabs.show always never")

# Reload & Open
config.bind("r", "reload")  # Reload using the same cache
config.bind("R", "reload -f")  # Hard reload
config.bind("f", "hint")  # Open link in current tab
config.bind("F", "hint all tab")  # Open link in new tab
config.bind("cd", "download-clear")  # Close/clear downloads
config.bind("cn", "clear-messages")  # Close/clear notifications
config.bind("p", "open -- {clipboard}")
config.bind("P", "open -t -- {clipboard}")
config.bind("d", "tab-clone")
c.messages.timeout = 3000

# Marks & History
config.bind("ma", "bookmark-add")
config.bind("md", "bookmark-del")
config.bind("sm", "bookmark-list")
config.bind("sh", "history")
config.bind("sd", "devtools")

# Yank & URL display
config.bind("yy", "yank url")  # Copy current url
config.bind("yf", "hint links yank")  # Copy some url on the page
config.bind("so", "cmd-set-text -s :open {url:pretty}")  # Show opened url

# Video Speed Controls
config.bind(
    "q",
    'clear-messages ;; jseval document.querySelector("video, audio").playbackRate = (document.querySelector("video, audio").playbackRate - 0.1).toFixed(1)',
)
config.bind(
    "w",
    'clear-messages ;; jseval document.querySelector("video, audio").playbackRate = (document.querySelector("video, audio").playbackRate + 0.1).toFixed(1)',
)
config.bind(
    "e",
    'clear-messages ;; jseval document.querySelector("video, audio").playbackRate = 1',
)


# Default pages to open
c.url.start_pages = "https://google.com/gemini"
c.url.default_page = "https://google.com/gemini"

# make :open yt gosho search directly in youtube and so on...
c.url.searchengines = {
    "DEFAULT": "https://www.google.com/search?q={}",
    "yt": "https://www.youtube.com/results?search_query={}",
    "ytm": "https://music.youtube.com/search?q={}",
    "gh": "https://github.com/search?q={}",
    "maps": "www.google.com/maps?q={}",
    "gpt": "https://chatgpt.com/?q={}",
    "gem": "https://gemini.google.com/app?q={}",
}

# alias :src to :config-source and so on...
c.aliases = {
    "src": "config-source",
    "inst": "https://instagram.com",
    "yt": "https://youtube.com",
    "ytm": "https://music.youtube.com",
}

# Setup q w e to do -0.1 +0.1 =1 speed for videos
config.bind(
    "q",
    "clear-messages ;; jseval document.querySelector('video, audio').playbackRate = (document.querySelector('video, audio').playbackRate - 0.1).toFixed(1)",
)
config.bind(
    "w",
    "clear-messages ;; jseval document.querySelector('video, audio').playbackRate = (document.querySelector('video, audio').playbackRate + 0.1).toFixed(1)",
)
config.bind(
    "e",
    "clear-messages ;; jseval document.querySelector('video, audio').playbackRate = (document.querySelector('video, audio').playbackRate = 1)",
)

# Setup yazi as an external file picker
c.downloads.location.directory = os.path.expanduser("~/downloads")
c.fileselect.handler = "external"
yazi_chooser = ["foot", "--", "yazi", "--chooser-file", "{}"]
c.fileselect.single_file.command = yazi_chooser
c.fileselect.multiple_files.command = yazi_chooser
c.fileselect.folder.command = yazi_chooser

# Basic options that should've been the default
c.content.autoplay = False
c.session.lazy_restore = True
c.scrolling.smooth = True
c.completion.height = "20%"
c.tabs.show = "switching"
c.statusbar.show = "in-mode"
c.input.insert_mode.auto_leave = False
config.bind("y", "prompt-accept yes", mode="yesno")
config.bind("n", "prompt-accept no", mode="yesno")
config.bind("Y", "prompt-accept always", mode="yesno")
config.bind("N", "prompt-accept never", mode="yesno")

# Tabs colors
c.colors.tabs.even.bg = "#282c34"
c.colors.tabs.odd.bg = "#282c34"
c.colors.tabs.selected.even.bg = "#61afef"
c.colors.tabs.selected.odd.bg = "#61afef"
c.colors.tabs.selected.even.fg = "#ffffff"
c.colors.tabs.selected.odd.fg = "#ffffff"

# Permissions allow all
c.content.notifications.enabled = True
c.content.javascript.clipboard = "access-paste"
c.content.geolocation = True
c.content.media.video_capture = True
c.content.media.audio_capture = True
c.content.media.audio_video_capture = True
c.content.desktop_capture = True

# Use GPU as much as possible
c.qt.args = [
    "enable-accelerated-video",
    "enable-native-gpu-memory-buffers",
    "ignore-gpu-blocklist",
    "enable-quic",
]
c.qt.workarounds.disable_accelerated_2d_canvas = "never"
