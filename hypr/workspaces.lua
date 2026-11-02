-- xmonad myWorkspaces. Workspaces keep numeric ids (1-8) so SUPER+N works,
-- and get the xmonad names as display names (shown in the eww bar).

local names = { "image", "web", "emacs", "terms", "video", "chat", "mix", "sound" }

for i, name in ipairs(names) do
    hl.workspace_rule({
        workspace    = tostring(i),
        default_name = name,
        persistent   = true,
    })
end
