# look for and use zsh if it's around and not already running
if [ -z "$ZSH_VERSION" ];
then
    [ -f $HOME/.local/bin/zsh ] && exec $HOME/.local/bin/zsh -l
    [ -f /usr/local/bin/zsh ] && exec /usr/local/bin/zsh -l
    [ -f /bin/zsh ] && exec /bin/zsh -l
fi
