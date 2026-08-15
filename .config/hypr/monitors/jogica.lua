-- t590A laptop with optional external monitors (GDK 1x)
local omarchy_gdk_scale = 1
hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))
hl.monitor({ output = "eDP-1", mode = "2880x1800@120", position = "auto", scale = 1.67 })
hl.monitor({ output = "DP-1", mode = "3840x1600@59.994", position = "auto", scale = 1 })
hl.monitor({ output = "DP-2", mode = "3840x2160@144", position = "auto", scale = 1 })
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })
