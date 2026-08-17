-- Personal window rule overrides. Loaded after Omarchy's defaults, so these
-- take precedence (Hyprland applies matching rules top to bottom, last wins).

-- The bar's CPU widget opens btop via omarchy-launch-or-focus-tui, which tags
-- it org.omarchy.btop. Omarchy's default rules add the floating-window tag to
-- that class, which floats+centers+sizes it. Strip the tag so it opens as a
-- normal tiled window instead.
o.window("org.omarchy.btop", { tag = "-floating-window" })
