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

# rubygems config telling it to activate gems found in the Gemfile file
# which is found in the current directory (or any parent directory)
# in order to never have to type `bundle exec` again
# http://nicknovitski.com/bundle-exec
export RUBYGEMS_GEMDEPS=-



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
