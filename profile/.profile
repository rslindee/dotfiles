# Autostart
# Start xbindkeys
xbindkeys &
# xcape map tapping left control to escape
xcape -e 'Control_L=Escape' &
# Start devmon
devmon &
# Enable xautolock process
xautolock -time 10 -locker 'i3lock --color=600000 && sleep .1 && xset dpms force off' &
