# source local zshenv if available
[ -e $HOME/.zshenv.local ] && source $HOME/.zshenv.local
# Get OS name for my own cross-distro scripts/configs
if [ -f /etc/os-release ]; then
  . /etc/os-release
  export DISTRO=$NAME
fi
