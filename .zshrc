########################################################################
# interactive shell configuration
########################################################################

setopt ALIASES
#unsetopt ALWAYS_TO_END
setopt AUTO_CD
#unsetopt AUTO_MENU
setopt AUTO_PUSHD
setopt BEEP
#unsetopt COMPLETE_IN_WORD
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
# zsh modules
########################################################################

if (( $+commands[brew] )); then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

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
# completion
########################################################################

# initiate history search with Ctrl-R
bindkey '^R' history-incremental-search-backward

if [[ (( $+commands[brew] )) && -r "$(brew --prefix)/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh" ]]; then
  zstyle ':autocomplete:*' default-context ''
  # '': Start each new command line with normal autocompletion.
  # history-incremental-search-backward: Start in live history search mode.

  # zstyle ':autocomplete:*' min-delay 0.1  # seconds (float)
  # Wait this many seconds for typing to stop, before showing completions.

  # zstyle ':autocomplete:*' min-input 1  # characters (int)
  # Wait until this many characters have been typed, before showing completions.

  zstyle ':autocomplete:*' ignored-input '' # extended glob pattern
  # '':     Always show completions.
  # '..##': Don't show completions for the current word, if it consists of two
  #         or more dots.

  zstyle ':autocomplete:*' list-lines 10  # int
  # If there are fewer than this many lines below the prompt, move the prompt up
  # to make room for showing this many lines of completions (approximately).

  zstyle ':autocomplete:history-search:*' list-lines 10  # int
  # Show this many history lines when pressing ↑.

  zstyle ':autocomplete:history-incremental-search-*:*' list-lines 10  # int
  # Show this many history lines when pressing ⌃R or ⌃S.

  zstyle ':autocomplete:*' insert-unambiguous no
  # no:  Tab inserts the top completion.
  # yes: Tab first inserts a substring common to all listed completions, if any.

  zstyle ':autocomplete:*' fzf-completion no
  # no:  Tab uses Zsh's completion system only.
  # yes: Tab first tries Fzf's completion, then falls back to Zsh's.
  # ⚠️ NOTE: This setting can NOT be changed at runtime and requires that you
  # have installed Fzf's shell extensions.

  # Add a space after these completions:
  zstyle ':autocomplete:*' add-space executables aliases functions builtins reserved-words commands

  # Autocomplete automatically selects a backend for its recent dirs completions.
  # So, normally you won't need to change this.
  # However, you can set it if you find that the wrong backend is being used.
  zstyle ':autocomplete:recent-dirs' backend cdr
  # cdr:  Use Zsh's `cdr` function to show recent directories as completions.
  # no:   Don't show recent directories.
  # zsh-z|zoxide|z.lua|z.sh|autojump|fasd: Use this instead (if installed).
  # ⚠️ NOTE: This setting can NOT be changed at runtime.

  zstyle ':autocomplete:*' widget-style menu-select
  # complete-word: (Shift-)Tab inserts the top (bottom) completion.
  # menu-complete: Press again to cycle to next (previous) completion.
  # menu-select:   Same as `menu-complete`, but updates selection in menu.
  # ⚠️ NOTE: This setting can NOT be changed at runtime.

  zstyle ':completion:*' group-name ''
  zstyle ':completion:*' list-prompt ''

  source "$HOME/Developer/zsh-autocomplete/zsh-autocomplete.plugin.zsh"

  # Up arrow:
  bindkey '\e[A' up-line-or-search
  bindkey '\eOA' up-line-or-search
  # up-line-or-search:  Open history menu.
  # up-line-or-history: Cycle to previous history line.

  # Down arrow:
  bindkey '\e[B' down-line-or-select
  bindkey '\eOB' down-line-or-select
  # down-line-or-select:  Open completion menu.
  # down-line-or-history: Cycle to next history line.

  # Control-Space:
  bindkey '\0' list-expand
  # list-expand:      Reveal hidden completions.
  # set-mark-command: Activate text selection.

  # Uncomment the following lines to disable live history search:
  # zle -A {.,}history-incremental-search-forward
  # zle -A {.,}history-incremental-search-backward

  # Return key in completion menu & history menu:
  bindkey -M menuselect '\r' .accept-line
  # .accept-line: Accept command line.
  # accept-line:  Accept selection and exit menu.
fi


########################################################################
# prompt
########################################################################

[[ -r "$HOME/.prompt.zsh" ]] && source "$HOME/.prompt.zsh"


########################################################################
# extra sources
########################################################################

# aliases
[[ -f "$HOME/.aliases" ]] && source "$HOME/.aliases"

# misc
source "git-helpers.sh"


########################################################################
# home setup
#########################################################################

alias home="git --work-tree=$HOME --git-dir=$HOME/.home.git"


# vim: set ft=zsh tw=72 :
