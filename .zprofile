# LOCALE

# ensure we have correct locale set (this is mostly for MacOS)
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8



# PATHS

export PATH=$HOME/bin:/usr/bin:/usr/sbin:/bin:/sbin:$PATH

# fpath (for zsh-completions)
fpath=(~/.zsh/bundles/olivierverdier/zsh-git-prompt/src $fpath)

# Brew (amd64)
if [[ -f /usr/local/bin/brew ]]; then
  export HOMEBREW_PREFIX="/usr/local";
  export HOMEBREW_CELLAR="/usr/local/Cellar";
  export HOMEBREW_REPOSITORY="/usr/local/Homebrew";
  export HOMEBREW_SHELLENV_PREFIX="/usr/local";
  export PATH="/usr/local/bin:/usr/local/sbin${PATH+:$PATH}";
  export MANPATH="/usr/local/share/man${MANPATH+:$MANPATH}:";
  export INFOPATH="/usr/local/share/info:${INFOPATH:-}";
fi

# Brew (arm64)
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

# chruby + binstubs
# http://hmarr.com/2012/nov/08/rubies-and-bundles/
# http://code.jjb.cc/2012/11/09/putting-your-rbenv-managed-bundler-specified-executables-in-your-path-more-securely/
# http://stackoverflow.com/questions/13881608/issues-installing-gems-when-using-bundlers-binstubs
# https://github.com/sstephenson/rbenv/wiki/Understanding-binstubs
# https://github.com/postmodern/chruby/wiki/Implementing-an-'after-use'-hook
function setup_binstubs {
  if [ -r $OLDPWD/Gemfile.lock ] && [ -d $OLDPWD/.bundle/bin ]; then
    # delete from $OLDPWD (.bin/ and .bundle/bin/ from $PATH, .bundle/ from $GEM_PATH)
    export PATH=${PATH//$OLDPWD\/bin:}
    export PATH=${PATH//$OLDPWD\/\.bundle\/bin:}
    export GEM_PATH=${GEM_PATH//$OLDPWD\/\.bundle:}

    # restore GEM_HOME / GEM_ROOT when using chruby (using wrapper)
    if [[ -d /usr/local/opt/chruby/share/chruby || -d /opt/homebrew/share/chruby ]]; then
      export GEM_HOME=~/.gem/ruby/$(~/bin/chruby-wrapper -e 'print RUBY_VERSION')
      export GEM_ROOT=~/.rubies/ruby-$(~/bin/chruby-wrapper -e 'print RUBY_VERSION')/lib/ruby/gems/$(~/bin/chruby-wrapper -e 'print RUBY_VERSION.gsub(/\d$/, "0")')
    fi
  fi

  if [ -r $PWD/Gemfile.lock ] && [ -d $PWD/.bundle/bin ]; then
    # add .bundle/bin to $PATH and .bundle/ to $GEM_PATH (deleting existing entries first) AND set a new $GEM_HOME
    export PATH=$PWD/.bundle/bin:${PATH//$PWD\/\.bundle\/bin:}
    export GEM_PATH=$PWD/.bundle:${GEM_PATH//$PWD\/\.bundle:}

    # set GEM_HOME
    export GEM_HOME=$PWD/.bundle

    # set GEM_ROOT
    export GEM_ROOT=$PWD/.bundle
  fi

  if [ -r $PWD/Gemfile.lock ] && [ -d $PWD/bin ]; then
    # add bin/ to $PATH (Rails 4+) (has precedence over .bundle/bin)
    export PATH=$PWD/bin:${PATH//$PWD\/bin:}
  fi
}

autoload -U add-zsh-hook

# setup chruby on cd
if [[ -d /usr/local/opt/chruby/share/chruby || -d /opt/homebrew/share/chruby ]]; then
  # remove the preexec hook added by chruby (we will be using chruby_auto in a chpwd hook)
  add-zsh-hook -d preexec chruby_auto

  # add chruby_auto and calls for every directory change (needed so that prompt works)
  add-zsh-hook chpwd chruby_auto

  # execute on first run, so that we have everything setup correctly regardless of the directory we open new terminal window in
  chruby_auto
fi

# add setup_binstubs calls for every directory change (needed so that zsh prompt works)
add-zsh-hook chpwd setup_binstubs

# execute on first run, so that we have everything setup correctly regardless of the directory we open new terminal window in
setup_binstubs



# MISC STUFF

# [RUBY] (make GC speedier by using more memory) (sources: https://gist.github.com/1688857, https://gist.github.com/jjb/7389552/)
# (1.9.x, 2.0.0)
export RUBY_HEAP_MIN_SLOTS=1000000            # (1M) initial number of slots on the heap as well as the minimum number of slots allocated
export RUBY_FREE_MIN=100000                   # (1M) minimum number of heap slots that should be available after GC runs; if they are not available then, ruby will allocate more slots
# (1.9.x, 2.0.0, 2.1.0+)
export RUBY_GC_MALLOC_LIMIT=90000000          # (90MB) number of C data structures that can be allocated before GC kicks in; if too low, GC will run even if there are still heap slots available; too high setting will increase memory fragmentation
# (2.1.0+)
export RUBY_GC_HEAP_INIT_SLOTS=1000000        # (1M) (renamed from RUBY_HEAP_MIN_SLOTS)
export RUBY_GC_HEAP_FREE_SLOTS=1000000        # (1M) (renamed from RUBY_FREE_MIN)
export RUBY_GC_HEAP_GROWTH_FACTOR=1.2         # (1.2) factor used to grow the heap; since our heap is already quite big with the settings above, we reduce the growth factor to add slots in smaller increments.
export RUBY_GC_HEAP_GROWTH_MAX_SLOTS=300000   # (300K) maximum new slots to add; in addition to reducing the growth factor, we cap it so a maximum of 300k objects can be added to the heap at once
export RUBY_GC_MALLOC_LIMIT_GROWTH_FACTOR=1.2 # (1.2) factor used to grow malloc; since our limit is already big, no need to increase it further
export RUBY_GC_MALLOC_LIMIT_MAX=200000000     # (200MB) (?)
# (2.1.0+ variables for oldgen GC)
export RUBY_GC_OLDMALLOC_LIMIT=$RUBY_GC_MALLOC_LIMIT
export RUBY_GC_OLDMALLOC_LIMIT_MAX=$RUBY_GC_MALLOC_LIMIT_MAX
export RUBY_GC_OLDMALLOC_LIMIT_GROWTH_FACTOR=$RUBY_GC_MALLOC_LIMIT_GROWTH_FACTOR

# Reduce maximum number of OS heaps: https://www.joyfulbikeshedding.com/blog/2019-03-14-what-causes-ruby-memory-bloat.html
export MALLOC_ARENA_MAX=2
