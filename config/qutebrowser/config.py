import os 

#Don't allow config outside of this file
config.load_autoconfig(False) 

#Default pages to open
c.url.start_pages = "https://google.com/gemini"
c.url.default_page = "https://google.com/gemini"

#make :open yt gosho search directly in youtube and so on...
c.url.searchengines = {
    "DEFAULT": "https://www.google.com/search?q={}",
    "yt": "https://www.youtube.com/results?search_query={}",
    "gh": "https://github.com/search?q={}",
    "maps": "www.google.com/maps?q={}"
}

#alias :src to :cnofig-source and so on...
c.aliases = {
    "src": "config-source",
    "inst": "open instagram.com"
}

# Setup q w e to do -0.1 +0.1 =1 speed
config.bind("q", "clear-messages ;; jseval document.querySelector('video, audio').playbackRate = (document.querySelector('video, audio').playbackRate - 0.1).toFixed(1)")
config.bind("w", "clear-messages ;; jseval document.querySelector('video, audio').playbackRate = (document.querySelector('video, audio').playbackRate + 0.1).toFixed(1)")
config.bind("e", "clear-messages ;; jseval document.querySelector('video, audio').playbackRate = (document.querySelector('video, audio').playbackRate = 1)")

# Setup yazi as an external file picker
c.downloads.location.directory = os.path.expanduser("~/downloads")
c.fileselect.handler = "external"
yazi_chooser = [
    "foot",
    "--", 
    "yazi", 
    "--chooser-file", 
    "{}" 
]

c.fileselect.single_file.command = yazi_chooser
c.fileselect.multiple_files.command = yazi_chooser
c.fileselect.folder.command = yazi_chooser

# Use GPU as much as possible
c.qt.args = [
    "enable-accelerated-video",
    "enable-native-gpu-memory-buffers",
    "ignore-gpu-blocklist",
    "enable-quic",
]
c.qt.workarounds.disable_accelerated_2d_canvas = "never"

#Options
c.content.autoplay = False
c.content.notifications.enabled = False
c.session.lazy_restore = True
c.scrolling.smooth = True
c.completion.height = "20%"
