# CLAUDE.md

Personal dotfiles for an Arch Linux desktop (hostname `arcturus`, user `matt`).
Remote: `github.com/MattBlack85/dotfiles`, branch `main`.

## Status: Hyprland (Wayland) is the only desktop; XMonad (X11) has been removed

The migration from XMonad is done. Hyprland 0.57 runs from this repo's Lua config (started with
`start-hyprland` from a zsh login on a tty; there is no display manager). On 2026-11-02 the XMonad/X11
packages were uninstalled (xmonad, xmonad-contrib, xmobar, rxvt-unicode, dmenu, feh, xorg-server, xterm,
the Xorg GPU drivers, rofi, xdotool, wallust, waybar and the Haskell libraries only they needed) and the files
were deleted from the repo: `.xmonad/xmonad.hs`, `.xmobarrc`, `.xinitrc`, `.Xdefaults`, `trayer.sh`. They are in
git history (before the "Remove XMonad" commit) if ever needed; comments in `hypr/*.lua` that say
"ported from xmonad.hs" refer to them. Kept on purpose: `xorg-xwayland` (Hyprland, Steam), `xorg-xrandr`
(Steam), `xorg-xinit` (tigervnc), `xclip`/`xsel`, `playerctl` (audio keys; marked explicit).

## Hyprland side

`hypr/hyprland.lua` is the entry point and `require()`s modules from the same directory:
- `programs.lua`: terminal (kitty), editor (emacsclient), launcher (fuzzel). Returns a table.
- `monitors.lua`: DP-3 1920x1080 at 0x123 (left), DP-2 2560x1440 at 1920x0 (right, the big one).
  X11 names DisplayPort-1/2 are DP-2/DP-3 on Wayland.
- `look.lua`: master layout (≈ xmonad Tall), gaps 8/16, border 3 with a cyan→magenta gradient on the
  focused window, keyboard layouts `it,us`.
- `workspaces.lua`: persistent ids 1-8 named graphics, web, emacs, terms, gaming, chat, mix, sound.
  Workspace 1 starts on DP-3 and 2 on DP-2.
- `wsfocus.lua`: global `ws_here(n)` = xmonad-style switching. Workspace N is shown on the monitor you are
  on, swapping with the other screen if it shows N. Plain `focus({workspace=N})` jumps to the monitor that
  owns N, which makes the two screens look linked. Used by `SUPER+N` and the eww workspace buttons.
- `rules.lua`: floats, app→workspace placement (`silent`, like doShift: firefox 2, emacs 3, kitty 4,
  steam 5, slack 6, pavucontrol 8) and `slack-no-self-fullscreen` (Slack fullscreens itself and covers the bar).
