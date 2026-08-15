-- Gigabyte desktop setup (GDK 1x for 4K at native scale)
local omarchy_gdk_scale = 1
hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))
hl.monitor({ output = "DP-2", mode = "3840x2160@144", position = "auto", scale = 1 })
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })
