########################################################################
# interactive shell configuration
########################################################################

setopt ALIASES
setopt ALWAYS_TO_END
setopt AUTO_CD
setopt AUTO_MENU
setopt AUTO_PUSHD
setopt BEEP
setopt COMPLETE_IN_WORD
setopt CORRECT
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt MULTIOS
unsetopt NOMATCH  # allow [, ], ?, etc.
setopt NOTIFY
setopt PROMPT_SUBST
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_TO_HOME
setopt RM_STAR_SILENT
setopt SUNKEYBOARDHACK
# setopt TRANSIENT_RPROMPT
# see also history section below


########################################################################
# history
########################################################################

setopt EXTENDED_HISTORY
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY

export HISTFILE="$HOME/.history"
export HISTFILESIZE=50000000
export HISTSIZE=5000000
export SAVEHIST=$HISTSIZE


########################################################################
# prompt
########################################################################

[[ -r "$HOME/.prompt.zsh" ]] && source "$HOME/.prompt.zsh"



########################################################################
# completion
########################################################################

zmodload -i zsh/complist
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*::::' _expand completer _complete _match _approximate

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.cache/zsh

# insert all expansions for expand completer
zstyle ':completion:*:expand:*' tag-order all-expansions

zstyle ':completion:*' extra-verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' group-name '' # completion in distinct groups

# allow one error for every four characters typed in approximate completer
zstyle ':completion:*:match:*' original only
zstyle -e ':completion:*:approximate:*' max-errors 'reply=( $(( ($#PREFIX+$#SUFFIX)/4 )) numeric )'

# case- and hyphen-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'

# complete .. and .
zstyle ':completion:*' special-dirs true

# colors
zstyle ':completion:*' list-colors ${(s.:.)GNU_LSCOLORS}
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

# offer indices before parameters in array subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# offer completions for directories from all these groups
zstyle ':completion:*::*:(cd|pushd):*' tag-order path-directories directory-stack

# never offer the parent directory (e.g.: cd ../<TAB>)
zstyle ':completion:*:cd:*' ignore-parents parent pwd

# don't complete things which aren't available
zstyle ':completion:*:*:-command-:*:*' tag-order 'functions:-non-comp *' functions
zstyle ':completion:*:functions-non-comp' ignored-patterns '_*'

# why doesn't this do anything?
# zstyle ':completion:*:*:-command-:*:*' tag-order - path-directories directory-stack

# split options into groups
zstyle ':completion:*' tag-order \
    'options:-long:long\ options
     options:-short:short\ options
     options:-single-letter:single\ letter\ options'
zstyle ':completion:*:options-long' ignored-patterns '[-+](|-|[^-]*)'
zstyle ':completion:*:options-short' ignored-patterns '--*' '[-+]?'
zstyle ':completion:*:options-single-letter' ignored-patterns '???*'


########################################################################
# widgets and other extended functionality
########################################################################

typeset -U cdpath

cdpath=(
  $HOME
  $HOME/scratch
  $HOME/Developer
  $HOME/Development
  $cdpath
)

typeset -U fpath

fpath=(
  /usr/local/share/zsh-completions
  /usr/local/share/zsh/site-functions
  $fpath
)

typeset -U libraries

libraries=(
  colored-man-pages
  extract
  gpg-agent
  safe-paste
  ssh-agent
)

# add libraries to fpath but don't source yet
for library ($libraries); do
  if [[ -d "$HOME/.local/lib/zsh/$library" ]]; then
    fpath=($HOME/.local/lib/zsh/$library $fpath)
  fi
done

autoload -Uz +X compaudit compinit
autoload -Uz +X bashcompinit

# Only bother with rebuilding, auditing, and compiling the compinit
# file once a whole day has passed. The -C flag bypasses both the
# check for rebuilding the dump file and the usual call to compaudit.
setopt EXTENDEDGLOB
for dump in $HOME/.zcompdump(N.mh+24); do
  echo 'Re-initializing ZSH completions'
  touch $dump
  compinit
  bashcompinit
  if [[ -s "$dump" && (! -s "$dump.zwc" || "$dump" -nt "$dump.zwc") ]]; then
    zcompile "$dump"
  fi
done
unsetopt EXTENDEDGLOB
compinit -C

# source all plugins so they're available
for library ($libraries); do
  if [[ -r "$HOME/.local/lib/zsh/$library/$library.zsh" ]]; then
    source "$HOME/.local/lib/zsh/$library/$library.zsh"
  fi
done

# +X means don't execute, only load
autoload -Uz +X zmv

# quote pasted URLs
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

# bracketed paste mode
autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic

# for detecting existence of commands, functions, builtins, etc.
zmodload -i zsh/parameter


########################################################################
# zsh-autosuggestions
########################################################################