- `binds.lua`: xmonad default keys + myKeys. **Every bind has a description** `"Section::key label::text"`
  (key label optional) which the keybinds popup reads from `hyprctl binds -j`; binds without one are not listed.
  Notable: `SUPER+SHIFT+H` keybinds popup (`SUPER+H` is xmonad's "shrink master"), `SUPER+SHIFT+space`
  switch keyboard layout, `SUPER+F7..F12` prev/next/play/mute/vol-/vol+ (the Unicomp Model M has no media keys;
  `XF86Audio*` binds are kept but unlisted), `SUPER+SHIFT+A` kill-all (a Lua function).
- `autostart.lua`: `hl.on("hyprland.start", ...)`: polkit agent, cliphist, dunst, awww-daemon, wallpapers
  (DP-2 `main.png`, DP-3 `second.jpg`, from `~/.local/share/wallpapers/`, **outside the repo**), eww bars on both
  monitors, then emacs daemon, firefox, pavucontrol, slack, steam, editor, terminal.

## eww bar (`eww/`)

- `eww.yuck`: windows `bar [monitor]` (opened with `eww open-many bar:bar0 bar:bar1 --arg bar0:monitor=0
  --arg bar1:monitor=1`), `weather-input [monitor]` (click the weather item) and `keys [monitor]` (keybinds popup).
  Three floating segments: workspaces (+ `HOSTNAME//` tag), CPU/GPU/memory with icons and meters, and
  keyboard flag / volume / weather / date / time.
- `eww.scss`: cyberpunk palette `#0a0a12` bg, `#46d9ff` cyan, `#ff2a6d` magenta, `#f9f002` yellow, `#5a6078` dim,
  `#d6e4ff` text. The same palette is in `hypr/look.lua`, `kitty/kitty.conf` and `fuzzel/fuzzel.ini`.
- `eww/scripts/`: `workspaces_json.sh` (workspaces 1-8 only; Hyprland creates a hidden extra one on its own),
  `workspaces.sh` (old text version), `cpu.sh`, `gpu.sh` (AMD sysfs), `mem.sh`, `get_volume.sh`,
  `kb_layout.sh` (flag, click or shortcut switches), `weather.sh` + `set_location.sh` (location stored in
  `~/.config/eww/location`, empty = IP guess), `keys.sh` + `toggle_keys.sh` (keybinds popup).
- Fonts: JetBrainsMono Nerd Font for the bar, **Orbitron** for the popup. Orbitron is not in the repos;
  `arch/arch_post.sh` downloads it to `/usr/local/share/fonts/orbitron/`.

### eww 0.5.0 gotchas
- `:exclusive true` only reserves space if the geometry has an `:anchor`.
- No `:truncate` attribute and no `eww poll`; use `eww update VAR=...` to push a poll variable.
- A layer window with no explicit `:width` gets its minimum size and labels collapse to `…`.
- `centerbox` splits the free space equally, which squeezed the left segment; the bar uses a plain `box`.
- `eww reload` sometimes prints `Error reading response from server`; it usually applied anyway.
- The daemon does not see fonts installed after it started, and a stuck daemon ignores `eww kill`
  (kill its PID, then `eww daemon`). Start it detached or the command hangs.
- `:initial` on `defpoll`s avoids `Failed to turn '' into a value of type ...` at startup.

## Deployed vs repo (`~/.config`)

- Symlinked to the repo: `hypr`, `fuzzel`, `eww/eww.yuck`, `eww/eww.scss`, `eww/scripts`,
  plus `~/.zshrc` and `~/.emacs`.
- **`~/.config/kitty` is NOT linked**: it is a real directory with an old config (own colors, FantasqueSansM font),
  so the repo's `kitty/kitty.conf` (cyberpunk colors) is not in use. TODO: back it up and symlink.
- `waybar`, `wallust`, `rofi`, `swaync` and `ags` in `~/.config` are leftover configs of the old JaKooLit
  Hyprland-Dots install (backup in `~/.config/backup-jakoolit-20261102/`), all unused; their packages are
  uninstalled.
- `hypr/` also contains Emacs backups (`*.conf~`) of the old hyprlang files; `.gitignore` ignores `*~`.

## Hyprland 0.57 config is Lua
Hyprland reads `~/.config/hypr/hyprland.lua`. hyprlang (`.conf`, `source=`, `bind =`) is rejected.
- Reference default: `/usr/share/hypr/hyprland.lua`; API stubs: `/usr/share/hypr/stubs/hl.meta.lua`.
- **Always validate:** `Hyprland --verify-config -c ~/dotfiles/hypr/hyprland.lua` → `config ok`.
  It checks dispatcher args (`hl.dsp.focus({bogus=1})` errors and lists valid keys) and window-rule fields.
  NOT validated: layout messages, `window.close({...})`, extra keys on `focus({workspace=...})`,
  `suppress_event` values. Never run it without `-c` (it writes a default `~/.config/hypr/hyprland.lua`).
- Don't call `hl.exec_cmd` at top level (breaks the checker); put it inside `hl.on("hyprland.start", ...)`.
- `require("x")` resolves relative to the config file's directory.
- `hyprctl dispatch '<lua expression>'` evaluates `hl.dispatch(<expr>)`: the expression must return a
  dispatcher or a Lua function, e.g. `hyprctl dispatch 'ws_here(3)'` or
  `hyprctl dispatch 'hl.dsp.workspace.rename({ workspace = 5, name = "gaming" })'`.
- `hyprctl reload` does not rename workspaces that already exist; rename them live as above.
- Keyboard: `hyprctl switchxkblayout all next`, state in `hyprctl devices -j` (`active_keymap`).
- Screenshots: `grim -o DP-2 file.png` (installed). Useful for checking visual changes.

## Next steps
1. Optional disk cleanup of XMonad leftovers outside the repo: `~/.xmonad/` (build cache), `~/.Xauthority`,
   `~/.local/bin/kernel` (an xmobar helper), `~/.config/{waybar,wallust,rofi,swaync,ags}`.
2. Link `~/.config/kitty` to the repo (ask first, back up the old directory) and add it to `arch_post.sh`.
3. Install `hyprlock` + `hypridle` (no screen lock or idle handling at the moment).
4. `arch/arch_post.sh` still sets `SCRIPT_HOSTNAME=albireo` but the machine is `arcturus`, and its package
   list lacks eww, fuzzel, awww, grim, jq, playerctl, steam. The wallpapers in `~/.local/share/wallpapers/` are not reproducible from the repo.

## Other contents
- `arch/install.sh`: bootstraps the system and downloads `arch_post.sh` **from GitHub `main`** into the
  chroot, so changes to `arch_post.sh` only take effect once pushed. `arch/arch_post.sh`: post-install.
- `zsh/.zshrc` (oh-my-zsh + powerlevel10k), `.emacs`, `bash/`.
- `audio/scripts/install.sh`: installs audio/guitar plugins (guitarix, carla, reaper, ardour...). Untracked.

## Conventions
- Configs are deployed by **symlinking** repo files into `$HOME` / `~/.config`
  (see the `ln -s` block in `arch/arch_post.sh`). New configs should follow that and be added there.
- Don't commit `*~` files (`.gitignore` covers them). Keep the user's unrelated uncommitted edits
  (`.emacs`, `.zshrc`, `audio/`) out of commits unless asked.
- Commit messages: short, imperative, no prefix (e.g. "Add GPU meter and weather location input to eww bar").
- Never read `.env` / `.envrc` files.
- Don't use broad `pkill` patterns (`pkill kitty` would kill the user's terminals); kill by exact PID or an
  anchored command line.
