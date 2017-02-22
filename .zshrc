########################################################################
# shell
########################################################################

setopt CORRECT AUTOCD BEEP EXTENDEDGLOB NOMATCH NOTIFY AUTO_PUSHD

AUTO_CD=1
CD_ABLE_VARS=1
CORRECT=1

# # Show contents of directory after cd-ing into it
# chpwd() {
#   ls -lrthG
# }

zstyle ':completion:*:descriptions' format %B%d%b # bold

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)

autoload -U zmv

fpath=(/usr/local/share/zsh-completions $fpath)

if [ -s /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]
then
    source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# quote pasted URLs
autoload -U url-quote-magic
zle -N self-insert url-quote-magic


########################################################################
# help
########################################################################

autoload -U run-help
autoload run-help-git
HELPDIR=/usr/local/share/zsh/helpfiles


########################################################################
# oh-my-zsh
########################################################################

if [ -d $HOME/.oh-my-zsh ] ; then
    # Path to your oh-my-zsh configuration.
    export ZSH=$HOME/.oh-my-zsh
    export DISABLE_AUTO_UPDATE="true"
    export COMPLETION_WAITING_DOTS="true"

    plugins=(                    \
        autojump                 \
        brew                     \
        cp                       \
        cpanm                    \
        encode64                 \
        extract                  \
        gpg-agent                \
        history                  \
        history-substring-search \
        nyan                     \
        osx                      \
        pass                     \
        pip                      \
        python                   \
        rsync                    \
        ruby                     \
        safe-paste               \
        ssh-agent                \
        virtualenv               \
        yum                      \
        zsh-syntax-highlighting  \
    )

    source $ZSH/oh-my-zsh.sh

    # prompt
    [ -s $HOME/.prompt ] && source $HOME/.prompt
fi


########################################################################
# keyboard
########################################################################

# bindkey "^[[A" history-beginning-search-backward
# bindkey "^[[B" history-beginning-search-forward

# bind UP and DOWN arrow keys
zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

# bind UP and DOWN arrow keys (compatibility fallback
# for Ubuntu 12.04, Fedora 21, and MacOSX 10.9 users)
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# bind P and N for EMACS mode
bindkey -M emacs '^P' history-substring-search-up
bindkey -M emacs '^N' history-substring-search-down

# bind k and j for VI mode
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down


########################################################################
# vi-mode (based on oh-my-zsh plugin)
########################################################################

# function zle-keymap-select zle-line-init
# {
#     # change cursor shape in iTerm2
#     case $KEYMAP in
#         vicmd)      print -n -- "\E]50;CursorShape=0\C-G";;  # block cursor
#         viins|main) print -n -- "\E]50;CursorShape=1\C-G";;  # line cursor
#     esac

#     zle reset-prompt
#     zle -R
# }

# function zle-line-finish
# {
#     print -n -- "\E]50;CursorShape=0\C-G"  # block cursor
# }

# zle -N zle-line-init
# zle -N zle-line-finish
# zle -N zle-keymap-select

# bindkey -v

# # 10ms for key sequences
# KEYTIMEOUT=1

# # bindings

# # move through history
# bindkey -a 'gg' beginning-of-buffer-or-history
# bindkey -a 'g~' vi-oper-swap-case
# bindkey -a G end-of-buffer-or-history

# # search history ('f'ind)
# bindkey "^F" history-incremental-search-backward

# # undo/redo
# bindkey -a u undo
# bindkey -a '^R' redo
# bindkey '^?' backward-delete-char
# bindkey '^H' backward-delete-char

# # get cursor position (like vi)
# bindkey '^G' what-cursor-position


########################################################################
# home git setup
#########################################################################

alias home="git --work-tree=$HOME --git-dir=$HOME/.home.git"

# function setup_for_home_git
# {
#     if [[ $HOME == $PWD ]]
#     then
#         export GIT_DIR=$HOME/.home.git
#         export GIT_WORK_TREE=$HOME
#     else
#         unset GIT_DIR
#         unset GIT_WORK_TREE
#     fi
# }

# setup_for_home_git
# chpwd_functions=( $chpwd_functions setup_for_home_git )

########################################################################
# paths
########################################################################

