# Start zsh completions
autoload -Uz compinit
# version control info
autoload -Uz vcs_info
# words respect directory separators
autoload -U select-word-style
select-word-style bash

compinit -d $HOME/.cache/zcompdump

# Set the GPG_TTY and refresh the TTY in case user has switched into an X session
#export GPG_TTY=$(tty)
#gpg-connect-agent -q updatestartuptty /bye >/dev/null

# Prompt theme
# Allow substitution
setopt prompt_subst

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*' check-for-changes true
zstyle ':vcs_info:git*' stagedstr '+'
zstyle ':vcs_info:git*' unstagedstr '*'
zstyle ':vcs_info:git*' formats "%F{197}%r %F{yellow}%b%c%u%f "
function precmd() { vcs_info }

PROMPT='%F{147}%~%f ${vcs_info_msg_0_}${ZSH_THEME_PROMPT_VIMODE}'
RPROMPT='[%W %*'

# Add hostname info if SSH connection detected
if [[ -n "$SSH_CONNECTION" ]]; then
    RPROMPT+=' %n@%F{153}%m%f]'
else
    RPROMPT+=']'
fi

# vi-mode handling
function zle-line-init zle-keymap-select()
{
  case $KEYMAP in
    viins|main) ZSH_THEME_PROMPT_VIMODE="%(?.%%.%{%F{red}%}%%%f) " ;;
    vicmd) ZSH_THEME_PROMPT_VIMODE="%F{green}!%f " ;;
  esac
  zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

# setup git diff highlight
if [ "$DISTRO" = "Fedora Linux" ]; then
  PATH="/usr/share/git-core/contrib${PATH:+:${PATH}}"
elif [ "$DISTRO" = "Arch Linux" ]; then
  PATH="/usr/share/git/diff-highlight${PATH:+:${PATH}}"
fi

export XDG_CACHE_HOME=~/.cache

# Set editors to nvim
export VISUAL=nvim

export EDITOR="$VISUAL"
export MERGE_EDITOR="nvim -d"

# less colors
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

export SKIM_DEFAULT_COMMAND="fd -H"
# TODO: re-add "--height 40" when bug fixed
export SKIM_DEFAULT_OPTIONS="--multi --reverse"

# Reduce delay in zsh when entering vi mode
export KEYTIMEOUT=1

# Aliases

# all files, human-readable sizes
alias l='ls -lAh --color=auto'

# all files, reverse modification time
alias lsr='ls -lAhtr --color=auto'

alias bm='bashmount'

# git
# change directory to root of current git repo
alias gitr='cd "$(git rev-parse --show-toplevel)"'
# commit everything and push with commit message "Update"
alias gitup='git add --all && git commit --all --message="Update" && git push'

# Load newsboat with youtube subs
alias nb-tor="newsboat -u ~/.config/newsboat/tor -c ~/.local/share/newsboat/tor.db"

alias nb='newsboat'

# show progress of any current operations
alias p="progress -m"

# startup ncmpcpp w/ systemd-inhibit to prevent sleep
alias jamz="systemd-inhibit ncmpcpp"

# update packages, personal wiki, and dotfiles
upd()
{
  if [ "$DISTRO" = "Fedora Linux" ]; then
    sudo dnf upgrade
  elif [ "$DISTRO" = "Arch Linux" ]; then
    paru -Syu
  fi
  # Dotfiles aren't dependent on each other, so we can do them in parallel
  git -C $HOME/dotfiles pull &
  git -C $HOME/dotfiles-private pull &
  git -C $HOME/wiki pull &
  git -C $HOME/scripts pull &
  wait
}

sshr()
{
  until ssh $1; do
    sleep 5
  done
}

# Show directory sizes
alias dirsize='du -h --max-depth=1'

# Show public ip address
alias myip='curl icanhazip.com'

alias diskspace='du -S | sort -n -r |less'

alias q='exit'

alias reb='sudo reboot'

alias shu='sudo shutdown now'

# Show available space of /mnt
alias dfa='df -h /mnt/*'

# Map vim to nvim
alias vim='nvim'

# Start music player and prevent sleep
alias jamz='systemd-inhibit ncmpcpp'

# Quick open with xdg-open
o()
{
  nohup xdg-open "$*" > /dev/null 2>&1 &
}

mkcd()
{
  mkdir -p $1;
  cd $1;
}

pdb()
{
  python -m pdb $1;
}

# General options

# Disable Software Flow Control keys (Ctrl-s / Ctrl-q)
stty -ixon

# Enable vi mode
bindkey -v

# History file location
HISTFILE=$HOME/.cache/zsh_history

# limit of history entries
HISTSIZE=10000
SAVEHIST=10000

# Don't give error if glob fails. Workaround for issues with cansend '#' issue
setopt +o nomatch

# Treat single word simple commands without redirection as candidates for resumption of an existing job.
setopt auto_resume
# List jobs in the long format by default.
setopt long_list_jobs
# Typing EOF (Ctrl-d) will not exit interactive sessions
setopt ignoreeof
# glob for dotfiles
setopt glob_dots
# treat #, ~, and ^ as part of patterns for filename generation
setopt extended_glob

# Perform textual history expansion, csh-style, treating the character ‘!’ specially.
setopt bang_hist

