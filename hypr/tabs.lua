-- Terminals as tabs, and the SUPER+SPACE cycle (binds.lua).
-- Hyprland groups = tabs. Modes, in cycle order:
--   tabbed -> master on left -> top -> right -> bottom -> center -> tabbed ...
-- tabbed: all Alacritty windows are tabs of one group (one visible, filling the space) and new ones join it.
-- other modes: every terminal is a separate tile, laid out by the master layout orientation, and new ones tile too.
-- (Every Alacritty window starts as a group of its own via rules.lua; a group of one shows no tab bar.)
local M = {}

local modes = { "tabbed", "left", "top", "right", "bottom", "center" }
local idx = 1

local function terminals()
    local t = {}
    for _, w in ipairs(hl.get_windows()) do
        if w.class == "Alacritty" then t[#t + 1] = w end
    end
    return t
end

-- First terminal that is in a group (the anchor all the others are added to)
local function anchor(ts, except)
    for _, w in ipairs(ts) do
        if w ~= except and w.group then return w end
    end
end

function M.mode() return modes[idx] end

hl.on("window.open", function(w)
    if modes[idx] ~= "tabbed" then return end
    if not w or w.class ~= "Alacritty" then return end
    local a = anchor(terminals(), w)
    if a and a.group ~= w.group then a.group:add(w) end
end)

-- SUPER+SPACE
function M.cycle()
    idx = idx % #modes + 1
    local m = modes[idx]
    local ts = terminals()
    local a = anchor(ts)
    if m == "tabbed" then
        if a then
            for _, w in ipairs(ts) do
                if w ~= a and (not w.group or w.group ~= a.group) then a.group:add(w) end
            end
        end
    else
        if m == "left" and a then   -- leaving tabbed: split the tabs into separate tiles
            for _, w in ipairs(ts) do
                if w ~= a and w.group and w.group == a.group then a.group:remove(w) end
            end
        end
        hl.dispatch(hl.dsp.layout("orientation" .. m))
    end
    hl.exec_cmd('notify-send -t 1200 -h string:x-dunst-stack-tag:layout "Layout" "' .. m .. '"')
end

return M
