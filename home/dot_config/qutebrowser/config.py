import os

# Define the global variables that are available so the ide knows and about them and doesn't mark all lines as errors
c: Keymerger = c  # noqa: F821, E0602
config: ConfigAPI = config  # noqa: F821, E0602
allModes = ["command", "insert", "hint", "caret", "passthrough", "prompt", "yesno"]
gpg_key = "gkerkelov03@gmail.com"

config.load_autoconfig(False)  # Don't allow config outside of this file
c.bindings.default = {}  # Unbind all default keybingings
c.colors.webpage.preferred_color_scheme = "dark"  # Set dark mode prefference

config.bind("i", "mode-enter insert", mode="normal")
config.bind("и", "mode-enter insert", mode="normal")
config.bind(":", "cmd-set-text :", mode="normal")
config.bind("<Return>", "prompt-accept", mode="prompt")
config.bind("<Return>", "command-accept", mode="command")
config.bind("<Up>", "completion-item-focus prev", mode="command")
config.bind("<Down>", "completion-item-focus next", mode="command")
for mode in allModes:
    config.bind("<Ctrl-[>", "mode-leave", mode=mode)

config.bind("o", "cmd-set-text -s :open")
config.bind("о", "cmd-set-text -s :open")  # Bulgarian o
config.bind("n", "cmd-set-text -s :open -p")
config.bind("н", "cmd-set-text -s :open -p")
config.bind("O", "cmd-set-text -s :open -t")
config.bind("О", "cmd-set-text -s :open -t")  # Bulgarian big

# Write your text in nvim
c.editor.command = ["foot", "nvim", "{file}"]
config.bind("<Ctrl-e>", "edit-text", mode="insert")
config.bind("<Ctrl-e>", "edit-command", mode="command")

# Scrolling
config.bind("h", "scroll left")
config.bind("х", "scroll left")  # Bulgarian h
config.bind("j", "scroll down")
config.bind("й", "scroll down")  # Bulgarian j
config.bind("k", "scroll up")
config.bind("к", "scroll up")  # Bulgarian k
config.bind("l", "scroll right")
config.bind("л", "scroll right")  # Bulgarian l
config.bind("gg", "scroll-to-perc 0")
config.bind("гг", "scroll-to-perc 0")  # Bulgarian gg
config.bind("G", "scroll-to-perc 100")
config.bind("Г", "scroll-to-perc 100")  # Bulgarian G

# Tab Management
config.bind("x", "tab-close")
config.bind("ь", "tab-close")  # Bulgarian x
config.bind("u", "undo")
config.bind("у", "undo")  # Bulgarian u
config.bind("J", "back")
config.bind("Й", "back")  # Bulgarian J
config.bind("K", "forward")
config.bind("К", "forward")  # Bulgarian K
config.bind("H", "tab-prev")  # Focus prev tab
config.bind("Х", "tab-prev")  # Bulgarian H
config.bind("L", "tab-next")  # Focus next tab
config.bind("Л", "tab-next")  # Bulgarian L
config.bind("gh", "tab-move -")  # Move tab to the left
config.bind("гх", "tab-move -")  # Bulgarian gh
config.bind("gl", "tab-move +")  # Move tab to the right
config.bind("гл", "tab-move +")  # Bulgarian gl
config.bind("a", "config-cycle tabs.show always never")
config.bind("а", "config-cycle tabs.show always never")  # Bulgarian a

