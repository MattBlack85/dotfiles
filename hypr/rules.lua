-- Window rules, ported from xmonad myManageHook.
-- Wayland app classes differ from X11; check real ones with `hyprctl clients`.

-- Floats (xmonad: doFloat)
hl.window_rule({
    name  = "float-dialogs",
    match = { class = "(?i)^(confirm|file_progress|dialog|download|error|gimp|notification|toolbar)$" },
    float = true,
})

hl.window_rule({
    name  = "float-firefox-dialogs",
    match = { class = "^(firefox)$", title = "^(Library|Picture-in-Picture)$" },
    float = true,
})

-- App -> workspace (xmonad: doShift, which doesn't follow the window)
local placements = {
    { class = "^(firefox)$",                       ws = "2" }, -- web
    { class = "(?i)^(emacs)$",                     ws = "3" }, -- emacs
    { class = "^(Alacritty)$",                     ws = "4" }, -- terms
    { class = "(?i)^(slack)$",                     ws = "6" }, -- chat
    { class = "^(steam)$",                         ws = "5" }, -- gaming
    { class = "(?i)^(org\\.pulseaudio\\.)?pavucontrol$", ws = "8" }, -- sound
}

for _, p in ipairs(placements) do
    hl.window_rule({
        name      = "place-" .. p.ws .. "-" .. p.class,
        match     = { class = p.class },
        workspace = p.ws .. " silent",
    })
end

-- Slack asks to go fullscreen on its own, which covers the eww bar. Ignore that
-- (SUPER+F still toggles fullscreen when you want it).
hl.window_rule({
    name           = "slack-no-self-fullscreen",
    match          = { class = "(?i)^(slack)$" },
    suppress_event = "fullscreen fullscreenoutput",
})

-- From the Hyprland default config
hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})
