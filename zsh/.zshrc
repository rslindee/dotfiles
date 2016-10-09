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

# Start tmux
#if [ "$TMUX" = "" ]; then
#    echo "Starting tmux..."
#    tmux
#fi
