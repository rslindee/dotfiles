# zgen
if [[ ! -d ~/.zgen ]];then
    git clone https://github.com/rslindee/zgen.git "${HOME}/.zgen"
fi

source ~/.zgen/zgen.zsh

# if the init script doesn't exist
if ! zgen saved; then

    zgen load "zsh-users/zsh-completions"
    zgen load "HeroCC/LS_COLORS"
    zgen load "ytet5uy4/fzf-widgets"
    # zsh-syntax highlighting MUST go before substring-search
    zgen load "zsh-users/zsh-syntax-highlighting"
    zgen load "zsh-users/zsh-history-substring-search"
    zgen load "zdharma/zsh-diff-so-fancy"
    zgen load "paulirish/git-open"

    # generate the init script from plugins above
    zgen save
fi


# Get OS version
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$NAME
fi

# Prompt theme

# Allow substitution
setopt prompt_subst

ZSH_THEME_GIT_PROMPT_BRANCH_PREFIX="%F{yellow}├"
ZSH_THEME_GIT_PROMPT_REPO="%F{197}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%f"
ZSH_THEME_GIT_PROMPT_DIRTY=" %F{red}*%f"
ZSH_THEME_DIRECTORY="%F{30}%~%f"

# Check if repo is dirty
function parse_git_dirty() {
    local STATUS=''
    local FLAGS
    FLAGS=('--porcelain')
    STATUS=$(command git status ${FLAGS} 2> /dev/null | tail -n1)
    if [[ -n ${STATUS} ]]; then
        print ${ZSH_THEME_GIT_PROMPT_DIRTY}
    fi
}

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
    RPROMPT='[%W %*]'
}

# vi-mode handling
function zle-line-init zle-keymap-select()
{
    case $KEYMAP in
        viins|main) ZSH_THEME_PROMPT_VIMODE=" » " ;;
        vicmd) ZSH_THEME_PROMPT_VIMODE=" %F{red}!%f " ;;
    esac
    zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

# Aliases

# Give ls colors and sort directories at top
alias ls='ls --group-directories-first --color=auto'

# All files, human-readable sizes
alias l='ls -lAh'

# Change directory to root of current git repo
alias gitr='cd "$(git rev-parse --show-toplevel)"'

# Load newsboat with youtube subs
alias youtube="newsboat -u $HOME/.newsboat/youtubeurls -c $HOME/.newsboat/youcache.db"

# Update packages, zgen plugins, personal wiki, and dotfiles
upd()
{
    if [ "$OS" = "Fedora" ]; then
        echo "Updating Fedora packages..."
        sudo dnf update
    elif [ "$OS" = "Arch Linux" ]; then
        echo "Updating Arch and AUR packages..."
        trizen -Syu
    fi
    echo "Updating zgen plugins..."
    zgen update
    echo "Updating dotfiles..."
    git -C ~/dotfiles pull
    echo "Updating private dotfiles..."
    git -C ~/dotfiles-private pull
    echo "Updating personal wiki..."
    git -C ~/wiki pull
}

# Show directory sizes
alias dirsize='du -h --max-depth=1'

# Show public ip address
alias myip='curl icanhazip.com'

alias diskspace='du -S | sort -n -r |less'

alias q='exit'

alias reb='sudo reboot'

alias shu='sudo shutdown now'

# Show weather for 90034
alias wttr='curl wttr.in/90034'

# Show available space of /mnt
alias dfA='df -h /mnt/*'

# Delete all locally merged branches in git (NOTE: includes current branch!)
alias git-clean='git branch --merged | grep -Ev "(^\*|master|develop)" | xargs git branch -d'

# Use vim as manpager
viman () {
    vim -c "Man $1 $2" -c 'silent only'
}

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

# General options

# Disable Software Flow Control keys (Ctrl-s / Ctrl-q)
stty -ixon

# Set editors to vim
export VISUAL=vim
export EDITOR="$VISUAL"

# Enable vi mode
bindkey -v

# Reduce delay when entering vi mode
export KEYTIMEOUT=1

# History file location
HISTFILE=~/.zsh_history

# limit of history entries
HISTSIZE=10000
SAVEHIST=10000

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

# zsh-highlighting color tweaks
ZSH_HIGHLIGHT_STYLES[globbing]='fg=magenta'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=magenta'

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
FZF_WIDGET_TMUX=1

# Key bindings

# Set shift-tab to backwards completion
bindkey "^[[Z" reverse-menu-complete

# Set fancy-ctrl-z function
bindkey '^Z' fancy-ctrl-z

# Set zsh-history-substring-search up/down
bindkey '^N' history-substring-search-down
bindkey '^P' history-substring-search-up

# Set zsh-history-substring-search up/down in vi mode
bindkey -M vicmd 'n' history-substring-search-up
bindkey -M vicmd 'p' history-substring-search-down

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

# TODO: fzf-insert-directory and fzf-insert-files is kinda slow after exit for some reason
# fzf keybinds
bindkey -r '^O'
bindkey '^Ot' fzf-insert-directory
bindkey '^Oo' fzf-insert-files
bindkey '^Op' fzf-kill-processes
bindkey '^Or' fzf-insert-history
bindkey '^Oa' fzf-git-add-files
bindkey '^Ob' fzf-git-checkout-branch
bindkey '^Od' fzf-git-delete-branches

