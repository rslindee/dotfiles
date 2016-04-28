#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi
# Throw out ALL PATH settings (useful for for a "clean" Cygwin)
#PATH=/usr/local/bin:/usr/local/sbin:/usr/bin

# Typing EOF (CTRL+D) will not exit interactive sessions
setopt ignoreeof

export VISUAL=vim
export EDITOR="$VISUAL"
# Customize to your needs...
