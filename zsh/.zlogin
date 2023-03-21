if [ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ -z "$TMUX" ]; then
  exec river
fi
