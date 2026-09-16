# LOCALE

# ensure we have correct locale set (this is mostly for MacOS)
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8



# PATHS

export PATH=$HOME/bin:/usr/bin:/usr/sbin:/bin:/sbin:$PATH

# Brew (Intel; amd64)
if [[ -f /usr/local/bin/brew ]]; then
  export HOMEBREW_PREFIX="/usr/local";
  export HOMEBREW_CELLAR="/usr/local/Cellar";
  export HOMEBREW_REPOSITORY="/usr/local/Homebrew";
  export HOMEBREW_SHELLENV_PREFIX="/usr/local";
  export PATH="/usr/local/bin:/usr/local/sbin${PATH+:$PATH}";
  export MANPATH="/usr/local/share/man${MANPATH+:$MANPATH}:";
  export INFOPATH="/usr/local/share/info:${INFOPATH:-}";
fi

# Brew (M1; arm64)
if [[ -f /opt/homebrew/bin/brew ]]; then
  export HOMEBREW_PREFIX="/opt/homebrew";
  export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
  export HOMEBREW_REPOSITORY="/opt/homebrew";
  export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}";
  export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:";
  export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";
fi



# RUBY version switching

# chruby / rvm (load either one conditionally)
if [ -d /usr/local/share/chruby ]; then
  # chruby (amd64)
  source /usr/local/share/chruby/chruby.sh
  source /usr/local/share/chruby/auto.sh
elif [ -d /opt/homebrew/share/chruby ]; then
  # chruby (arm64)
  source /opt/homebrew/share/chruby/chruby.sh
  source /opt/homebrew/share/chruby/auto.sh
elif [ -x "$HOME/.rvm/scripts/rvm" ]; then
  # rvm
  source ~/.rvm/scripts/rvm
  export PATH=$PATH:$HOME/.rvm/bin
fi

# also add chruby_auto to precmd_functions so that zsh prompt is always up-to-date
# this fixes https://github.com/postmodern/chruby/issues/465
if [[ ! "$precmd_functions" == *chruby_auto* ]]; then
  precmd_functions+=("chruby_auto")
fi

if typeset -f chruby_auto > /dev/null; then
  # Automatically switch to the ruby version specified in the .ruby-version file
  # present in the current directory; This is required for goneovim/VimR
  chruby_auto
fi

# rubygems config telling it to activate gems found in the Gemfile file
# which is found in the current directory (or any parent directory)
# in order to never have to type `bundle exec` again
# http://nicknovitski.com/bundle-exec
export RUBYGEMS_GEMDEPS=-