# This options works like APPEND_HISTORY except that new history lines are added to the ${HISTFILE} incrementally
# (as soon as they are entered), rather than waiting until the shell exits.
setopt inc_append_history

# Shares history across all sessions rather than waiting for a new shell invocation to read the history file.
setopt share_history

# Do not enter command lines into the history list if they are duplicates of the previous event.
setopt hist_ignore_dups

# If a new command line being added to the history list duplicates an older one,
# the older command is removed from the list (even if it is not the previous event).
setopt hist_ignore_all_dups

# Remove command lines from the history list when the first character on the line is a space,
# or when one of the expanded aliases contains a leading space.
setopt hist_ignore_space

# When writing out the history file, older commands that duplicate newer ones are omitted.
setopt hist_save_no_dups


# Completion settings
# If a completion is performed with the cursor within a word, and a full completion is inserted,
# the cursor is moved to the end of the word
setopt always_to_end
# Automatically use menu completion after the second consecutive request for completion
setopt auto_menu
# Automatically list choices on an ambiguous completion.
setopt auto_list
# Perform a path search even on command names with slashes in them.
setopt path_dirs
# Make globbing (filename generation) sensitive to case.
unsetopt case_glob
# On an ambiguous completion, instead of listing possibilities or beeping, insert the first match immediately.
# Then when completion is requested again, remove the first match and insert the second match, etc.
unsetopt menu_complete

zstyle ':completion:*' cache-path ~/.cache
# group matches and describe.
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# directories
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select
zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'expand'
zstyle ':completion:*' squeeze-slashes true

# enable caching
zstyle ':completion::complete:*' use-cache on

# ignore useless commands and functions
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec)|prompt_*)'

# completion sorting
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# Man
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.(^1*)' insert-sections true

# history
zstyle ':completion:*:history-words' stop yes
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false
zstyle ':completion:*:history-words' menu yes

# ignore multiple entries.
zstyle ':completion:*:(rm|kill|diff):*' ignore-line other
zstyle ':completion:*:rm:*' file-patterns '*:all-files'

# Clever binding of fg to Ctrl-z
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

# Key bindings

# Set shift-tab to backwards completion
bindkey "^[[Z" reverse-menu-complete

# Set fancy-ctrl-z function
bindkey '^Z' fancy-ctrl-z

# Search history for entered string
bindkey '^N' history-beginning-search-forward
bindkey '^P' history-beginning-search-backward

# Search history for entered string
bindkey -M vicmd '^n' history-beginning-search-forward
bindkey -M vicmd '^p' history-beginning-search-backward

# Set jump forward and back words
bindkey '^F' forward-word
bindkey '^B' backward-word

# Delete all before/end end of cursor
bindkey '^U' backward-kill-line
bindkey '^K' kill-line

# Jump to beginning/end of line
bindkey '^E' end-of-line
bindkey "^A" beginning-of-line

# Fix overly-vi behavior of deleting characters after vi-mode is called
# this fixes the "can't backspace further than where I exited vi-mode at" issue
bindkey '^W' backward-kill-word
bindkey '^H' backward-delete-char
bindkey '^?' backward-delete-char

# Search history with skim
bindkey '^R' skim-history-widget

# Select file with skim
bindkey '^O' skim-file-widget

# cd into dir when in skim
bindkey '^G' skim-cd-widget

# Set forward delete
bindkey '^D' delete-char

# Alt-. to insert last word
bindkey '^[.' insert-last-word

# yank zsh selection
yank-x-selection () { print -rn -- $CUTBUFFER | wl-copy; }
zle -N yank-x-selection
bindkey '^Y' yank-x-selection
bindkey -a '^Y' yank-x-selection

# yank pwd
yank-pwd () { pwd | wl-copy; }
zle -N yank-pwd
bindkey '^T' yank-pwd
bindkey -a '^T' yank-pwd

# call nnn with tmpfile (for changing dir)
n()
{
  # nnn config
  export NNN_OPTS="adexH"
  export NNN_TMPFILE="/tmp/nnn"
  export NNN_USE_EDITOR=1
  export NNN_PLUG='d:diffs;f:fzcd;i:imgview;o:fzopen;p:preview-tui;r:renamer;t:preview-tabbed;v:imgview;y:x2sel'
  export NNN_COLORS='2356'

  # Block nesting of nnn in subshells
  if [ -n $NNNLVL ] && [ "${NNNLVL:-0}" -ge 1 ]; then
    echo "nnn is already running"
    return
  fi

  # The default behaviour is to cd on quit (nnn checks if NNN_TMPFILE is set)
  export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

  # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
  # stty start undef
  # stty stop undef
  # stty lwrap undef
  # stty lnext undef

  nnn "$@"

  if [ -f "$NNN_TMPFILE" ]; then
    . "$NNN_TMPFILE"
    rm -f "$NNN_TMPFILE" > /dev/null
  fi
}

# tweak zsh highlight styles
typeset -A ZSH_HIGHLIGHT_STYLES
# to disable highlighting of globbing expressions
ZSH_HIGHLIGHT_STYLES[globbing]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=cyan'

# source .zshrc.local if it exists
[ -f "$HOME/.zshrc.local" ] && . "$HOME/.zshrc.local"
