-- Keybinds: xmonad defaults + myKeys from xmonad.hs, same muscle memory.

local P = require("programs")
local mod = "SUPER" -- xmonad myModMask = mod4Mask

local function bind(keys, dispatcher, opts)
    hl.bind(mod .. " + " .. keys, dispatcher, opts)
end

-- Programs
bind("SHIFT + Return", hl.dsp.exec_cmd(P.terminal))  -- xmonad default
bind("P",              hl.dsp.exec_cmd(P.launcher))  -- xmonad default (dmenu)
bind("D",              hl.dsp.exec_cmd(P.launcher))
bind("V",              hl.dsp.exec_cmd("cliphist list | fuzzel --dmenu | cliphist decode | wl-copy")) -- clipboard history

-- Windows
bind("SHIFT + C", hl.dsp.window.close())             -- xmonad default kill
bind("T",         hl.dsp.window.float({ action = "toggle" })) -- xmonad M-t (sink)
bind("F",         hl.dsp.window.fullscreen())

-- M-S-a: kill all windows on the current workspace
bind("SHIFT + A", function()
    local ws = hl.get_active_workspace()
    if not ws then return end
    for _, w in ipairs(hl.get_workspace_windows(ws)) do
        hl.dispatch(hl.dsp.window.close({ window = w }))
    end
end)

-- Master layout (xmonad Tall)
bind("J",         hl.dsp.layout("cyclenext"))        -- focus next
bind("K",         hl.dsp.layout("cycleprev"))        -- focus prev
bind("SHIFT + J", hl.dsp.layout("swapnext"))
bind("SHIFT + K", hl.dsp.layout("swapprev"))
bind("Return",    hl.dsp.layout("swapwithmaster"))
bind("H",         hl.dsp.layout("mfact -0.03"))      -- shrink master
bind("L",         hl.dsp.layout("mfact +0.03"))      -- expand master
bind("space",     hl.dsp.layout("orientationnext"))  -- closest to "next layout"

-- Monitors (M-. / M-,)
bind("period",         hl.dsp.focus({ monitor = "+1" }))
bind("comma",          hl.dsp.focus({ monitor = "-1" }))
bind("SHIFT + period", hl.dsp.window.move({ monitor = "+1" }))
bind("SHIFT + comma",  hl.dsp.window.move({ monitor = "-1" }))

-- Workspaces 1-8
for i = 1, 8 do
    bind(tostring(i),             hl.dsp.focus({ workspace = i }))
    bind("SHIFT + " .. i,         hl.dsp.window.move({ workspace = i }))
end

-- Mouse: drag / resize (xmonad default mod+button1 / button3)
bind("mouse:272", hl.dsp.window.drag(),   { mouse = true })
bind("mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Session (M-C-r recompile, M-S-r / M-q restart -> reload; M-S-q quit)
bind("CTRL + R",  hl.dsp.reload_config())
bind("SHIFT + R", hl.dsp.reload_config())
bind("Q",         hl.dsp.reload_config())
bind("SHIFT + Q", hl.dsp.exit())

-- Media keys
local media = { locked = true, repeating = true }
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), media)
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      media)
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     media)
hl.bind("XF86AudioPlay",        hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause",       hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext",        hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPrev",        hl.dsp.exec_cmd("playerctl previous"),   { locked = true })
