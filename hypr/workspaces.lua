-- xmonad myWorkspaces. Workspaces keep numeric ids (1-8) so SUPER+N works,
-- and get the xmonad names as display names (shown in the eww bar).

local names = { "graphics", "web", "emacs", "terms", "gaming", "chat", "mix", "sound" }

-- Start with a different workspace on each screen. After that any screen can show
-- any workspace (see wsfocus.lua), like xmonad.
local home = { [1] = "DP-3", [2] = "DP-2" }

for i, name in ipairs(names) do
    hl.workspace_rule({
        workspace    = tostring(i),
        default_name = name,
        persistent   = true,
        monitor      = home[i],
        default      = home[i] and true or nil,
    })
end
