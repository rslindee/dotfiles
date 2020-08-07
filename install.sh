#!/bin/bash
# Fail right away and prevent use of undefined vars
set -eu

# vim minpac clone (if it doesn't already exist)
if [ ! -f "$HOME/.vim/pack/minpac/opt/minpac/plugin/minpac.vim" ]; then
    git clone https://github.com/k-takata/minpac.git "$HOME/.vim/pack/minpac/opt/minpac"
fi

ALL_PACKAGES="aspell-en \
    atool \
    autoconf \
    bashmount \
    bat \
    bc \
    cgdb \
    cronie \
    chromium \
    clang \
    cmake \
    cmus \
    ctags \
    dmenu \
    dunst \
    entr \
    exfat-utils \
    feh \
    ffmpeg \
    fontconfig \
    fzf \
    gimp \
    git-delta \
    gnupg \
    graphviz \
    gvim \
    guvcview \
    isync \
    jq \
    khal \
    khard \
    libnotify \
    light \
    lzop \
    mediainfo \
    mlocate \
    moreutils \
    mpc \
    mpd \
    mpv \
    msmtp \
    mutt \
    ncdu \
    ncmpcpp \
    newsboat \
    nnn \
    notmuch \
    notmuch-mutt \
    openvpn \
    p7zip \
    pass \
    pavucontrol \
    python \
    pv \
    qutebrowser \
    ranger \
    renameutils \
    ripgrep \
    rsync \
    sqlite \
    slock \
    socat \
    sshfs \
    st \
    stow \
    surfraw \
    tig \
    tmux \
    udisks2 \
    unrar \
    unzip \
    urlscan \
    vdirsyncer \
    w3m \
    xcompmgr \
    xsel \
    xss-lock \
    youtube-dl \
    zathura \
    zathura-pdf-poppler \
    zsh-syntax-highlighting \
    zip \
    zsh"

PACKAGES_FEDORA="chromium-libs-media-freeworld \
    ImageMagick \
    fd-find \
    fuse-exfat \
    git-clang-format \
    NetworkManager-tui \
    passmenu \
    python3 \
    python3-autopep8 \
    ShellCheck \
    terminus-fonts \
    terminus-fonts-console \
    unifont-fonts"

# TLP is Thinkpad-specific
PACKAGES_LAPTOP="acpi \
    acpid \
    powertop \
    tlp \
    tlp-rdw \
    "

PACKAGES_ARCH="alsa-utils \
    autopep8 \
    bash-language-server \
    fd \
    imagemagick \
    nfs-utils \
    networkmanager \
    noto-fonts-cjk \
    shellcheck \
    terminus-font \
    ttf-dejavu \
    xorg
    "

STOW_LIST="clang \
    dunst \
    flake8 \
    fontconfig \
    git \
    gnupg \
    khal \
    khard \
    mimeapps \
    mpd \
    mpv \
    ncmpcpp \
    notmuch \
    pam \
    profile \
    tmux \
    vim \
    zathura \
    zsh"

STOW_LIST_PRIVATE="mbsync \
    msmtp \
    mutt \
    newsboat \
    pass \
    vdirsyncer"

# Get OS version
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$NAME
fi

# Setup package manager
if [ "$OS" = "Fedora" ]; then
    echo "Fedora system detected..."
    PACKAGE_MANAGER_INSTALL="sudo dnf install"
    # Setup RPM Fusion
    sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
    # Create package list
    ALL_PACKAGES="$ALL_PACKAGES $PACKAGES_FEDORA"
elif [ "$OS" = "Arch Linux" ]; then
    echo "Arch system detected..."
    # Install trizen
    if [ ! -f "/usr/bin/trizen" ]; then
        git clone https://aur.archlinux.org/trizen.git "$HOME/trizen"
        cd "$HOME/trizen"
        makepkg -si
    fi
    PACKAGE_MANAGER_INSTALL="trizen -S --needed"
    # Create package list
    ALL_PACKAGES="$ALL_PACKAGES $PACKAGES_ARCH"
fi

# Install packages
$PACKAGE_MANAGER_INSTALL $ALL_PACKAGES

# Stow dotfiles
cd "$HOME/dotfiles"
stow -R "$STOW_LIST"

# Clone private repos if they don't already exist
if [ ! -d "$HOME/wiki" ]; then
    git clone git@gitlab.com:rslindee/wiki.git "$HOME/wiki"
fi

if [ ! -d "$HOME/dotfiles-private" ]; then
    git clone git@gitlab.com:rslindee/dotfiles-private.git "$HOME/dotfiles-private"
fi

# Stow private dotfiles
cd "$HOME/dotfiles-private"
stow -R "$STOW_LIST_PRIVATE"

# Change shell to zsh
chsh -s $(which zsh)
