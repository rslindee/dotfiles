# DISTRO is populated in .profile
if [ "$DISTRO" = "Fedora" ]; then
  PATH="$PATH:/usr/share/git-core/contrib"
elif [ "$DISTRO" = "Arch Linux" ]; then
  PATH="$PATH:/usr/share/git/diff-highlight"
fi

# Set editors to vim
if [ "$DISTRO" = "Fedora" ] && [[ $DISPLAY ]]; then
  alias vim='vimx'
  export VISUAL=vimx
else
  export VISUAL=vim
fi

export EDITOR="$VISUAL"
export MERGE_EDITOR=vimdiff
export BROWSER=firefox

# less colors
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

# FZF setup
export FZF_DEFAULT_OPTS="--multi"
export FZF_DEFAULT_COMMAND='fd -H --color=never'

# nnn config
export NNN_TMPFILE="/tmp/nnn"
export NNN_USE_EDITOR=1

# Reduce delay in zsh when entering vi mode
export KEYTIMEOUT=1

# local zshenv
[ -e ~/.zshenv.local ] && source ~/.zshenv.local

export PATH
