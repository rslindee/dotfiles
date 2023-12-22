#!/bin/bash
# Fail right away and prevent use of undefined vars
set -eu

ALL_PACKAGES="alsa-utils \
    aspell-en \
    atool \
    autoconf \
    bashmount \
    bat \
    bc \
    btrfsmaintenance \
    cgdb \
    cronie \
    chromium \
    clang \
    cmake \
    ctags \
    entr \
    exfat-utils \
    ffmpeg \
    foot \
    foot-terminfo \
    fontconfig \
    fuzzel \
    fzf \
    gimp \
    git-delta \
    grim \
    gnupg \
    gnuplot \
    graphviz \
    guvcview \
    iwd \
    imv \
    isync \
    jq \
    kanshi \
    khal \
    khard \
    libnotify \
    light \
    lnav \
    lsof \
    lzop \
    mako \
    mediainfo \
    miller \
    mlocate \
    moreutils \
    mpc \
    mpd \
    mpv \
    msmtp \
    mutt \
    ncdu \
    ncmpcpp \
    neovim \
    nethogs \
    newsboat \
    nnn \
    notmuch \
    notmuch-mutt \
    oathtool \
    p7zip \
    pamixer \
    pass \
    pass-otp \
    pavucontrol \
    power-profiles-daemon \
    python \
    pv \
    ripgrep \
    rsync \
    sqlite \
    socat \
    slurp \
    sshfs \
    stow \
    strace \
    surfraw \
    swayidle \
    swaylock \
    tealdeer \
    tig \
    tio \
    tmux \
    usbutils \
    udisks2 \
    unrar \
    unzip \
    urlscan \
    vim \
    vdirsyncer \
    wl-clipboard \
    wlopm \
    w3m \
    yambar \
    yt-dlp \
    zathura \
    zathura-pdf-mupdf \
    zsh-syntax-highlighting \
    zip \
    zsh"

PACKAGES_FEDORA="
    fd-find \
    git-clang-format \
    NetworkManager-tui \
    passmenu \
    prename \
    python-flake8
    python-yapf
    python3 \
    ShellCheck \
    terminus-fonts \
    terminus-fonts-console \
    unifont-fonts"

PACKAGES_LAPTOP="acpi \
    acpid \
    powertop \
    "

PACKAGES_ARCH="bash-language-server \
    fd \
    flake8 \
    nfs-utils \
    networkmanager \
    noto-fonts-cjk \
    shellcheck \
    terminus-font \
    ttf-dejavu \
    yapf
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
if [ "$OS" = "Fedora Linux" ]; then
    echo "Fedora system detected..."
    PACKAGE_MANAGER_INSTALL="sudo dnf install --allowerasing"
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
#cd "$HOME/dotfiles"
#stow -R "$STOW_LIST"

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
