########################################################################
# non-interactive shell environment
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
export GIT_PAGER="$PAGER"
hash diff-so-fancy > /dev/null 2>&1 && export GIT_PAGER="diff-so-fancy | less"
export MLR_CSV_DEFAULT_RS="lf"

# useful for work
export GITHUB_URL="https://github.banksimple.com/"

skip_global_compinit=1


########################################################################
# paths
########################################################################

[[ -d "/usr/local/sbin" ]]  && export PATH="/usr/local/sbin:$PATH"
[[ -d "/usr/local/bin" ]]   && export PATH="/usr/local/bin:$PATH"
[[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"
[[ -d "$HOME/bin" ]]        && export PATH="$HOME/bin:$PATH"
[[ -d "$HOME/.bin" ]]       && export PATH="$HOME/.bin:$PATH"

cdpath=("." "$HOME/work" "$HOME/scratch" "$HOME/Development")

# add homebrew bc if it's there
[[ -d "/usr/local/opt/bc/bin" ]] && export PATH="/usr/local/opt/bc/bin:$PATH"


########################################################################
# PostgreSQL-specific
########################################################################

# for systems using Homebrew
POSTGRESQLPATH="/usr/local/opt/postgresql@9.4/bin"

if [[ -d "$POSTGRESQLPATH" ]]; then
  export PATH="$POSTGRESQLPATH:$PATH"
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

CHRUBY_PATH="/usr/local/opt/chruby/share/chruby/chruby.sh"
CHRUBY_AUTO_PATH="/usr/local/opt/chruby/share/chruby/auto.sh"
if [[ -e "$CHRUBY_PATH" ]]; then
  source "$CHRUBY_PATH" && source "$CHRUBY_AUTO_PATH"
fi
#export RBENV_ROOT=/usr/local/var/rbenv
#[[ -d "${HOME}/.rvm/bin" ]] && export PATH="${HOME}/.rvm/bin":"${PATH}"


########################################################################
# Java-specific
########################################################################

if [[ -x "/usr/libexec/java_home" ]]; then
    export JAVA_HOME="$(/usr/libexec/java_home -v 1.8 2> /dev/null)"
    export PATH="$JAVA_HOME/bin:$PATH"
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

# vim: set ft=zsh tw=100 :
