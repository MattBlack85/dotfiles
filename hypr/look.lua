-- Look, layout and input. Colors/sizes mirror xmonad.hs.

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.config({
    general = {
        -- xmonad mySpacing 8: 8px around each window and 8px screen border
        gaps_in  = 8,
        gaps_out = 16,

        border_size = 3,                   -- myBorderWidth
        col = {
            -- cyberpunk: cyan -> magenta gradient on focus, near-black otherwise
            active_border   = { colors = { "rgb(46d9ff)", "rgb(ff2a6d)" }, angle = 45 },
            inactive_border = "rgb(1a1a2e)",
        },

        -- "master" is the closest thing to xmonad's ResizableTall
        layout = "master",
    },

    master = {
        new_status = "master", -- like xmonad: new windows become master
        mfact      = 0.5,
    },

    -- Groups = tabs (terminals open grouped, see rules.lua; ALT+Tab switches, binds.lua)
    group = {
        auto_group = true,
        col = {
            border_active   = { colors = { "rgb(46d9ff)", "rgb(ff2a6d)" }, angle = 45 },
            border_inactive = "rgb(1a1a2e)",
        },
        groupbar = {
            enabled        = true,
            font_family    = "JetBrainsMono Nerd Font",
            font_size      = 12,
            height         = 24,
            gradients      = true,
            render_titles  = true,
            indicator_height = 3,
            col = {
                active   = "rgb(46d9ff)",   -- cyan
                inactive = "rgb(1a1a2e)",   -- dark panel
            },
            text_color          = "rgb(0a0a12)",   -- on the cyan active tab
            text_color_inactive = "rgb(d6e4ff)",
        },
    },

    decoration = {
        rounding = 0,
        shadow   = { enabled = false },
        blur     = { enabled = true, size = 3, passes = 1 },
    },

    animations = {
        enabled = true,
    },

    input = {
        kb_layout    = "it,us",   -- first is the default; switch with SUPER+SHIFT+space or click the bar flag
        follow_mouse = 1,
        sensitivity  = 0,
    },

    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo   = true,
    },
})