if [[ -r "$HOME/.local/libexec/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
  source "$HOME/.local/libexec/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
ZSH_AUTOSUGGEST_STRATEGY=match_prev_cmd
# ZSH_AUTOSUGGEST_USE_ASYNC=1

# https://github.com/zsh-users/zsh-autosuggestions/issues/238#issuecomment-389324292
pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic
}

pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}

zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish


########################################################################
# zsh-history-substring-search
########################################################################

if [[ -r "$HOME/.local/libexec/zsh/zsh-history-substring-search/zsh-history-substring-search.zsh" ]]; then
  source "$HOME/.local/libexec/zsh/zsh-history-substring-search/zsh-history-substring-search.zsh"
fi


########################################################################
# iTerm2 shell integration
########################################################################

[[ -r "$HOME/.iterm2_shell_integration.zsh" ]] && source "$HOME/.iterm2_shell_integration.zsh"


########################################################################
# pkgfile suggestions on Arch Linux
########################################################################

if [[ -r "/usr/share/doc/pkgfile/command-not-found.zsh" ]]; then
  source "/usr/share/doc/pkgfile/command-not-found.zsh"
fi


########################################################################
# home setup
#########################################################################

alias home="git --work-tree=$HOME --git-dir=$HOME/.home.git"

# function detect_home_git
# {
#     if [[ $HOME == $PWD ]]; then
#         export GIT_DIR=$HOME/.home.git
#         export GIT_WORK_TREE=$HOME
#     else
#         unset GIT_DIR
#         unset GIT_WORK_TREE
#     fi
# }

# detect_home_git
# chpwd_functions=(detect_home_git $chpwd_functions)


########################################################################
# extra sources
########################################################################

# aliases
[[ -f "$HOME/.aliases" ]] && source "$HOME/.aliases"

# misc
source "git-helpers.sh"



########################################################################
# key bindings
########################################################################

# load terminfo for portable keybindings
zmodload zsh/terminfo

# allows using terminfo properly
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
  function zle-line-init()   { echoti smkx }
  function zle-line-finish() { echoti rmkx }
  zle -N zle-line-init
  zle -N zle-line-finish
fi

# default to emacs-style keybindings
bindkey -e

# Page-Up and Page-Down cycle through history
[[ "${terminfo[kpp]}" != "" ]] && bindkey "${terminfo[kpp]}" up-line-or-history
[[ "${terminfo[knp]}" != "" ]] && bindkey "${terminfo[knp]}" down-line-or-history

# search history for commands which begin with the current string by
# pressing Up or Down (depends on zsh-history-substring-search)
[[ "${terminfo[kcuu1]}" != "" ]] && bindkey "${terminfo[kcuu1]}" history-substring-search-up
[[ "${terminfo[kcud1]}" != "" ]] && bindkey "${terminfo[kcud1]}" history-substring-search-down

# Home and End go to beginning and end of line
[[ "${terminfo[khome]}" != "" ]] && bindkey "${terminfo[khome]}" beginning-of-line
[[ "${terminfo[kend]}" != "" ]] && bindkey "${terminfo[kend]}"  end-of-line

# Space does history expansion (e.g., !1<space> becomes the last command
# input in the history)
bindkey ' ' magic-space

bindkey '^[[1;5C' forward-word   # move forward wordwise with ctrl-arrow
bindkey '^[[1;5D' backward-word  # move backward wordwise with ctrl-arrow

# Shift-Tab moves through the completion menu backwards
[[ "${terminfo[kcbt]}" != "" ]] && bindkey "${terminfo[kcbt]}" reverse-menu-complete

# Backspace
[[ "${terminfo[kbs]}" != "" ]] && bindkey "${terminfo[kbs]}" backward-delete-char

# Delete
if [[ "${terminfo[kdch1]}" != "" ]]; then
  bindkey "${terminfo[kdch1]}" delete-char
else
  bindkey "^[[3~" delete-char
  bindkey "^[3;5~" delete-char
  bindkey "\e[3~" delete-char
fi

# complete on Tab, leave expansion to _expand
[[ "${terminfo[ht]}" != "" ]] && bindkey "${terminfo[ht]}" complete-word

# initiate history search with Ctrl-R
bindkey '^R' history-incremental-search-backward

# edit command line in $EDITOR with 'm-e' (or 'esc+e' or 'v' in vi mode)
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M emacs '^[e' edit-command-line
bindkey -M vicmd v edit-command-line


########################################################################
# zsh-syntax-highlighting
########################################################################

ZSH_HIGHLIGHT_MAXLENGTH=300

ZSH_HIGHLIGHT_HIGHLIGHTERS=(
  main
  brackets
  pattern
  cursor
)

# https://github.com/zsh-users/zsh-syntax-highlighting#why-must-zsh-syntax-highlightingzsh-be-sourced-at-the-end-of-the-zshrc-file
if [[ -r "$HOME/.local/libexec/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
  source "$HOME/.local/libexec/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi


# vim: set ft=zsh tw=72 :
