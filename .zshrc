# zsh-specific

setopt appendhistory autocd beep extendedglob nomatch notify
bindkey -e

# oh-my-zsh
if [ -d $HOME/.oh-my-zsh ] ; then
    # Path to your oh-my-zsh configuration.
    export ZSH=$HOME/.oh-my-zsh
    export DISABLE_AUTO_UPDATE="true"
    export COMPLETION_WAITING_DOTS="true"

    plugins=(git autojump jira nyan pip osx ruby brew extract git-extras history perl rsync sublime ssh-agent pass python cpanm cp yum virtualenv virtualenvwrapper)

    source $ZSH/oh-my-zsh.sh

    # prompt
    [ -s $HOME/.prompt ] && source $HOME/.prompt
fi

# setup-specific
alias home="git --work-tree=$HOME --git-dir=$HOME/.home.git"

# shell-agnostic
[ -s $HOME/.rc ] && source $HOME/.rc
