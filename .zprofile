########################################################################
# paths
########################################################################

[[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"

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
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi


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

# # local-only gems (install with gem install --user-install <gem>)
# if (( ${+commands[gem]} )); then
#   if [ ! -v RUBYGEMSPATH  ]; then
#     RUBYGEMSPATH="$(ruby -r rubygems -e 'puts Gem.user_dir')"
#     export RUBYGEMSPATH
#     export PATH="$RUBYGEMSPATH/bin:$PATH"
#   fi
# fi

(( ${+commands[rbenv]} )) && eval "$(rbenv init -)"
export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"


########################################################################
# Java-specific
########################################################################

# if (( ! ${+JAVA_HOME} )); then
#   if [[ -x '/usr/libexec/java_home' ]]; then
#     export JAVA_HOME="$(/usr/libexec/java_home -v 1.8 2> /dev/null)"
#     export PATH="$JAVA_HOME/bin:$PATH"
#   fi
# fi

# if (( ! ${+MAVEN_OPTS} )); then
#   export MAVEN_OPTS="-Xmx2048m -Xss2M -XX:ReservedCodeCacheSize=128m"
# fi

# if (( ! ${+_JAVA_OPTIONS} )); then
#   export _JAVA_OPTIONS=-Djava.awt.headless=true
# fi


########################################################################
# Scala-specific
########################################################################

# SCALAPATH="/usr/local/opt/scala@2.11/bin"
# [[ -d "$SCALAPATH" ]] && export PATH="$SCALAPATH:$PATH"



########################################################################
# Rust
########################################################################

if [[ -d "$HOME/.cargo/bin" ]]; then
  export PATH="$HOME/.cargo/bin:$PATH"
fi


########################################################################
# general settings
########################################################################

export LC_ALL="en_US.UTF-8"
if [[ -e "/usr/share/zoneinfo/UTC" ]]; then
  export TZ=":/usr/share/zoneinfo/UTC"
else
  export TZ="UTC"
fi

skip_global_compinit=1


# vim: set ft=zsh tw=100 :

export PATH="$HOME/.cargo/bin:$PATH"
