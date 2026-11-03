-- xmonad myStartupHook. Window rules in rules.lua route apps to workspaces.

local P = require("programs")
local wallpaper = "~/data/Downloads/bubble-hst-3412x3240.png"

hl.on("hyprland.start", function()
    -- Session plumbing
    hl.exec_cmd("systemctl --user start hyprpolkitagent")    -- password prompts for GUI apps
    hl.exec_cmd("wl-paste --type text  --watch cliphist store") -- clipboard history
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    -- xdg-desktop-portal-hyprland is D-Bus activated, no exec needed
    hl.exec_cmd("dunst")
    hl.exec_cmd("hypridle")   -- idle: screensaver after 5 min, screens off after 15 (hypr/hypridle.conf)
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("sleep 1 && awww img " .. wallpaper)
    -- Wallpapers: DP-2 (big) and DP-3 each get their own image.
    hl.exec_cmd("sleep 2 && awww img -o DP-2 --resize crop ~/.local/share/wallpapers/main.png")
    hl.exec_cmd("sleep 2 && awww img -o DP-3 --resize crop ~/.local/share/wallpapers/second.jpg")
    -- eww bar on both monitors (xmobar ran on both too)
    hl.exec_cmd("eww open-many bar:bar0 bar:bar1 --arg bar0:monitor=0 --arg bar1:monitor=1")

    -- Apps
    hl.exec_cmd("emacs --daemon")
    hl.exec_cmd("firefox")
    hl.exec_cmd("pavucontrol")
    hl.exec_cmd("slack")
    hl.exec_cmd("steam")
    hl.exec_cmd("sleep 3 && " .. P.editor) -- give the emacs daemon time to come up
    hl.exec_cmd(P.terminal)
end)
