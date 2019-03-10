# Fail right away and prevent use of undefined vars
set -eu

# zplugin clone (if it doesn't already exist)
if [ ! -d "$HOME/.zplugin" ]; then
    git clone https://github.com/zdharma/zplugin.git $HOME/.zplugin/bin
fi

# vim minpac clone (if it doesn't already exist)
if [ ! -f "$HOME/.vim/pack/minpac/opt/minpac/plugin/minpac.vim" ]; then
    git clone https://github.com/k-takata/minpac.git $HOME/.vim/pack/minpac/opt/minpac
fi

ALL_PACKAGES="abook \
    atool \
    autoconf \
    bashmount \
    bc \
    bspwm \
    cgdb \
    cronie \
    chromium \
    clang \
    cmus \
    ctags \
    dunst \
    exfat-utils \
    ffmpeg \
    fontconfig \
    fzf \
    gnupg \
    khal \
    khard \
    mediainfo \
    mpc \
    mpd \
    mpv \
    msmtp \
    mutt \
    ncmpcpp \
    newsboat \
    notmuch \
    notmuch-mutt \
    pass \
    python \
    python-oauth2client \
    qutebrowser \
    ranger \
    renameutils \
    ripgrep \
    sqlite \
    sxhkd \
    slock \
    socat \
    sshfs \
    st \
    stow \
    sxiv \
    tmux \
    udisks2 \
    urlscan \
    vdirsyncer \
    vim \
    w3m \
    xautolock \
    xsel \
    zathura \
    zathura-pdf-poppler \
    zsh"

PACKAGES_FEDORA="chromium-libs-media-freeworld \
    dejavu-fonts-common \
    ImageMagick \
    fd-find \
    fuse-exfat \
    passmenu \
    python3 \
    python3-autopep8 \
    python3-oauth2client \
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

PACKAGES_ARCH="autopep8 \
    fd \
    imagemagick \
    noto-fonts-cjk \
    python-tldextract \
    terminus-font \
    ttf-dejavu"

STOW_LIST="bspwm \
    cgdb \
    clang \
    ctags \
    dunst \
    flake8 \
    fontconfig \
    git \
    gnupg \
    khal \
    mimeapps \
    mpd \
    mpv \
    ncmpcpp \
    notmuch \
    offlineimap \
    profile \
    qutebrowser \
    ranger \
    ssh \
    sxhkd \
    tmux \
    urlscan \
    vim \
    zathura \
    zsh"

STOW_LIST_PRIVATE="abook \
    msmtp \
    mutt \
    newsboat \
    offlineimap \
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
        git clone https://aur.archlinux.org/trizen.git $HOME/trizen
        cd $HOME/trizen
        makepkg -si
    fi
    PACKAGE_MANAGER_INSTALL="trizen -S --needed"
    # Create package list
    ALL_PACKAGES="$ALL_PACKAGES $PACKAGES_ARCH"
fi

# Install packages
$PACKAGE_MANAGER_INSTALL $ALL_PACKAGES

# Stow dotfiles
cd $HOME/dotfiles
stow -R $STOW_LIST

# Clone private repos if they don't already exist
if [ ! -d "$HOME/wiki" ]; then
    git clone git@gitlab.com:rslindee/wiki.git $HOME/wiki
fi

if [ ! -d "$HOME/dotfiles-private" ]; then
    git clone git@gitlab.com:rslindee/dotfiles-private.git $HOME/dotfiles-private
fi

# Stow private dotfiles
cd $HOME/dotfiles-private
stow -R $STOW_LIST_PRIVATE

# Change shell to zsh
chsh -s $(which zsh)
