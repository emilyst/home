########################################################################
# interactive shell configuration
########################################################################

setopt ALIASES
setopt AUTO_CD
setopt AUTO_PUSHD
setopt BEEP
setopt CORRECT
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt MULTIOS
setopt NOTIFY
setopt PROMPT_SUBST
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_TO_HOME
setopt RM_STAR_SILENT
setopt SUNKEYBOARDHACK
setopt TRANSIENT_RPROMPT

unsetopt ALWAYS_TO_END
unsetopt AUTO_MENU
unsetopt COMPLETE_IN_WORD
unsetopt NOMATCH  # allow [, ], ?, etc.
# see also history section below


########################################################################
# history
########################################################################

setopt EXTENDED_HISTORY
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY

export HISTFILE="${HOME}/.history"
export HISTFILESIZE=50000000
export HISTSIZE=5000000
export SAVEHIST=$HISTSIZE


########################################################################
# completions
########################################################################

if [[ -d "${HOMEBREW_PREFIX}/share/zsh-completions" ]]; then
  FPATH="${HOMEBREW_PREFIX}/share/zsh-completions:${FPATH}"
fi

if [[ -d "${HOMEBREW_PREFIX}/share/zsh/site-functions:${FPATH}" ]]; then
  FPATH="${HOMEBREW_PREFIX}/share/zsh/site-functions:${FPATH}"
fi

zstyle ":completion:*" completer _expand _complete _ignored _approximate
zstyle ":completion:*" matcher-list "m:{a-z}={A-Z}"
zstyle ":completion:*" menu select=2
zstyle ":completion:*" rehash true
zstyle ":completion:*" select-prompt "%SScrolling active: current selection at %p%s"
zstyle ":completion:*:*:cdr:*:*" menu selection
zstyle ":completion:*:descriptions" format "%U%B%F{cyan}%d%f%b%u"
zstyle ":completion::complete:*" use-cache 1

if [[ -n "${ZSH_VERSION-}" ]]; then
  autoload -U +X compinit && if [[ "${ZSH_DISABLE_COMPFIX-}" = true ]]; then
    compinit -u
  else
    compinit
  fi
  autoload -U +X bashcompinit && bashcompinit
fi


########################################################################
# zsh functions
########################################################################

autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs

autoload -Uz +X zmv
autoload -Uz +X zargs


#######################################################################
# zle widgets
#######################################################################

autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic


########################################################################
# bindings
########################################################################

zmodload -i zsh/terminfo

if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
  autoload -Uz add-zle-hook-widget

  function zle-application-mode-start { echoti smkx }
  function zle-application-mode-stop { echoti rmkx }

  add-zle-hook-widget -Uz zle-line-init zle-application-mode-start
  add-zle-hook-widget -Uz zle-line-finish zle-application-mode-stop
fi

autoload -Uz up-line-or-beginning-search
zle -N up-line-or-beginning-search

autoload -Uz down-line-or-beginning-search
zle -N down-line-or-beginning-search

[[ -n "${terminfo[khome]}" ]] && bindkey -- "${terminfo[khome]}" beginning-of-line
[[ -n "${terminfo[kend]}"  ]] && bindkey -- "${terminfo[kend]}"  end-of-line
[[ -n "${terminfo[kich1]}" ]] && bindkey -- "${terminfo[kich1]}" overwrite-mode
[[ -n "${terminfo[kbs]}"   ]] && bindkey -- "${terminfo[kbs]}"   backward-delete-char
[[ -n "${terminfo[kdch1]}" ]] && bindkey -- "${terminfo[kdch1]}" delete-char
[[ -n "${terminfo[kcuu1]}" ]] && bindkey -- "${terminfo[kcuu1]}" up-line-or-beginning-search
[[ -n "${terminfo[kcud1]}" ]] && bindkey -- "${terminfo[kcud1]}" down-line-or-beginning-search
[[ -n "${terminfo[kcub1]}" ]] && bindkey -- "${terminfo[kcub1]}" backward-char
[[ -n "${terminfo[kcuf1]}" ]] && bindkey -- "${terminfo[kcuf1]}" forward-char
[[ -n "${terminfo[kpp]}"   ]] && bindkey -- "${terminfo[kpp]}"   beginning-of-buffer-or-history
[[ -n "${terminfo[knp]}"   ]] && bindkey -- "${terminfo[knp]}"   end-of-buffer-or-history
[[ -n "${terminfo[kcbt]}"  ]] && bindkey -- "${terminfo[kcbt]}"  reverse-menu-complete
[[ -n "${terminfo[kLFT3]}" ]] && bindkey -- "${terminfo[kLFT3]}" backward-word # alt-left
[[ -n "${terminfo[kRIT3]}" ]] && bindkey -- "${terminfo[kRIT3]}" forward-word # alt-right
[[ -n "${terminfo[kLFT9]}" ]] && bindkey -- "${terminfo[kLFT9]}" backward-word # meta-left
[[ -n "${terminfo[kRIT9]}" ]] && bindkey -- "${terminfo[kRIT9]}" forward-word # meta-right

bindkey "^R" history-incremental-pattern-search-backward
bindkey "^S" history-incremental-pattern-search-forward


########################################################################
# prompt
########################################################################

autoload -Uz promptinit && promptinit

prompt redhat


########################################################################
# aliases
########################################################################

[[ -f "${HOME}/.aliases" ]] && source "${HOME}/.aliases"

source "git-helpers.sh"

alias home="git --work-tree=${HOME} --git-dir=${HOME}/.home.git"


# vim: set ft=zsh tw=72 :
