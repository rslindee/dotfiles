# zplug
# Auto-install zplug if it doesn't exist
if [[ ! -d ~/.zplug ]];then
    curl -sL zplug.sh/installer | zsh
fi

source ~/.zplug/init.zsh

# Let zplug update itself
zplug "zplug/zplug"
zplug "zsh-users/zsh-completions"
# zsh-syntax highlighting MUST go before substring-search
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-history-substring-search"

zplug load

## Prompt theme
setopt PROMPT_SUBST

local ret_status="%(?:%{$fg[green]%}➜ :%{$fg[red]%}➜ %s)"

# Outputs the name of the current branch
# Usage example: git pull origin $(git_current_branch)
# Using '--quiet' with 'symbolic-ref' will not cause a fatal error (128) if
# it's not a symbolic ref, but in a Git repo.
function git_current_branch() {
  local ref
  ref=$(command git symbolic-ref --quiet HEAD 2> /dev/null)
  local ret=$?
  if [[ $ret != 0 ]]; then
    [[ $ret == 128 ]] && return  # no git repo.
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
  fi
  echo ${ref#refs/heads/}
}

function git_prompt_info() {
    ref=$(git symbolic-ref HEAD 2> /dev/null) || return
    echo "$ZSH_THEME_GIT_PROMPT_PREFIX$(git_current_branch)$ZSH_THEME_GIT_PROMPT_SUFFIX$(parse_git_dirty)"
}

function get_pwd(){
  git_root=$PWD
  while [[ $git_root != / && ! -e $git_root/.git ]]; do
    git_root=$git_root:h
  done
  if [[ $git_root = / ]]; then
    unset git_root
    prompt_short_dir=%~
  else
    parent=${git_root%\/*}
    prompt_short_dir=${PWD#$parent/}
  fi
  echo $prompt_short_dir
}

PROMPT='$ret_status %{$fg[white]%}$(get_pwd) $(git_prompt_info)%{$reset_color%}%{$reset_color%} '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[cyan]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[yellow]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}✓%{$reset_color%}"


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


# General options

# Treat single word simple commands without redirection as candidates for resumption of an existing job.
setopt AUTO_RESUME

# List jobs in the long format by default.
setopt LONG_LIST_JOBS

# Typing EOF (Ctrl-d) will not exit interactive sessions
setopt ignoreeof

# zplug needs monitor (for jobs) to be set manually, bug?
setopt monitor

# Disable Software Flow Control keys (Ctrl-s / Ctrl-q)
stty -ixon

# glob for dotfiles
setopt glob_dots

# Set editors to Vim
export VISUAL=vim
export EDITOR="$VISUAL"


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
zstyle ':completion::complete:*' cache-path "~/.zcompcache"

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

# Override colors for directories to something more readable
LS_COLORS="ow=37;100:di=37;100"
export LS_COLORS

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

# Set <c-z> to fancy-ctrl-z function
bindkey '^Z' fancy-ctrl-z

# Set <c-j> and <c-k> to zsh-history-substring-search up/down
bindkey '^J' history-substring-search-down
bindkey '^K' history-substring-search-up

# Set j/k for zsh-history-substring-search up/down in vi mode
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

