#!/bin/bash
# Fail right away
set -e

# TODO: Confirm how/if these need to be installed on new system
# xdg-utils xorg-xmodmap

ALL_PACKAGES="atool \
    cgdb \
    chromium \
    clang \
    ctags \
    fontconfig \
    i3-wm \
    mpd \
    mpv \
    ncmpcpp \
    neomutt \
    newsboat \
    python \
    qutebrowser \
    ranger \
    renameutils \
    stow \
    sxiv \
    tmux \
    vim \
    xclip \
    zathura \
    zsh"

PACKAGES_FEDORA="st \
    terminus-fonts-console"

FEDORA_COPR_REPOS="fszymanski/newsboat \
    flatcap/neomutt"

PACKAGES_ARCH="terminus-font"
PACKAGES_AUR="st"

STOW_LIST="cgdb \
    clang \
    ctags \
    fontconfig \
    git \
    i3 \
    mimeapps \
    mpd \
    mutt \
    ncmpcpp \
    qutebrowser \
    ranger \
    ssh \
    tmux \
    vim \
    zsh"

STOW_LIST_PRIVATE="newsboat"

# Get OS version
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$NAME
fi

if [ "$OS" = "Fedora" ]; then
    echo "Fedora system detected..."
    PKG_MANAGER_INSTALL="sudo dnf install"
    # Setup RPM Fusion
    sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
    # Install copr plugins package first
    $PACKAGE_MANAGER_INSTALL dnf-plugins-core
    # TODO how do we handle multiple COPR repos (e.g. single command)?
    sudo dnf copr enable $FEDORA_COPR_REPOS
    # Create package list
    ALL_PACKAGES="$ALL_PACKAGES $PACKAGES_FEDORA $PACKAGES_AUR"
elif [ "$OS" = "Arch Linux" ]; then
    echo "Arch system detected..."
    # Install trizen
    git clone https://aur.archlinux.org/trizen.git $HOME/trizen
    cd $HOME/trizen
    makepkg -si
    PKG_MANAGER_INSTALL="trizen -S"
    # Create package list
    ALL_PACKAGES="$ALL_PACKAGES $PACKAGES_ARCH $PACKAGES_AUR"
fi

# Install packages
$PKG_MANAGER_INSTALL $ALL_PACKAGES

# Stow dotfiles
cd $HOME/dotfiles
stow $STOW_LIST

# Clone private repos
git clone git@gitlab.com:rslindee/wiki.git $HOME/wiki
git clone git@gitlab.com:rslindee/dotfiles-private.git $HOME/dotfiles-private

# Stow private dotfiles
cd $HOME/dotfiles-private
stow $STOW_LIST_PRIVATE
