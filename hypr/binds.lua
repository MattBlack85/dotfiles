-- Keybinds: xmonad defaults + myKeys from xmonad.hs, same muscle memory.
--
-- Every bind carries a description "Section::key label::text" that the SUPER+SHIFT+H popup
-- (eww/scripts/keys.sh) reads back from `hyprctl binds -j`. The key label is optional
-- (empty = use the real key); a bind without a description is simply not listed.

local P = require("programs")
local mod = "SUPER" -- xmonad myModMask = mod4Mask

local function bind(keys, dispatcher, desc, opts)
    opts = opts or {}
    opts.description = desc
    hl.bind(mod .. " + " .. keys, dispatcher, opts)
end

-- Programs
bind("SHIFT + Return", hl.dsp.exec_cmd(P.terminal),  "Programs::ENTER::Terminal")
bind("P",              hl.dsp.exec_cmd(P.launcher),  "Programs::P / D::App launcher")
bind("D",              hl.dsp.exec_cmd(P.launcher),  nil)
bind("V",              hl.dsp.exec_cmd("cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"),
     "Programs::::Clipboard history")

-- Windows
bind("SHIFT + C", hl.dsp.window.close(),                         "Windows::::Close window")
bind("T",         hl.dsp.window.float({ action = "toggle" }),    "Windows::::Toggle floating")
bind("F",         hl.dsp.window.fullscreen(),                    "Windows::::Toggle fullscreen")

-- M-S-a: kill all windows on the current workspace
bind("SHIFT + A", function()
    local ws = hl.get_active_workspace()
    if not ws then return end
    for _, w in ipairs(hl.get_workspace_windows(ws)) do
        hl.dispatch(hl.dsp.window.close({ window = w }))
    end
end, "Windows::::Close ALL on workspace")

-- Master layout (xmonad Tall)
bind("J",         hl.dsp.layout("cyclenext"),        "Layout::::Focus next window")
bind("K",         hl.dsp.layout("cycleprev"),        "Layout::::Focus previous window")
bind("SHIFT + J", hl.dsp.layout("swapnext"),         "Layout::::Swap with next")
bind("SHIFT + K", hl.dsp.layout("swapprev"),         "Layout::::Swap with previous")
bind("Return",    hl.dsp.layout("swapwithmaster"),   "Layout::ENTER::Swap with master")
bind("H",         hl.dsp.layout("mfact -0.03"),      "Layout::::Shrink master")
bind("L",         hl.dsp.layout("mfact +0.03"),      "Layout::::Expand master")
bind("space",     hl.dsp.layout("orientationnext"),  "Layout::SPACE::Next layout orientation")

-- Monitors (M-. / M-,)
bind("period",         hl.dsp.focus({ monitor = "+1" }),        "Monitors::.::Focus next monitor")
bind("comma",          hl.dsp.focus({ monitor = "-1" }),        "Monitors::,::Focus previous monitor")
bind("SHIFT + period", hl.dsp.window.move({ monitor = "+1" }),  "Monitors::.::Send window to next monitor")
bind("SHIFT + comma",  hl.dsp.window.move({ monitor = "-1" }),  "Monitors::,::Send window to previous monitor")

-- Workspaces 1-8 (only the first of each loop is described, as "1-8")
for i = 1, 8 do
    bind(tostring(i),     ws_here(i),                         i == 1 and "Workspaces::1-8::Show workspace" or nil)
    bind("SHIFT + " .. i, hl.dsp.window.move({ workspace = i }), i == 1 and "Workspaces::1-8::Move window to workspace" or nil)
end

-- Mouse: drag / resize (xmonad default mod+button1 / button3)
bind("mouse:272", hl.dsp.window.drag(),   "Mouse::LEFT DRAG::Move window",   { mouse = true })
bind("mouse:273", hl.dsp.window.resize(), "Mouse::RIGHT DRAG::Resize window", { mouse = true })

-- Session (M-C-r recompile, M-S-r / M-q restart -> reload; M-S-q quit)
bind("CTRL + R",  hl.dsp.reload_config(), "Session::::Reload config")
bind("SHIFT + R", hl.dsp.reload_config(), "Session::::Reload config")
bind("Q",         hl.dsp.reload_config(), "Session::::Reload config")
bind("SHIFT + Q", hl.dsp.exit(),          "Session::::Quit Hyprland")

-- Keyboard layout (it <-> us). Also switchable by clicking the flag in the eww bar.
bind("SHIFT + space", hl.dsp.exec_cmd("hyprctl switchxkblayout all next"), "Session::SPACE::Switch keyboard layout (IT / US)")

-- Lock the screen now (hyprlock, via hypridle's lock_cmd)
bind("CTRL + L", hl.dsp.exec_cmd("loginctl lock-session"), "Session::::Lock screen")

-- Help popup (SUPER+H is taken by "shrink master", so it lives on SHIFT+H)
bind("SHIFT + H", hl.dsp.exec_cmd("~/.config/eww/scripts/toggle_keys.sh"), "Session::::This keybind list")

-- Audio on the function keys (the Unicomp Model M has no media keys), laid out like a media row:
-- F7 prev | F8 next | F9 play/pause | F10 mute | F11 vol- | F12 vol+
local hold = { repeating = true }
bind("F7",  hl.dsp.exec_cmd("playerctl previous"),                            "Audio::::Previous track")
bind("F8",  hl.dsp.exec_cmd("playerctl next"),                                "Audio::::Next track")
bind("F9",  hl.dsp.exec_cmd("playerctl play-pause"),                          "Audio::::Play / pause")
bind("F10", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),    "Audio::::Mute")
bind("F11", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),     "Audio::::Volume down", hold)
bind("F12", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), "Audio::::Volume up",   hold)

-- Real media keys, for keyboards that have them (not listed in the popup)
local media = { locked = true, repeating = true }
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), media)
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      media)
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     media)
hl.bind("XF86AudioPlay",        hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause",       hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext",        hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPrev",        hl.dsp.exec_cmd("playerctl previous"),   { locked = true })
