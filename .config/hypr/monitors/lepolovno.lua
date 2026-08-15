-- t590A (lepolovno) with external monitors (GDK 1x for 1080p)
local omarchy_gdk_scale = 1
hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))
hl.monitor({ output = "eDP-1", mode = "1920x1080@60", position = "auto", scale = 1 })
hl.monitor({ output = "DP-1", mode = "3840x1600@59.994", position = "auto", scale = 1 })
hl.monitor({ output = "DP-2", mode = "3840x2160@144", position = "auto", scale = 1 })
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })
