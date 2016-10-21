#
# User configuration sourced by interactive shells
#

# Source zim
if [[ -s ${ZDOTDIR:-${HOME}}/.zim/init.zsh ]]; then
  source ${ZDOTDIR:-${HOME}}/.zim/init.zsh
fi

# OS-specific settings
case "$(uname -s)" in
    Linux)
        ;;

    CYGWIN*|MINGW32*|MSYS*)
        # Throw out most PATH settings (useful for for a "clean" Cygwin)
        PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/cygdrive/c/Python27:/cygdrive/c/Python27/Scripts
        ;;
esac

# Typing EOF (Ctrl+d) will not exit interactive sessions
setopt ignoreeof

# Disable Software Flow Control keys (Ctrl+s / Ctrl+q)
stty -ixon

# glob for dotfiles
setopt glob_dots

# Set editors to Vim
export VISUAL=vim
export EDITOR="$VISUAL"

LS_COLORS="ow=37;100:di=37;100"
export LS_COLORS

# Clever binding of fg to Ctrl-Z
fancy-ctrl-z () {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line
  else
    zle push-input
    zle clear-screen
  fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

# Start tmux
#if [ "$TMUX" = "" ]; then
#    echo "Starting tmux..."
#    tmux
#fi
