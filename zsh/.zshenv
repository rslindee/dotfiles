# local zshenv
[ -e $HOME/.zshenv.local ] && source $HOME/.zshenv.local
# hardware acceleration for firefox
export MOZ_ENABLE_WAYLAND=1
# used by browser
export XDG_SESSION_TYPE=wayland
# used for finding appropriate xdg-desktop-portal portal implementation
export XDG_CURRENT_DESKTOP=river
# for pam. TODO: is river recognized or should i use sway?
export XDG_SESSION_DESKTOP=river
# Get OS name
if [ -f /etc/os-release ]; then
  . /etc/os-release
  export DISTRO=$NAME
fi

# Use gpg-agent for ssh
unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
  export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi
