import os

config.load_autoconfig(False) #don't allow config outside of this file

c.content.headers.user_agent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36'
c.url.default_page = "https://google.com/gemini"
c.url.start_pages = "https://google.com/gemini"
c.url.searchengines = {
    "DEFAULT": "https://www.google.com/search?q={}",
    "g": "https://www.google.com/search?q={}",
    "ddg": "https://duckduckgo.com/?q={}",
    "yt": "https://www.youtube.com/results?search_query={}",
    "wiki": "https://en.wikipedia.org/wiki/{}",
    "gh": "https://github.com/search?q={}"
}

c.tabs.position = "top"
c.tabs.background = True
c.tabs.show = "multiple"
c.session.default_name = "default"


config.bind("q", "clear-messages ;; jseval document.querySelector('video, audio').playbackRate = (document.querySelector('video, audio').playbackRate - 0.1).toFixed(1)")
config.bind("w", "clear-messages ;; jseval document.querySelector('video, audio').playbackRate = (document.querySelector('video, audio').playbackRate + 0.1).toFixed(1)")
config.bind("e", "clear-messages ;; jseval document.querySelector('video, audio').playbackRate = (document.querySelector('video, audio').playbackRate = 1")


c.downloads.location.directory = os.path.expanduser("~/downloads")
c.downloads.position = "bottom"
c.downloads.remove_finished = 3000

c.content.javascript.enabled = True
c.content.autoplay = False
c.content.notifications.enabled = False
c.content.geolocation = False
c.content.dns_prefetch = False

c.aliases = {
    "ytmpv": "spawn --detach mpv --ytdl-format=best {url}"
}

c.zoom.default = "100%"
c.auto_save.session = True
c.completion.height = "30%"

# Hardware acceleration
c.qt.args = ["--enable-features=VaapiVideoDecoder"]
c.content.fullscreen.window = True
