#
# User configuration sourced by interactive shells
#

# Source zim
if [[ -s ${ZDOTDIR:-${HOME}}/.zim/init.zsh ]]; then
  source ${ZDOTDIR:-${HOME}}/.zim/init.zsh
fi

# Throw out ALL PATH settings (useful for for a "clean" Cygwin)
#PATH=/usr/local/bin:/usr/local/sbin:/usr/bin

# Typing EOF (CTRL+D) will not exit interactive sessions
setopt ignoreeof

export VISUAL=vim
export EDITOR="$VISUAL"