# Reload & Open
config.bind("r", "reload")  # Reload using the same cache
config.bind("р", "reload")  # Bulgarian r
config.bind("R", "reload -f")  # Hard reload
config.bind("Р", "reload -f")  # Bulgarian R
config.bind("f", "hint")  # Open link in current tab
config.bind("ф", "hint")  # Bulgarian f
config.bind("F", "hint all tab")  # Open link in new tab
config.bind("Ф", "hint all tab")  # Bulgarian F
config.bind("cd", "download-clear")  # Close/clear downloads
config.bind("цд", "download-clear")  # Bulgarian cd
config.bind("cn", "clear-messages")  # Close/clear notifications
config.bind("цн", "clear-messages")  # Bulgarian cn
config.bind("p", "open -- {clipboard}")
config.bind("п", "open -- {clipboard}")  # Bulgarian p
config.bind("P", "open -t -- {clipboard}")
config.bind("П", "open -t -- {clipboard}")  # Bulgarian P
config.bind("d", "tab-clone")
config.bind("д", "tab-clone")  # Bulgarian d
c.messages.timeout = 3000

# Marks & History
config.bind("ma", "open -t https://app.raindrop.io/add?link={url}&title={title}")
config.bind(
    "ма", "open -t https://app.raindrop.io/add?link={url}&title={title}"
)  # Bulgarian ma
config.bind("sm", "open -t https://app.raindrop.io/my/0")
config.bind("см", "open -t https://app.raindrop.io/my/0")  # Bulgarian sm
config.bind("sh", "history")
config.bind("сх", "history")  # Bulgarian sh
config.bind("sd", "devtools")
config.bind("сд", "devtools")  # Bulgarian sd

# Yank & URL display
config.bind("yy", "yank url")  # Copy current url
config.bind("со", "yank url")  # Bulgarian syy
config.bind("yf", "hint links yank")  # Copy some url on the page
config.bind("ъф", "hint links yank")  # Bulgarian yf
config.bind("so", "cmd-set-text -s :open {url:pretty}")  # Show opened url
config.bind("со", "cmd-set-text -s :open {url:pretty}")  # Bulgarian so

config.bind("/", "cmd-set-text /")
# KeepassXC integration
config.bind(
    "ke", f"spawn --userscript keepassxc.py --key {gpg_key} {{url}}", mode="normal"
)

config.bind(
    "ке", f"spawn --userscript keepassxc.py --key {gpg_key} {{url}}", mode="normal"
)  # Bulgarian ke

# Video Speed Controls
config.bind(
    "q",
    'clear-messages ;; jseval document.querySelector("video, audio").playbackRate = (document.querySelector("video, audio").playbackRate - 0.1).toFixed(1)',
)

config.bind(
    "я",
    'clear-messages ;; jseval document.querySelector("video, audio").playbackRate = (document.querySelector("video, audio").playbackRate - 0.1).toFixed(1)',
)  # Bulgarian q

config.bind(
    "w",
    'clear-messages ;; jseval document.querySelector("video, audio").playbackRate = (document.querySelector("video, audio").playbackRate + 0.1).toFixed(1)',
)

config.bind(
    "в",
    'clear-messages ;; jseval document.querySelector("video, audio").playbackRate = (document.querySelector("video, audio").playbackRate + 0.1).toFixed(1)',
)  # Bulgarian w

config.bind(
    "e",
    'clear-messages ;; jseval document.querySelector("video, audio").playbackRate = 1',
)

config.bind(
    "е",
    'clear-messages ;; jseval document.querySelector("video, audio").playbackRate = 1',
)  # Bulgarian e


# Default pages to open
c.url.start_pages = "https://gemini.google.com"
c.url.default_page = "https://gemini.google.com"

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
c.input.insert_mode.auto_enter = False

config.bind("y", "prompt-accept yes", mode="yesno")
config.bind("ъ", "prompt-accept yes", mode="yesno")  # Bulgarian y
config.bind("n", "prompt-accept no", mode="yesno")
config.bind("н", "prompt-accept no", mode="yesno")  # Bulgarian n
config.bind("Y", "prompt-accept --save yes", mode="yesno")
config.bind("Ъ", "prompt-accept --save yes", mode="yesno")  # Bulgarian Y
config.bind("N", "prompt-accept --save no", mode="yesno")
config.bind("Н", "prompt-accept --save no", mode="yesno")  # Bulgarian N

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
