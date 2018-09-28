#!/bin/bash
# Fail right away and prevent use of undefined vars
set -eu

# TODO: Confirm how/if these need to be installed on new system
# xdg-utils xorg-xmodmap

ALL_PACKAGES="atool \
    autoconf \
    cgdb \
    chromium \
    clang \
    cmus \
    ctags \
    fontconfig \
    fzf \
    i3lock \
    mpd \
    mpv \
    ncmpcpp \
    pass \
    python \
    qutebrowser \
    ranger \
    renameutils \
    ripgrep \
    socat \
    sshfs \
    stow \
    sxiv \
    tmux \
    udisks2 \
    vim \
    xbindkeys \
    xcape \
    xclip \
    zathura \
    zsh"

PACKAGES_FEDORA="st \
    i3 \
    ImageMagick \
    fd-find \
    passmenu \
    python3 \
    python3-tldextract \
    terminus-fonts \
    terminus-fonts-console \
    unifont-fonts"

# TLP is Thinkpad-specific
PACKAGES_LAPTOP="acpi \
    acpid \
    powertop \
    tlp \
    tlp-rdw"

# TODO Fedora RPMSphere
# udevil

FEDORA_COPR_REPOS="flatcap/neomutt"

PACKAGES_ARCH="terminus-font \
    i3-wm \
    imagemagick \
    neomutt \
    fd \
    newsboat \
    python-tldextract \
    udevil"

PACKAGES_AUR="st"

STOW_LIST="cgdb \
    clang \
    ctags \
    fontconfig \
    git \
    i3 \
    mimeapps \
    mutt \
    ncmpcpp \
    profile \
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
    PACKAGE_MANAGER_INSTALL="sudo dnf install"
    # Setup RPM Fusion
    sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
    # TODO Add rpmsphere per: https://forums.fedoraforum.org/showthread.php?318481-How-to-add-repositories-in-Fedora
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
    PACKAGE_MANAGER_INSTALL="trizen -S"
    # Create package list
    ALL_PACKAGES="$ALL_PACKAGES $PACKAGES_ARCH $PACKAGES_AUR"
fi

# Install packages
$PACKAGE_MANAGER_INSTALL $ALL_PACKAGES

# Stow dotfiles
cd $HOME/dotfiles
stow $STOW_LIST

# Clone private repos
git clone git@gitlab.com:rslindee/wiki.git $HOME/wiki
git clone git@gitlab.com:rslindee/dotfiles-private.git $HOME/dotfiles-private

# Stow private dotfiles
cd $HOME/dotfiles-private
stow $STOW_LIST_PRIVATE

# Change shell to zsh
chsh -s $(which zsh)
