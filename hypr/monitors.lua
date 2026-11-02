-- Same layout as the xrandr line in .xinitrc.
-- Wayland connector names differ from X11: DisplayPort-1 -> DP-2, DisplayPort-2 -> DP-3.

-- 1080p on the left, shifted down to line up with the 1440p screen
hl.monitor({
    output   = "DP-3",
    mode     = "1920x1080@60",
    position = "0x123",
    scale    = 1,
})

-- 1440p on the right (xrandr used x=1937; 1920 avoids a 17px dead zone between screens)
hl.monitor({
    output   = "DP-2",
    mode     = "2560x1440@60",
    position = "1920x0",
    scale    = 1,
})

-- Anything else that gets plugged in
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})
