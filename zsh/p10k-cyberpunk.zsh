# Fixes for ~/.p10k.zsh with the cyberpunk Alacritty palette (alacritty/alacritty.toml).
# p10k's config uses ANSI colors 0-15 that assumed a stock palette. Here color 0 equals the
# terminal background (segments vanish) and color 4 is bright cyan (light text on it is unreadable).
# Sourced from .zshrc right after ~/.p10k.zsh.
() {
  local v
  # Backgrounds: black would be invisible (dark gray instead); green and cyan are toned down.
  for v in ${(k)parameters[(I)POWERLEVEL9K_*_BACKGROUND]}; do
    case ${(P)v} in
      0) typeset -g $v=236 ;;  # black -> dark gray
      2) typeset -g $v=36 ;;   # bright green -> darker green (#00af87)
      4) typeset -g $v=38 ;;   # bright cyan -> darker blue (#00afd7)
    esac
  done
  # Directory: dark text on the bright cyan background.
  typeset -g POWERLEVEL9K_DIR_FOREGROUND=0
  typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND=0
  typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=0
}
