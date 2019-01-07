#!/bin/bash
# Fail right away and prevent use of undefined vars
set -eu

# zplugin clone (if it doesn't already exist)
if [ ! -d "~/.zplugin" ]; then
    git clone https://github.com/zdharma/zplugin.git ~/.zplugin/bin
fi

# vim minpac clone (if it doesn't already exist)
if [ ! -f "~/.vim/pack/minpac/opt/minpac/plugin/minpac.vim" ]; then
    git clone https://github.com/k-takata/minpac.git ~/.vim/pack/minpac/opt/minpac
fi

ALL_PACKAGES="atool \
    autoconf \
    bspwm \
    cgdb \
    chromium \
    clang \
    cmus \
    ctags \
    exfat-utils \
    ffmpeg \
    fontconfig \
    fzf \
    mediainfo \
    mpc \
    mpd \
    mpv \
    ncmpcpp \
    pass \
    python \
    qutebrowser \
    ranger \
    renameutils \
    ripgrep \
    sxhkd \
    slock \
    socat \
    sshfs \
    stow \
    sxiv \
    tmux \
    udisks2 \
    vim \
    xautolock \
    xcape \
    xsel \
    zathura \
    zathura-pdf-poppler \
    zsh"

PACKAGES_FEDORA="chromium-libs-media-freeworld \
    ImageMagick \
    fd-find \
    fuse-exfat \
    passmenu \
    python3 \
    python3-tldextract \
    st \
    terminus-fonts \
    terminus-fonts-console \
    unifont-fonts \
    urlview"

# TLP is Thinkpad-specific
PACKAGES_LAPTOP="acpi \
    acpid \
    acpitool \
    powertop \
    tlp \
    tlp-rdw"

# TODO Fedora RPMSphere, build from github, or submit to fedora
# udevil

FEDORA_COPR_REPOS="flatcap/neomutt"

PACKAGES_ARCH="fd \
    imagemagick \
    neomutt \
    newsboat \
    python-tldextract \
    terminus-font \
    udevil"

PACKAGES_AUR="st \
    urlview"

STOW_LIST="cgdb \
    clang \
    ctags \
    fontconfig \
    git \
    mimeapps \
    mpd \
    mpv \
    mutt \
    ncmpcpp \
    profile \
    qutebrowser \
    ranger \
    sxhkd \
    ssh \
    tmux \
    urlview \
    vim \
    zathura \
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
