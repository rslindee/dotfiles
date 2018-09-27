# Autostart
# Start xbindkeys (daemon mode)
xbindkeys
# TODO: Fedora seems to start this before xmodmap gets called, so I'm just calling it again
xmodmap ~/.Xmodmap
# xcape map tapping left control to escape (daemon mode)
xcape -e 'Control_L=Escape'
# Start devmon
devmon &
# Enable xautolock process
xautolock -time 10 -locker 'i3lock --color=600000 && sleep .1 && xset dpms force off' &
