########################################################################
# interactive shell configuration
########################################################################

setopt ALIASES
setopt AUTOCD
setopt AUTO_PUSHD
setopt BEEP
setopt CORRECT
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
unsetopt NOMATCH  # allow [,],?,etc.
setopt NOTIFY
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_TO_HOME
setopt RM_STAR_SILENT
setopt MULTIOS
setopt PROMPT_SUBST
setopt TRANSIENT_RPROMPT
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
# extended functionality
########################################################################

# +X means don't execute, only load
autoload -Uz +X zmv

# quote pasted URLs
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

# bracketed paste mode (in case nothing else enables, like a plugin)
autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic

# edit command line in $EDITOR with m-e (or esc+e)
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M emacs '^[e' edit-command-line


########################################################################
# miscellaneous formatting
########################################################################

zstyle ':completion:*:descriptions' format %B%d%b # bold

# color scheme
BASE16_SHELL="$HOME/.config/base16-shell/scripts/base16-ocean.sh"
[[ -s "$BASE16_SHELL" ]] && source "$BASE16_SHELL"

# ls colors
autoload -U colors && colors

# Enable ls colors
export LSCOLORS="Gxfxcxdxbxegedabagacad"


########################################################################
# zsh-syntax-highlighting
########################################################################

if [[ -s '/usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' ]]; then
  source '/usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh'
fi

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)


########################################################################
# zsh-autosuggestions
########################################################################

if [[ -s '/usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh' ]]; then
  source '/usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh'
fi

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=5'
ZSH_AUTOSUGGEST_STRATEGY=match_prev_cmd
ZSH_AUTOSUGGEST_USE_ASYNC=1


########################################################################
# zsh-history-substring-search
########################################################################

if [[ -s "$HOME/.local/share/zsh/zsh-history-substring-search/zsh-history-substring-search.zsh" ]]; then
  source "$HOME/.local/share/zsh/zsh-history-substring-search/zsh-history-substring-search.zsh"
fi

# bind Up and Down arrow keys
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# bind P and N for Emacs mode
bindkey -M emacs '^P' history-substring-search-up
bindkey -M emacs '^N' history-substring-search-down

# bind k and j for Vi mode
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down


########################################################################
# iTerm2 shell integration
########################################################################

[[ -e "$HOME/.iterm2_shell_integration.zsh" ]] && source "$HOME/.iterm2_shell_integration.zsh"


########################################################################
# home git setup
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
# sources
########################################################################

# aliases
[[ -f "$HOME/.aliases" ]] && source "$HOME/.aliases"

# misc (if they exist)
# (using `hash` instead of `test -e` for location-agnostic presence testing)
hash "git-helpers.sh" >/dev/null 2>&1 && source "git-helpers.sh"
hash "work.sh"        >/dev/null 2>&1 && source "work.sh"
hash "local.sh"       >/dev/null 2>&1 && source "local.sh"


########################################################################
# Ruby-specific
########################################################################

# # local-only gems (install with gem install --user-install <gem>)
# if hash gem >/dev/null 2>&1; then
#   if [ ! -v RUBYGEMSPATH  ]; then
#     RUBYGEMSPATH="$(ruby -r rubygems -e 'puts Gem.user_dir')"
#     export RUBYGEMSPATH
#     export PATH="$RUBYGEMSPATH/bin:$PATH"
#   fi
# fi

hash rbenv >/dev/null 2>&1 && eval "$(rbenv init -)"


########################################################################
# oh-my-zsh
########################################################################

# We're not going to source the initialization file directly; instead,
# we're going to handpick some of the initialization so that we can skip
# parts that are more costly and unnecessary (such as compaudit, which
# I don't need on every shell invocation; or the theme; or custom
# initialization, which I don't use (or could just do here)).
#
# This is the final part of the shell setup so that all completion gets
# included.

if [[ -d "$HOME/.oh-my-zsh" ]]; then
  export ZSH="$HOME/.oh-my-zsh"
  export COMPLETION_WAITING_DOTS='true'

  # from oh-my-zsh.sh
  fpath=($ZSH/functions $ZSH/completions $fpath)

  fpath=(
    /usr/local/share/zsh-completions
    /usr/local/share/zsh/site-functions
    $fpath
  )

  plugins=(                  \
    colored-man-pages        \
    extract                  \
    gpg-agent                \
    history-substring-search \
    # rails                    \
    # rake                     \
    safe-paste               \
    ssh-agent                \
  )

  autoload -Uz compaudit compinit
  autoload -Uz bashcompinit

  # load core config files from oh-my-zsh
  for config_file ($ZSH/lib/*.zsh); do source $config_file; done

  # add oh-my-zsh plugins to fpath but doesn't source them yet
  for plugin ($plugins); do fpath=($ZSH/plugins/$plugin $fpath); done

  # from zsh docs: The -C flag bypasses both the check for
  # rebuilding the dump file and the usual call to compaudit;
  for dump in $HOME/.zcompdump(N.mh+24); do compinit; done
  compinit -C

  # source all plugins so they're available
  for plugin ($plugins); do source $ZSH/plugins/$plugin/$plugin.plugin.zsh; done

  # create prompt
  [[ -s "$HOME/.prompt" ]] && source "$HOME/.prompt"
fi


########################################################################
# SSH
########################################################################

# fix up permissions every time, just in case
umask 002
if [[ -d "$HOME/.ssh" ]]; then
    chmod 700 "$HOME/.ssh" 2> /dev/null
    chmod 600 "$HOME/.ssh/*" 2> /dev/null
fi

# vim: set ft=zsh tw=72 :
