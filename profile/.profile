# Autostart
sxhkd &
xautolock -time 10 -locker slock &
mpd &
mons -a &
setxkbmap -option altwin:prtsc_rwin,ctrl:nocaps & 
# Set only external monitor if connected
if xrandr | grep "DP-2 connected"; then
    xrandr --output eDP-1 --off --output DP-2 --auto
fi
