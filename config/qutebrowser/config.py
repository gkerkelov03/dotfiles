# h: scroll left
# j: scroll down
# k: scroll up
# l: scroll right
# gg: top of page
# G: bottom of page

# d: delete window
# u: restore window
# H: go back
# L: go forward

# r: reload with cache
# R: hard reload without using the cache
# f: open link in current tab
# F: open link in a new tab
# J: previous tab
# K: next tab

# m: add quickmark
# M: add bookmark
# Sq: bookmarks

# Sh: open history
# x: open devtools

# yy: copy current url
# yf: copy some link that you see
# go: edit current url

# q: video speed -0.1
# w: video speed +0.1
# e: video speed = 1

import os

c: Keymerger = c  # noqa: F821, E0602
config: ConfigAPI = config  # noqa: F821, E0602

# Don't allow config outside of this file
config.load_autoconfig(False)

# Default pages to open
c.url.start_pages = "https://google.com/gemini"
c.url.default_page = "https://google.com/gemini"

# make :open yt gosho search directly in youtube and so on...
c.url.searchengines = {
    "DEFAULT": "https://www.google.com/search?q={}",
    "yt": "https://www.youtube.com/results?search_query={}",
    "gh": "https://github.com/search?q={}",
    "maps": "www.google.com/maps?q={}",
}

# alias :src to :cnofig-source and so on...
c.aliases = {"src": "config-source"}

config.bind("J", "tab-prev")
config.bind("K", "tab-next")
config.bind("yf", "hint links yank")
config.bind("x", "devtools")

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
config.unbind("<Ctrl-v>", mode="normal")

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
