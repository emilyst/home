########################################################################
# non-interactive shell environment
########################################################################


########################################################################
# uncommitted sensitive environment
########################################################################

[[ -e "$HOME/.zshenv.local" ]] && source "$HOME/.zshenv.local"


########################################################################
# general settings
########################################################################

export PAGER="less"
export LESS="CMifSR --tabs=4"
export LESSCHARSET="utf-8"
export EDITOR="vim"
export MLR_CSV_DEFAULT_RS="lf"
export SYSTEMD_LESS=$LESS

if [[ "$TERM_PROGRAM" == 'vscode' ]]; then
  export EDITOR='code --wait -n'
fi

# color scheme
# BASE16_SHELL="$HOME/.config/base16-shell/scripts/base16-ocean.sh"
# [[ -s "$BASE16_SHELL" ]] && source "$BASE16_SHELL"

export QT_BEARER_POLL_TIMEOUT=-1

export NATIVEFIER_APPS_DIR="$HOME/Applications/"

# vim: set ft=zsh tw=100 :
