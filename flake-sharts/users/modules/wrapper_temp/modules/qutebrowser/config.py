# TODO: Make not shit
config.load_autoconfig()
c.auto_save.session = True

c.url.auto_search = "naive"
c.url.searchengines['DEFAULT'] = "https://search.brave.com/search?q={}"
c.url.searchengines['aw'] = "https://wiki.archlinux.org/?search={}"
c.url.searchengines['g'] = "https://www.google.com/search?hl=en&q={}"
c.url.searchengines['gh'] = "https://github.com/{}"
c.url.searchengines['ghr'] = "https://github.com/search?q={}&type=repositories"
c.url.searchengines['hm'] = "https://home-manager-options.extranix.com/?query={}&release=master"
c.url.searchengines['inv'] = "http://inv.fluorine.lan/search?q={}"
c.url.searchengines['noog'] = "https://noogle.dev/q?term={}"
c.url.searchengines['no'] = "https://search.nixos.org/options?query={}"
c.url.searchengines['nou'] = "https://search.nixos.org/options?channel=unstable&query={}"
c.url.searchengines['np'] = "https://search.nixos.org/packages?query={}"
c.url.searchengines['npu'] = "https://search.nixos.org/packages?channel=unstable&query={}"
c.url.searchengines['nw'] = "https://wiki.nixos.org/w/index.php?search={}"
c.url.searchengines['yt'] = "https://www.youtube.com/results?search_query={}"

# Escape to deselect input fields
config.bind("<Escape>", "mode-leave ;; jseval -q document.activeElement.blur()", mode="insert")

# Tab navigation
config.bind(",", "tab-prev", mode="normal")
config.bind(".", "tab-next", mode="normal")
config.bind("<", "back", mode="normal")
config.bind(">", "forward", mode="normal")

# FIXME: Can't swallow
config.bind("<Ctrl+F>", "hint links spawn gobble brave {hint-url}", mode="normal")
config.bind("<Ctrl+G>", "spawn gobble brave {url}", mode="normal")

# Rebind to have operators
config.bind("dd", "tab-close", mode="normal")
config.bind("rr", "reload", mode="normal")
config.bind("uu", "undo", mode="normal")

config.unbind('d', mode='normal')
config.unbind('r', mode='normal')
config.unbind('u', mode='normal')

# qute-keepassxc
config.bind("pw", "spawn --userscript qute-keepassxc --key 682D163ED56008C1A787BCEA6E9A2F35535BE87F", mode="normal")
config.bind("<Ctrl+P>", "spawn --userscript qute-keepassxc --key 682D163ED56008C1A787BCEA6E9A2F35535BE87F", mode="insert")

c.colors.webpage.bg = ""
c.colors.webpage.darkmode.algorithm = "lightness-cielab"
c.colors.webpage.darkmode.enabled = False # Outdated?
c.colors.webpage.preferred_color_scheme = "dark"

c.content.autoplay = False
c.content.headers.accept_language = "en-US,en;q=0.5"
c.content.headers.custom = {"accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"}
c.content.headers.user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0.0.0 Safari/537.36"

c.downloads.prevent_mixed_content = True
c.content.blocking.enabled = True
c.content.blocking.method = "both"

c.content.blocking.hosts.lists = ["https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"]

c.content.blocking.adblock.lists = ["https://github.com/uBlockOrigin/uAssets/raw/master/filters/legacy.txt", "https://github.com/uBlockOrigin/uAssets/raw/master/filters/annoyances-cookies.txt", "https://github.com/uBlockOrigin/uAssets/raw/master/filters/annoyances-others.txt", "https://github.com/uBlockOrigin/uAssets/raw/master/filters/annoyances.txt", "https://github.com/uBlockOrigin/uAssets/raw/master/filters/badlists.txt", "https://github.com/uBlockOrigin/uAssets/raw/master/filters/badlists.txt", "https://github.com/uBlockOrigin/uAssets/raw/master/filters/badware.txt", "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2020.txt", "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2021.txt", "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2022.txt", "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2023.txt", "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2024.txt", "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters.txt", "https://github.com/uBlockOrigin/uAssets/raw/master/filters/lan-block.txt", "https://github.com/uBlockOrigin/uAssets/raw/master/filters/privacy.txt", "https://github.com/uBlockOrigin/uAssets/raw/master/filters/quick-fixes.txt", "https://github.com/uBlockOrigin/uAssets/raw/master/filters/resource-abuse.txt", "https://github.com/uBlockOrigin/uAssets/raw/master/filters/unbreak.txt"]
