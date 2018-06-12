if [ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ -z "$TMUX" ]; then
  exec startx
fi
