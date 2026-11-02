-- xmonad-style workspace switching: workspace N is shown on the monitor you are on.
-- Hyprland's plain focus({workspace=N}) jumps to whichever monitor owns N, which makes
-- the two screens look linked. Here: if the other screen shows N, swap the two screens;
-- if N is hidden on another monitor, pull it over; then focus it.
--
-- Global so scripts can call it too:  hyprctl dispatch 'ws_here(3)'

function ws_here(n)
    return function()
        local cur = hl.get_active_monitor()
        local ws  = hl.get_workspace(n)
        if cur and ws and ws.monitor and ws.monitor.name ~= cur.name then
            if ws.visible then
                hl.dispatch(hl.dsp.workspace.swap_monitors({
                    monitor1 = cur.name,
                    monitor2 = ws.monitor.name,
                }))
                return
            end
            hl.dispatch(hl.dsp.workspace.move({ workspace = n, monitor = cur.name }))
        end
        hl.dispatch(hl.dsp.focus({ workspace = n }))
    end
end
