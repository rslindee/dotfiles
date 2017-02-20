#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

xbindkeys

sudo mount richnas:/mnt/5tera /mnt/5tera
sudo mount richnas:/mnt/3Tera /mnt/3Tera
sudo mount richnas:/mnt/hit1 /mnt/hit1
sudo mount richnas:/mnt/hit2 /mnt/hit2
sudo mount richnas:/mnt/GREEN1000 /mnt/GREEN1000

google-musicmanager
exec i3
