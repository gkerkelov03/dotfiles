import os 

config.load_autoconfig(False) #don't allow config outside of this file

c.url.default_page = "https://google.com/gemini"
c.url.start_pages = "https://google.com/gemini"
c.url.searchengines = {
    "DEFAULT": "https://www.google.com/search?q={}",
    "yt": "https://www.youtube.com/results?search_query={}",
    "gh": "https://github.com/search?q={}",
}

c.aliases = {
    "ytmpv": "spawn --detach mpv --ytdl-format=best {url}",
    "src": "config-source",
    "inst": "open instagram.com"
}

c.tabs.background = True

config.bind("q", "clear-messages ;; jseval document.querySelector('video, audio').playbackRate = (document.querySelector('video, audio').playbackRate - 0.1).toFixed(1)")
config.bind("w", "clear-messages ;; jseval document.querySelector('video, audio').playbackRate = (document.querySelector('video, audio').playbackRate + 0.1).toFixed(1)")
config.bind("e", "clear-messages ;; jseval document.querySelector('video, audio').playbackRate = (document.querySelector('video, audio').playbackRate = 1)")

c.downloads.location.directory = os.path.expanduser("~/downloads")
c.fonts.default_family = "JetBrainsMono Nerd Font"

c.content.autoplay = False
c.content.notifications.enabled = False
c.content.dns_prefetch = False

c.auto_save.session = True
c.completion.height = "30%"

