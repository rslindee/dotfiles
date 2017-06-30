# zplug
# Auto-install zplug if it doesn't exist
if [[ ! -d ~/.zplug ]];then
    curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh| zsh
fi

source ~/.zplug/init.zsh

# Let zplug update itself
zplug "zplug/zplug"
zplug "zsh-users/zsh-completions"
zplug "HeroCC/LS_COLORS"
# zsh-syntax highlighting MUST go before substring-search
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-history-substring-search"

zplug load


# Prompt theme

# Allow substitution
setopt PROMPT_SUBST

ZSH_THEME_GIT_PROMPT_BRANCH_PREFIX="%F{yellow}├"
ZSH_THEME_GIT_PROMPT_REPO_PREFIX="%F{197}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%f"
ZSH_THEME_GIT_PROMPT_DIRTY=" %F{red}*%f"

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
    print "${ZSH_THEME_GIT_PROMPT_REPO_PREFIX}${git_root:t} $ZSH_THEME_GIT_PROMPT_BRANCH_PREFIX${ref#refs/heads/}${ZSH_THEME_GIT_PROMPT_SUFFIX}"
}

precmd () {
    PROMPT='%F{30}%~%f $(git_prompt_info)${ZSH_THEME_PROMPT_VIMODE} '
    RPROMPT='[%W %*]'
}

# vi-mode handling
function zle-line-init zle-keymap-select() {
    case $KEYMAP in
        viins|main) ZSH_THEME_PROMPT_VIMODE="»" ;;
        vicmd) ZSH_THEME_PROMPT_VIMODE="%F{red}!%f" ;;
    esac
    zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select


# OS-specific settings

case "$(uname -s)" in
    Linux)
        ;;
    CYGWIN*|MINGW32*|MSYS*)
        # Throw out most PATH settings (useful for for a "clean" Cygwin)
        PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/cygdrive/c/Python27:/cygdrive/c/Python27/Scripts
        ;;
esac


# Aliases

# Give ls colors and sort directories at top
alias ls='ls --group-directories-first --color=auto'

# All files, human-readable sizes
alias l='ls -lAh'

# Change directory to root of current git repo
alias gitroot='cd "$(git rev-parse --show-toplevel)"'

alias update='pacaur -Syu && zplug update'

# Show directory sizes
alias dirsize='du -h --max-depth=1'

# Show public ip address
alias myip='curl icanhazip.com'

alias diskspace='du -S | sort -n -r |less'

alias q='exit'

# General options

# Treat single word simple commands without redirection as candidates for resumption of an existing job.
setopt AUTO_RESUME

# List jobs in the long format by default.
setopt LONG_LIST_JOBS

# Typing EOF (Ctrl-d) will not exit interactive sessions
setopt ignoreeof

# Disable Software Flow Control keys (Ctrl-s / Ctrl-q)
stty -ixon

# glob for dotfiles
setopt glob_dots

# Extended globbing
setopt extended_glob

# Set editors to Vim
export VISUAL=vim
export EDITOR="$VISUAL"

# Enable vi mode
bindkey -v

# Reduce delay when entering vi mode
export KEYTIMEOUT=1

# History settings

# History file location
HISTFILE=~/.zsh_history

# limit of history entries
HISTSIZE=10000
SAVEHIST=10000

# Perform textual history expansion, csh-style, treating the character ‘!’ specially.
setopt BANG_HIST

# This options works like APPEND_HISTORY except that new history lines are added to the ${HISTFILE} incrementally
# (as soon as they are entered), rather than waiting until the shell exits.
setopt INC_APPEND_HISTORY

# Shares history across all sessions rather than waiting for a new shell invocation to read the history file.
setopt SHARE_HISTORY

# Do not enter command lines into the history list if they are duplicates of the previous event.
setopt HIST_IGNORE_DUPS

# If a new command line being added to the history list duplicates an older one,
# the older command is removed from the list (even if it is not the previous event).
setopt HIST_IGNORE_ALL_DUPS

# Remove command lines from the history list when the first character on the line is a space,
# or when one of the expanded aliases contains a leading space.
setopt HIST_IGNORE_SPACE

# When writing out the history file, older commands that duplicate newer ones are omitted.
setopt HIST_SAVE_NO_DUPS

# Whenever the user enters a line with history expansion, don’t execute the line directly;
# instead, perform history expansion and reload the line into the editing buffer.
setopt HIST_VERIFY


# Completion settings

# If a completion is performed with the cursor within a word, and a full completion is inserted,
# the cursor is moved to the end of the word
setopt ALWAYS_TO_END

# Automatically use menu completion after the second consecutive request for completion
setopt AUTO_MENU

# Automatically list choices on an ambiguous completion.
setopt AUTO_LIST

# Perform a path search even on command names with slashes in them.
setopt PATH_DIRS

# Make globbing (filename generation) sensitive to case.
unsetopt CASE_GLOB

# On an ambiguous completion, instead of listing possibilities or beeping, insert the first match immediately.
# Then when completion is requested again, remove the first match and insert the second match, etc.
unsetopt MENU_COMPLETE

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
bindkey "${terminfo[kcbt]}" reverse-menu-complete

# Set <c-z> to fancy-ctrl-z function
bindkey '^Z' fancy-ctrl-z

# Set <c-j> and <c-k> to zsh-history-substring-search up/down
bindkey '^J' history-substring-search-down
bindkey '^K' history-substring-search-up

# Set j/k for zsh-history-substring-search up/down in vi mode
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# Set <c-f> and <c-b> to quickly jump forward and back words
bindkey '^F' forward-word
bindkey '^B' backward-word

# Fix overly-vi behavior of deleting characters after vi-mode is called
# this fixes the "can't backspace further than where I exited vi-mode at" issue
bindkey "^W" backward-kill-word
bindkey "^H" backward-delete-char
bindkey "^U" kill-line
bindkey "^?" backward-delete-char

# Set <c-d> to forward delete
bindkey "^D" delete-char