[ -d /usr/local/sbin ]  && export PATH=/usr/local/sbin:"${PATH}"
[ -d /usr/local/bin ]   && export PATH=/usr/local/bin:"${PATH}"
[ -d ~/.local/bin ]     && export PATH=~/.local/bin:"${PATH}"
[ -d ~/bin ]            && export PATH=~/bin:"${PATH}"
[ -d ~/.bin ]           && export PATH=~/.bin:"${PATH}"

cdpath=(. ~/work ~/scratch ~/Development)


########################################################################
# environment
########################################################################

export LC_ALL="en_US.UTF-8"
if [ -e /usr/share/zoneinfo/UTC ]
then
  export TZ=":/usr/share/zoneinfo/UTC"
else
  export TZ="UTC"
fi
export CLICOLOR=1
export PAGER='less'
export LESS='CMifSR --tabs=4'
export LESSCHARSET='utf-8'
export EDITOR=vim
export GIT_PAGER=$PAGER
hash diff-so-fancy > /dev/null 2>&1 && export GIT_PAGER="diff-so-fancy | less"
export MLR_CSV_DEFAULT_RS='lf'

# for neovim
# export NVIM_TUI_ENABLE_TRUE_COLOR=1
export NVIM_TUI_ENABLE_CURSOR_SHAPE=1

# useful for work
export GITHUB_URL="https://github.banksimple.com/"

# color scheme
BASE16_SHELL="$HOME/.config/base16-shell/scripts/base16-ocean.sh"
[[ -s $BASE16_SHELL ]] && source $BASE16_SHELL


########################################################################
# history
########################################################################

setopt HIST_FIND_NO_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY
export HISTFILE=~/.history
export HISTFILESIZE=50000000
export HISTSIZE=5000000
export SAVEHIST=$HISTSIZE
export HISTIGNORE='l:ls:la:ll:cd:w'
export HISTTIMEFORMAT='%Y-%m-%d %H:%M:%S - '
export HISTCONTROL=ignoredups:ignorespace


########################################################################
# sources
########################################################################

# aliases
[ -f ~/.aliases ] && source ~/.aliases

# misc (if they exist)
hash git-helpers.sh >/dev/null 2>&1 && source git-helpers.sh
hash work.sh        >/dev/null 2>&1 && source work.sh
hash local.sh       >/dev/null 2>&1 && source local.sh


########################################################################
# Python
########################################################################

# export PYTHONDONTWRITEBYTECODE=1
# [ hash virtualenvwrapper.sh >/dev/null 2>&1 ] && source virtualenvwrapper.sh
# [ -d /usr/local/lib/python2.7/site-packages ] && export PYTHONPATH=/usr/local/lib/python2.7/site-packages:$PYTHONPATH


########################################################################
# Perl
########################################################################

export PERL5LIB=$HOME/.local/lib/perl5:$PERL5LIB
export PERL_CPANM_OPT='-L ~/.local --self-contained'

export PERLBREW_ROOT=/opt/perl
#[ -e /opt/perl/etc/bashrc ] && source /opt/perl/etc/bashrc


########################################################################
# ruby
########################################################################

#export RBENV_ROOT=/usr/local/var/rbenv
#[ -d "${HOME}/.rvm/bin" ] && export PATH="${HOME}/.rvm/bin":"${PATH}"


########################################################################
# java
########################################################################

if [ -x /usr/libexec/java_home ]; then
    export JAVA_HOME="$(/usr/libexec/java_home -v 1.8)"
    export PATH=$JAVA_HOME/bin:$PATH
fi
export MAVEN_OPTS="-Xmx2048m -XX:ReservedCodeCacheSize=128m"
# export _JAVA_OPTIONS=-Djava.awt.headless=true


########################################################################
# Node
########################################################################

[ -d /usr/local/share/npm/bin ] && export PATH="${PATH}:/usr/local/share/npm/bin"


########################################################################
# SSH
########################################################################

umask 002
if [ -d ~/.ssh ]; then
    chmod 700 ~/.ssh 2> /dev/null
    chmod 600 ~/.ssh/* 2> /dev/null
fi

# vim: set ft=zsh tw=100 :
