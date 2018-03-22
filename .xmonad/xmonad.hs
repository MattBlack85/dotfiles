import XMonad
import XMonad.Actions.SpawnOn


myWorkspaces = ["web", "editor", "terms", "socials"]

main = do
  xmonad $ defaultConfig
    { terminal           = "urxvt"
    , modMask            = mod4Mask
    , borderWidth        = 3
    , workspaces         = myWorkspaces
    , focusedBorderColor = "#00BFFF"
    , normalBorderColor  = "#000000"
    , manageHook = manageSpawn
    , startupHook        = do
        spawnOn "editor" "emacs"
        spawnOn "web" "firefox"
        spawnOn "terms" "urxvt"
        spawnOn "terms" "urxvt"
        spawnOn "terms" "urxvt"
        spawnOn "socials" "rambox"
    }
