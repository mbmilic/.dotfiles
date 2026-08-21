-- Personal keybinding overrides.
-- See current bindings: omarchy menu keybindings --print

-- Tmux in current terminal's working directory (default opens without cwd awareness)
hl.unbind("SUPER + ALT + RETURN")
o.bind("SUPER + ALT + RETURN", "Tmux", 'uwsm-app -- xdg-terminal-exec --dir="$(omarchy-cmd-terminal-cwd)" tmux new')

-- File manager on SUPER+SHIFT+E (default is now Email in Quattro)
hl.unbind("SUPER + SHIFT + E")
o.bind("SUPER + SHIFT + E", "File manager", { launch = "nautilus --new-window" })

-- Toggle touchpad
hl.unbind("SUPER + SHIFT + T")
o.bind("SUPER + SHIFT + T", "Toggle touchpad", "~/.config/hypr/scripts/toggle_touchpad.sh")

-- Proton Mail (default SUPER+SHIFT+M is Spotify/Music)
hl.unbind("SUPER + SHIFT + M")
o.bind("SUPER + SHIFT + M", "Mail", "/usr/bin/proton-mail")

-- Full width on SUPER+SHIFT+F (default is now File manager in Quattro)
hl.unbind("SUPER + SHIFT + F")
o.bind("SUPER + SHIFT + F", "Full width", hl.dsp.window.fullscreen({ mode = "maximized" }))

-- Screenshot on SUPER+SHIFT+S (default preinstalled binding is Google Maps)
hl.unbind("SUPER + SHIFT + S")
o.bind("SUPER + SHIFT + S", "Screenshot", "omarchy-capture-screenshot")

-- Lid switch with external monitor awareness (custom clamshell script)
hl.unbind("switch:on:Lid Switch")
hl.unbind("switch:off:Lid Switch")
o.bind("switch:on:Lid Switch", nil, "~/.config/hypr/scripts/lid-switch.sh close", { locked = true })
o.bind("switch:off:Lid Switch", nil, "~/.config/hypr/scripts/lid-switch.sh open", { locked = true })

-- Force Brave for the browser keys (default browser is chromium via xdg-settings)
hl.unbind("SUPER + SHIFT + B")
o.bind(
	"SUPER + SHIFT + B",
	"Browser",
	{ launch = "brave --enable-features=UseOzonePlatform --ozone-platform=wayland --force-device-scale-factor=1" }
)

hl.unbind("SUPER + SHIFT + ALT + B")
o.bind("SUPER + SHIFT + ALT + B", "Browser (private)", { launch = "brave --incognito" })

-- ChatGPT opened directly in Brave (default binding opens app-mode in whatever xdg default browser is)
hl.unbind("SUPER + SHIFT + A")
o.bind("SUPER + SHIFT + A", "ChatGPT", { launch = "brave https://chatgpt.com" })

-- Web apps
-- o.bind("SUPER + SHIFT + A", "ChatGPT", { webapp = "https://chatgpt.com" })
-- o.bind("SUPER + SHIFT + ALT + A", "Grok", { webapp = "https://grok.com" })
-- o.bind("SUPER + SHIFT + C", "Calendar", { webapp = "https://app.hey.com/calendar/weeks/" })
-- o.bind("SUPER + SHIFT + Y", "YouTube", { webapp = "https://youtube.com/" })
-- o.bind("SUPER + SHIFT + ALT + G", "WhatsApp", { webapp = "https://web.whatsapp.com/", focus = true })
-- o.bind("SUPER + SHIFT + CTRL + G", "Google Messages", { webapp = "https://messages.google.com/web/conversations", focus = true })
-- o.bind("SUPER + SHIFT + X", "X", { webapp = "https://x.com/" })
-- o.bind("SUPER + SHIFT + ALT + X", "X Post", { webapp = "https://x.com/compose/post" })
