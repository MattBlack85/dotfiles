-- Terminals as tabs: every new Alacritty window is added to the group of an existing
-- Alacritty window, so they behave like tabs (one visible, filling the space).
-- ALT+Tab switches tab (binds.lua). The first terminal starts its own group (rules.lua).
hl.on("window.open", function(w)
    if not w or w.class ~= "Alacritty" then return end
    for _, o in ipairs(hl.get_windows()) do
        if o ~= w and o.class == "Alacritty" and o.group and o.group ~= w.group then
            o.group:add(w)
            return
        end
    end
end)
