########################################################################
# paths
########################################################################

[[ -d "${HOME}/.local/bin" ]] && export PATH="${HOME}/.local/bin:${PATH}"
[[ -d "${HOME}/.local/sbin" ]] && export PATH="${HOME}/.local/sbin:${PATH}"


########################################################################
# Rust
########################################################################

if [[ -d "/opt/homebrew/opt/rustup/bin" ]]; then
  export PATH="/opt/homebrew/opt/rustup/bin:${PATH}"
fi

if [[ -d "${HOME}/.cargo/bin" ]]; then
  export PATH="${HOME}/.cargo/bin:${PATH}"
fi

if [[ -r "$HOME/.cargo/env" ]]; then
  source "$HOME/.cargo/env"
fi


########################################################################
# Homebrew
########################################################################

export HOMEBREW_INSTALL_BADGE=""
export HOMEBREW_NO_EMOJI=1
export HOMEBREW_NO_INSTALL_CLEANUP=1
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_ANALYTICS=1

if [[ -d "/opt/homebrew/" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi


########################################################################
# Jetbrains IDEs
########################################################################

if [[ -d "$HOME/Library/Application Support/JetBrains/Toolbox/scripts" ]]; then
  export PATH="$HOME/Library/Application Support/JetBrains/Toolbox/scripts:$PATH"
fi


########################################################################
# PostgreSQL
########################################################################

# prefer newest PostgreSQL version available
for i in {1..20}; do
  if [[ -d "${HOMEBREW_PREFIX}/opt/postgresql@${i}/bin" ]]; then
    export PATH="${HOMEBREW_PREFIX}/opt/postgresql@${i}/bin:${PATH}"
  fi
done


########################################################################
# Python-specific
########################################################################

export PIP_DISABLE_PIP_VERSION_CHECK=1
export PIP_NO_CACHE_DIR=1
export PYTHONDONTWRITEBYTECODE=1
export PYENV_ROOT="${HOME}/.pyenv"
export PATH="${PYENV_ROOT}/bin:${PATH}"

type pyenv &> /dev/null && eval "$(pyenv init --path)"


########################################################################
# Perl-specific
########################################################################

export PERL5LIB="${HOME}/.local/lib/perl5:${PERL5LIB}"
export PERL_CPANM_OPT="-L ${HOME}/.local --self-contained"
export PERLBREW_ROOT="/opt/perl"
#[[ -e /opt/perl/etc/bashrc ]] && source /opt/perl/etc/bashrc


########################################################################
# Ruby-specific
########################################################################

export DISABLE_SPRING="true"
export WEB_CONCURRENCY=0

type rbenv &> /dev/null && eval "$(rbenv init - zsh)"


########################################################################
# Go
########################################################################

export GOPATH="${HOME}/Developer/go"
export GOBIN="${GOPATH}/bin"
export PATH="${GOBIN}:${PATH}"


# vim: set ft=zsh tw=100 :
