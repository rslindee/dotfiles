# Start zsh completions
autoload -Uz compinit
# version control info
autoload -Uz vcs_info

compinit -d $HOME/.cache/zcompdump

# Set the GPG_TTY and refresh the TTY in case user has switched into an X session
export GPG_TTY=$(tty)
gpg-connect-agent -q updatestartuptty /bye >/dev/null

# Prompt theme
# Allow substitution
setopt prompt_subst

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*' formats "%F{197}%r %F{yellow}├%b%f"
function precmd() { vcs_info }

PROMPT='%F{147}%~%f ${vcs_info_msg_0_}${ZSH_THEME_PROMPT_VIMODE}'
RPROMPT='[%W %* %n.%F{153}%m%f]'

# vi-mode handling
function zle-line-init zle-keymap-select()
{
  case $KEYMAP in
    viins|main) ZSH_THEME_PROMPT_VIMODE="%% " ;;
    vicmd) ZSH_THEME_PROMPT_VIMODE="%F{red}!%f " ;;
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

# Set editors to vim
export VISUAL=vim

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

# update packages, personal wiki, and dotfiles
upd()
{
  if [ "$DISTRO" = "Fedora Linux" ]; then
    sudo dnf upgrade
  elif [ "$DISTRO" = "Arch Linux" ]; then
    trizen -Syu
  fi
  # Dotfiles aren't dependent on each other, so we can do them in parallel
  git -C $HOME/dotfiles pull &
  git -C $HOME/dotfiles-private pull &
  git -C $HOME/wiki pull &
  git -C $HOME/scripts pull &
  wait
}

# Show directory sizes
alias dirsize='du -h --max-depth=1'

# Show public ip address
alias myip='curl icanhazip.com'

alias diskspace='du -S | sort -n -r |less'

alias q='exit'

alias reb='sudo reboot'

alias shu='sudo shutdown now'

# Show weather
wttr()
{
  curl "wttr.in/$1";
}
wttr-map()
{
  mpv "https://radar.weather.gov/lite/N0R/SOX_loop.gif" --osd-level=0 --no-osc
}

# Show available space of /mnt
alias dfa='df -h /mnt/*'

# Quick open with xdg-open
o()
{
  nohup xdg-open "$*" > /dev/null 2>&1 &
}

# Use vim as manpager
viman()
{
  $EDITOR -c "Man $1 $2" -c 'silent only'
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
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

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

# Set history search to be similar to bash
bindkey '^R' history-incremental-search-backward
bindkey '^S' history-incremental-search-forward

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

# Use fd instead of the default find command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

# remove ctrl-g bindkey, as it will be used for fzf git binds
bindkey -r "^G"

# fzf git functions
is_in_git_repo() {
  git rev-parse HEAD > /dev/null 2>&1
}

fzf-down() {
  fzf --height 50% --min-height 20 --border --bind ctrl-/:toggle-preview "$@"
}

# status/files
_gf() {
  is_in_git_repo || return
  git -c color.status=always status --short |
  fzf-down -m --ansi --nth 2..,.. \
    --preview '(git diff --color=always -- {-1} | sed 1,4d; cat {-1})' |
  cut -c4- | sed 's/.* -> //'
}

# branches
_gb() {
  is_in_git_repo || return
  git branch -a --color=always | grep -v '/HEAD\s' | sort |
  fzf-down --ansi --multi --tac --preview-window right:70% \
    --preview 'git log --oneline --graph --date=short --color=always --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1)' |
  sed 's/^..//' | cut -d' ' -f1 |
  sed 's#^remotes/##'
}

# tags
_gt() {
  is_in_git_repo || return
  git tag --sort -version:refname |
  fzf-down --multi --preview-window right:70% \
    --preview 'git show --color=always {}'
}

# log
_gh() {
  is_in_git_repo || return
  git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph --color=always |
  fzf-down --ansi --no-sort --reverse --multi --bind 'ctrl-s:toggle-sort' \
    --header 'Press CTRL-S to toggle sort' \
    --preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --color=always' |
  grep -o "[a-f0-9]\{7,\}"
}

# remotes
_gr() {
  is_in_git_repo || return
  git remote -v | awk '{print $1 "\t" $2}' | uniq |
  fzf-down --tac \
    --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" {1}' |
  cut -d$'\t' -f1
}

# stash
_gs() {
  is_in_git_repo || return
  git stash list | fzf-down --reverse -d: --preview 'git show --color=always {1}' |
  cut -d: -f1
}

join-lines() {
  local item
  while read item; do
    echo -n "${(q)item} "
  done
}

# bind all fzf git functions to keys
() {
  local c
  for c in $@; do
    eval "fzf-g$c-widget() { local result=\$(_g$c | join-lines); zle reset-prompt; LBUFFER+=\$result }"
    eval "zle -N fzf-g$c-widget"
    eval "bindkey '^g^$c' fzf-g$c-widget"
  done
} f b t r h s

# end git fzf

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

if [ "$DISTRO" = "Fedora Linux" ]; then
  source /usr/share/zsh/site-functions/fzf
  source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
else
  source /usr/share/fzf/completion.zsh
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
