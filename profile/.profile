# Add scripts dir to $PATH
PATH="$PATH:$HOME/scripts"
sxhkd &
# call slock on screensaver or suspend
xss-lock slock &
mpd &
# run display fallback daemon
disp_fallbackd.sh &
# set print screen to winkey and caps lock to ctrl
setxkbmap -option altwin:prtsc_rwin,ctrl:nocaps & 
# Set only external monitor if connected
xrandr_util.sh -s
