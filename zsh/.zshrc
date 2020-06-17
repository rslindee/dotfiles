# Start zsh completions
autoload -Uz compinit
compinit

# Get OS name
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$NAME
fi

if [ "$OS" = "Fedora" ]; then
  PATH="$PATH:/usr/share/git-core/contrib"
elif [ "$OS" = "Arch Linux" ]; then
  PATH="$PATH:/usr/share/git/diff-highlight"
fi

# Use gpg-agent for ssh
unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
  export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi

# Set the GPG_TTY and refresh the TTY in case user has switched into an X session
export GPG_TTY=$(tty)
gpg-connect-agent -q updatestartuptty /bye >/dev/null

# Prompt theme
# Allow substitution
setopt prompt_subst

ZSH_THEME_GIT_PROMPT_BRANCH_PREFIX="%F{yellow}├"
ZSH_THEME_GIT_PROMPT_REPO="%F{197}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%f"
ZSH_THEME_GIT_PROMPT_DIRTY=" %F{red}*%f"
ZSH_THEME_DIRECTORY="%F{147}%~%f"

# shortens the pwd for use in prompt
function git_prompt_info() {
    local ref
    git_root="$(command git rev-parse --show-toplevel 2> /dev/null)"
    ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
        ref=$(command git rev-parse --short HEAD 2> /dev/null) || return 0
    print " ${ZSH_THEME_GIT_PROMPT_REPO}${git_root:t} $ZSH_THEME_GIT_PROMPT_BRANCH_PREFIX${ref#refs/heads/}${ZSH_THEME_GIT_PROMPT_SUFFIX}"
}

precmd () {
    PROMPT='$ZSH_THEME_DIRECTORY$(git_prompt_info)${ZSH_THEME_PROMPT_VIMODE}'
    RPROMPT='[%W %* %n@%F{153}%m%f]'
}

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

# Aliases

# all files, human-readable sizes
alias l='ls -lAh --color=auto'

alias bm='bashmount'

# git
# change directory to root of current git repo
alias gitr='cd "$(git rev-parse --show-toplevel)"'
# commit everything and push with commit message "Update"
alias gitup='git add --all && git commit --all --message="Update" && git push'
# delete locally merged branches to master or develop except current
# TODO: this is currently broken?
alias gitdm='git branch --merged | grep -Ev \"(^\\*|master|^develop)\" | xargs -n 1 git branch --delete'

# Load newsboat with youtube subs
alias nb-tor="newsboat -u ~/.config/newsboat/tor -c ~/.local/share/newsboat/tor.db"

alias nb='newsboat'

# show progress of any current operations
alias p="progress -m"

# update packages, zinit plugins, personal wiki, and dotfiles
upd()
{
    if [ "$OS" = "Fedora" ]; then
        sudo dnf upgrade
    elif [ "$OS" = "Arch Linux" ]; then
        trizen -Syu
    fi
    zinit self-update
    zinit update --all
    # Dotfiles aren't dependent on each other, so we can do them in parallel
    git -C ~/dotfiles pull &
    git -C ~/dotfiles-private pull &
    git -C ~/wiki pull &
    wait
}

mailrich()
{
    # Check mail at interval
    while true; do
        mbsync -q richard-slindee && notmuch new --quiet
        sleep 60
    done &
    loop_pid=$!
    mutt -f ~/mail/richard-slindee/Inbox
    kill $loop_pid
    mbsync -q richard-slindee &
    notmuch new --quiet &
}

mailrs()
{
    # Check mail at interval
    while true; do
        mbsync -q rslindee-gmail && notmuch new --quiet
        sleep 60
    done &
    loop_pid=$!
    mutt -f ~/mail/rslindee-gmail/Inbox
    kill $loop_pid
    mbsync -q rslindee-gmail &
    notmuch new --quiet &
}

calrich()
{
    # run vdirsyncer at interval
    while true; do
        vdirsyncer sync > /dev/null 2>&1
        sleep 60
    done &
    loop_pid=$!
    ikhal
    kill $loop_pid
    vdirsyncer sync &
}

# Show directory sizes
alias dirsize='du -h --max-depth=1'

# Show public ip address
alias myip='curl icanhazip.com'

alias diskspace='du -S | sort -n -r |less'

alias q='exit'

alias reb='sudo reboot'

alias shu='sudo shutdown now'

# Set editors to vim
if [ "$OS" = "Fedora" ] && [[ $DISPLAY ]]; then
    alias vim='vimx'
    export VISUAL=vimx
else
    export VISUAL=vim
fi
export EDITOR="$VISUAL"
export MERGE_EDITOR=vimdiff
export BROWSER=firefox

# Show weather
wttr()
{
  curl "wttr.in/$1";
  mpv "https://radar.weather.gov/lite/N0R/SOX_loop.gif" --osd-level=0 --no-osc
}

# Show available space of /mnt
alias dfa='df -h /mnt/*'

# Quick open with xdg-open
alias o='xdg-open'

# Use vim as manpager
viman()
{
    $EDITOR -c "Man $1 $2" -c 'silent only'
}

alias rang='ranger'

# Attaches cgdb to running PID of executable.
# Note: Needs to be in current directory of said executable to work.
cgdb-attach()
{
    cgdb attach $(pidof $1) -ex cont;
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

# less colors
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

# Enable vi mode
bindkey -v

# Reduce delay when entering vi mode
export KEYTIMEOUT=1

# History file location
HISTFILE=~/.zsh_history

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

# FZF setup
export FZF_DEFAULT_OPTS="--multi"
export FZF_DEFAULT_COMMAND='fd -H --color=never'

# Key bindings

# Set shift-tab to backwards completion
bindkey "^[[Z" reverse-menu-complete

# Set fancy-ctrl-z function
bindkey '^Z' fancy-ctrl-z

# Set zsh-history-substring-search up/down
bindkey '^N' history-substring-search-down
bindkey '^P' history-substring-search-up

# Set zsh-history-substring-search up/down in vi mode
bindkey -M vicmd '^n' history-substring-search-up
bindkey -M vicmd '^p' history-substring-search-down

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

# yank zsh selection
yank-x-selection () { print -rn -- $CUTBUFFER | xsel -i --clipboard; }
zle -N yank-x-selection
bindkey '^Y' yank-x-selection
bindkey -a '^Y' yank-x-selection

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

# nnn config
export NNN_TMPFILE="/tmp/nnn"
export NNN_USE_EDITOR=1

# call nnn with tmpfile (for changing dir)
n()
{
    nnn "$@"

    if [ -f $NNN_TMPFILE ]; then
        . $NNN_TMPFILE
        rm $NNN_TMPFILE
    fi
}

# open vifm and change dir when done
vicd()
{
    local dst="$(command vifm --choose-dir - "$@")"
    if [ -z "$dst" ]; then
        echo 'Directory picking cancelled/failed'
        return 1
    fi
    cd "$dst"
}

# Added by zinit's installer
source ~/.zinit/bin/zinit.zsh
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of zinit's installer chunk
# Plugins
zinit light zsh-users/zsh-history-substring-search
zinit light zdharma/fast-syntax-highlighting

if [ "$OS" = "Fedora" ]; then
    source /usr/share/zsh/site-functions/fzf
else
    source /usr/share/fzf/completion.zsh
fi
