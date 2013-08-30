########################################################################
# general
########################################################################

setopt appendhistory autocd beep extendedglob nomatch notify AUTO_PUSHD

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


########################################################################
# oh-my-zsh
########################################################################

if [ -d $HOME/.oh-my-zsh ] ; then
    # Path to your oh-my-zsh configuration.
    export ZSH=$HOME/.oh-my-zsh
    export DISABLE_AUTO_UPDATE="true"
    export COMPLETION_WAITING_DOTS="true"

    plugins=(                   \
        autojump                \
        brew                    \
        cp                      \
        cpanm                   \
        encode64                \
        extract                 \
        fasd                    \
        git                     \
        git-extras              \
        git-flow                \
        github                  \
        history                 \
        jira                    \
        nyan                    \
        osx                     \
        pass                    \
        pip                     \
        python                  \
        rsync                   \
        ruby                    \
        ssh-agent               \
        sublime                 \
        virtualenv              \
        yum                     \
        zsh-syntax-highlighting \
    )

    source $ZSH/oh-my-zsh.sh

    # prompt
    [ -s $HOME/.prompt ] && source $HOME/.prompt
fi


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


#########################################################################
# shell-agnostic
#########################################################################

[ -s $HOME/.rc ] && source $HOME/.rc

