# Autostart
sxhkd &
# call slock on screensaver or suspend
xss-lock slock &
mpd &
mons -a &
setxkbmap -option altwin:prtsc_rwin,ctrl:nocaps & 
# Set only external monitor if connected
if xrandr | grep " connected [^primary]"; then
    mons -s
fi
