# Autostart
sxhkd &
# call slock on screensaver or suspend
xss-lock slock &
mpd &
# run mons in daemon mode per documentation
nohup mons -a > /dev/null 2>&1 &
setxkbmap -option altwin:prtsc_rwin,ctrl:nocaps & 
# Set only external monitor if connected
if xrandr | grep " connected [^primary]"; then
    mons -s
fi
