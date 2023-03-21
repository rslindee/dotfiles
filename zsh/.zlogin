# hardware acceleration for firefox
export MOZ_ENABLE_WAYLAND=1
# used for finding appropriate xdg-desktop-portal portal implementation
export XDG_CURRENT_DESKTOP=river
if [ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ -z "$TMUX" ]; then
  exec river
fi
