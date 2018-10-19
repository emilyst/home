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

export LC_ALL="en_US.UTF-8"
if [[ -e "/usr/share/zoneinfo/UTC" ]]; then
  export TZ=":/usr/share/zoneinfo/UTC"
else
  export TZ="UTC"
fi
export PAGER="less"
export LESS="CMifSR --tabs=4"
export LESSCHARSET="utf-8"
export EDITOR="vim"
export MLR_CSV_DEFAULT_RS="lf"

skip_global_compinit=1

# color scheme
# BASE16_SHELL="$HOME/.config/base16-shell/scripts/base16-ocean.sh"
# [[ -s "$BASE16_SHELL" ]] && source "$BASE16_SHELL"

export HOMEBREW_INSTALL_BADGE="🔮✨"


########################################################################
# paths
########################################################################

[[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"

cdpath=("." "$HOME/work" "$HOME/scratch" "$HOME/Development")

# add homebrew bc if it's there
[[ -d "/usr/local/opt/bc/bin" ]] && export PATH="/usr/local/opt/bc/bin:$PATH"


########################################################################
# PostgreSQL-specific
########################################################################

# for systems using Homebrew
POSTGRESQLPATH="/usr/local/opt/postgresql@9.6/bin"
POSTGRESQLLDFLAGS="/usr/local/opt/postgresql@9.6/lib"
POSTGRESQLCPPFLAGS="/usr/local/opt/postgresql@9.6/include"

if [[ -d "$POSTGRESQLPATH" ]]; then
  export PATH="$POSTGRESQLPATH:$PATH"
fi

if [[ -d "$POSTGRESQLLDFLAGS" ]]; then
  export LDFLAGS="-L$POSTGRESQLLDFLAGS $LDFLAGS"
fi

if [[ -d "$POSTGRESQLCPPFLAGS" ]]; then
  export CPPFLAGS="-I$POSTGRESQLCPPFLAGS $CPPFLAGS"
fi


########################################################################
# Python-specific
########################################################################

export PYTHONDONTWRITEBYTECODE=1
# [[ hash virtualenvwrapper.sh >/dev/null 2>&1 ]] && source virtualenvwrapper.sh
# [[ -d /usr/local/lib/python2.7/site-packages ]] && export PYTHONPATH=/usr/local/lib/python2.7/site-packages:$PYTHONPATH


########################################################################
# Perl-specific
########################################################################

export PERL5LIB="$HOME/.local/lib/perl5:$PERL5LIB"
export PERL_CPANM_OPT="-L $HOME/.local --self-contained"
export PERLBREW_ROOT=/opt/perl
#[[ -e /opt/perl/etc/bashrc ]] && source /opt/perl/etc/bashrc


########################################################################
# Ruby-specific
########################################################################

# local gems
# if [[ -x /usr/bin/ruby && -x /usr/bin/gem ]]; then
#   if [ ! -v RUBYGEMSPATH  ]; then
#     RUBYGEMSPATH="$(ruby -r rubygems -e 'puts Gem.user_dir')"
#     export RUBYGEMSPATH
#     export PATH="$RUBYGEMSPATH/bin:$PATH"
#   fi
# fi


########################################################################
# Java-specific
########################################################################

if [[ -x "/usr/libexec/java_home" ]]; then
  if [ ! -v JAVA_HOME ]; then
    JAVA_HOME="$(/usr/libexec/java_home -v 1.8 2> /dev/null)"
    export JAVA_HOME
    export PATH="$JAVA_HOME/bin:$PATH"
  fi
fi
export MAVEN_OPTS="-Xmx2048m -Xss2M -XX:ReservedCodeCacheSize=128m"
# export _JAVA_OPTIONS=-Djava.awt.headless=true


########################################################################
# Scala-specific
########################################################################

SCALAPATH="/usr/local/opt/scala@2.11/bin"
[[ -d "$SCALAPATH" ]] && export PATH="$SCALAPATH:$PATH"


########################################################################
# Node-specific
########################################################################

[[ -d "/usr/local/share/npm/bin" ]] && export PATH="$PATH:/usr/local/share/npm/bin"
[[ -d  "$HOME/.nvm" ]] && export NVM_DIR="$HOME/.nvm"
[[ -e "/usr/local/opt/nvm/nvm.sh" ]] && source "/usr/local/opt/nvm/nvm.sh" --no-use

# vim: set ft=zsh tw=100 :
