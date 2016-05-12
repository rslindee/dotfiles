#
# User configuration sourced by interactive shells
#

# Source zim
if [[ -s ${ZDOTDIR:-${HOME}}/.zim/init.zsh ]]; then
  source ${ZDOTDIR:-${HOME}}/.zim/init.zsh
fi

# Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/base16-monokai.dark.sh"
[[ -s $BASE16_SHELL ]] && source $BASE16_SHELL

# Throw out ALL PATH settings (useful for for a "clean" Cygwin)
#PATH=/usr/local/bin:/usr/local/sbin:/usr/bin

# Typing EOF (CTRL+D) will not exit interactive sessions
setopt ignoreeof

export VISUAL=vim
export EDITOR="$VISUAL"
