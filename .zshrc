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

# # Show contents of directory after cd-ing into it
# chpwd() {
#   ls -lrthG
# }

# rm -f ~/.zcompdump; compinit # if necessary
fpath=(
  /usr/local/share/zsh-completions
  /usr/local/share/zsh/site-functions
  $fpath
)


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
# oh-my-zsh
########################################################################

if [[ -d "$HOME/.oh-my-zsh" ]]; then
    # Path to your oh-my-zsh configuration.
    export ZSH="$HOME/.oh-my-zsh"
    export DISABLE_AUTO_UPDATE='true'
    export COMPLETION_WAITING_DOTS='true'
    unset ZSH_THEME
    export ZSH_DISABLE_COMPFIX='true'

    plugins=(                    \
        colored-man-pages        \
        extract                  \
        gpg-agent                \
        history-substring-search \
        rails                    \
        rake                     \
        safe-paste               \
        ssh-agent                \
        zsh-syntax-highlighting  \
    )

    source "$ZSH/oh-my-zsh.sh"

    # prompt
    [[ -s "$HOME/.prompt" ]] && source "$HOME/.prompt"
fi


########################################################################
# other setup
########################################################################

autoload -Uz compinit
autoload -Uz bashcompinit

# only compinit fully after 24 hours
# from zsh docs: The -C flag bypasses both the check for
# rebuilding the dump file and the usual call to compaudit
for dump in $HOME/.zcompdump(N.mh+24); do
  compinit
done
compinit -C

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

# ls colors
autoload -U colors && colors

# Enable ls colors
export LSCOLORS="Gxfxcxdxbxegedabagacad"

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)

if [[ -s "/usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
  source "/usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

zstyle ':completion:*:descriptions' format %B%d%b # bold

# color scheme
BASE16_SHELL="$HOME/.config/base16-shell/scripts/base16-ocean.sh"
[[ -s "$BASE16_SHELL" ]] && source "$BASE16_SHELL"

# iTerm2 integration and utilities (e.g., imgcat)
[[ -e "$HOME/.iterm2_shell_integration.zsh" ]] && source "$HOME/.iterm2_shell_integration.zsh"


########################################################################
# keyboard
########################################################################

# bind UP and DOWN arrow keys
zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

# bind P and N for EMACS mode
bindkey -M emacs '^P' history-substring-search-up
bindkey -M emacs '^N' history-substring-search-down

# bind k and j for VI mode
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down


########################################################################
# home git setup
#########################################################################

alias home="git --work-tree=$HOME --git-dir=$HOME/.home.git"

function detect_home_git
{
    if [[ $HOME == $PWD ]]; then
        export GIT_DIR=$HOME/.home.git
        export GIT_WORK_TREE=$HOME
    else
        unset GIT_DIR
        unset GIT_WORK_TREE
    fi
}

detect_home_git
chpwd_functions=(detect_home_git $chpwd_functions)



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
# SSH
########################################################################

# fix up permissions every time, just in case
umask 002
if [[ -d "$HOME/.ssh" ]]; then
    chmod 700 "$HOME/.ssh" 2> /dev/null
    chmod 600 "$HOME/.ssh/*" 2> /dev/null
fi

# vim: set ft=zsh tw=100 :
