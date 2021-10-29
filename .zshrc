# ANTIGEN

# directory to store cloned antigen repositories
export ADOTDIR=~/.zsh

# load antigen
source ~/.zsh/antigen/antigen.zsh

# define the plugins
antigen bundle jimhester/per-directory-history
antigen bundle olivierverdier/zsh-git-prompt
antigen bundle nviennot/zsh-vim-plugin
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle jeffreytse/zsh-vi-mode

# load the plugins
antigen apply

# Returns whether the given command is executable or aliased.
_has() {
  return $( whence $1 >/dev/null )
}



# BASICS

# umask
umask 022

# editor/visual
export EDITOR=vim
export VISUAL=vim

# pager
export PAGER=less

# zsh will not beep
setopt no_beep

# make cd push the old directory onto the directory stack
setopt auto_pushd

# Report the status of background jobs immediately, rather than waiting until just before printing a prompt.
setopt notify

# Turn off terminal driver flow control (CTRL+S/CTRL+Q)
setopt noflowcontrol
stty -ixon -ixoff

# Do not kill background processes when closing the shell.
setopt nohup



# LOCALE

# ensure we have correct locale set (this is mostly for MacOS)
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8



# PATHS

export PATH=$HOME/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:$PATH

# fpath (for zsh-completions)
fpath=(~/.zsh/bundles/olivierverdier/zsh-git-prompt/src $fpath)


# COLORS

# colors
autoload -U colors
colors

# colored ls (one version for GNU, other for Mac OS X)
if whence dircolors > /dev/null; then
  eval "`dircolors -b`"
  alias ls='ls --color=auto'
else
  export CLICOLOR=1
fi

# make less always work with colored input
alias less='less -R'

# make watch always work with colored input
alias watch='watch --color'



# ALIASES

# ls
alias ll='ls -al'
alias l='ls -l'
alias sl=ls

# git
alias g='git'
alias gd='git d'
alias gg='git g'
alias gs='git s'
alias gl='git l'
alias wtf='git wtf'
alias rmorig='git status --short | grep "??" | grep "\.orig$" | cut -d " " -f 2 | xargs rm'

# grep
alias grep='grep --color=auto'

# uses git blame to calculate code ownership (source: http://stackoverflow.com/questions/4589731/git-blame-statistics)
function fame {
  git ls-tree -r -z --name-only HEAD | xargs -0 -n1 git blame --line-porcelain HEAD \
    | grep "^author " | sort | uniq -c | sort -nr
}

# cd
alias -- -='cd -'
alias ..='cd ..'
alias ...='cd ../..'

# rails / bundler
alias r='rails'
alias b='bundle'
alias bundler='bundle'
alias bi='b install'
alias bu='b update'
alias be='b exec'
alias bo='b open'

# Heroku
alias hcfge='heroku config --remote edge'
alias hcfgi='heroku config --remote integration'
alias hcfgp='heroku config --remote production'
alias hcfgq='heroku config --remote qa'
alias hcfgs='heroku config --remote staging'
alias hce='heroku run console --remote edge'
alias hci='heroku run console --remote integration'
alias hcp='heroku run console --remote production'
alias hcq='heroku run console --remote qa'
alias hcs='heroku run console --remote staging'
alias hdbe='heroku pg:psql --remote edge'
alias hdbi='heroku pg:psql --remote integration'
alias hdbp='heroku pg:psql --remote production'
alias hdbq='heroku pg:psql --remote qa'
alias hdbs='heroku pg:psql --remote staging'
alias hle='heroku logs -t --remote edge'
alias hli='heroku logs -t --remote integration'
alias hlp='heroku logs -t --remote production'
alias hlq='heroku logs -t --remote qa'
alias hls='heroku logs -t --remote staging'
alias hpe='heroku ps --remote edge'
alias hpi='heroku ps --remote integration'
alias hpp='heroku ps --remote production'
alias hpq='heroku ps --remote qa'
alias hps='heroku ps --remote staging'

# subversion
alias svndiff='svn diff --diff-cmd=colordiff'
alias svnaddall='svn status | awk "/\\?/ {print \$2}" | xargs svn add'

# fswatch + rspec
alias fswatch-rspec='fswatch -0 -e ".*" -i "\\.rb$" . | xargs -0 -n 1 -I {} rspec --format documentation'

# htop
if [[ -x `which htop` ]]; then alias top="sudo htop"; fi

# vim
alias v=vim

# ack
if [[ -x `which ack-grep` ]]; then alias ack='ack-grep'; fi

# bat
if [[ -x `which bat` ]]; then alias cat='bat'; fi

# diff
if [[ -x `which colordiff` ]]; then alias diff='colordiff -u'; fi

# find
function ff {
  SEARCH_PATH=$2

  if [[ -z $SEARCH_PATH ]]; then
    SEARCH_PATH=.
  fi

  find $SEARCH_PATH | grep -i "$1"
}

# ping
if [[ -x `which prettyping` ]]; then alias ping='prettyping --nolegend'; fi

# Rails application update
alias pull='git pull; bundle; rake db:migrate; git checkout -- db/schema.rb; touch tmp/restart.txt'

# misc
alias _='sudo'
alias mc='LANG=en_EN.UTF-8 mc -cu'
alias tmux='TERM=screen-256color tmux'



# GLOBAL ALIASES

alias -g C='| wc -l'
alias -g G='| grep'
alias -g L='| less'
alias -g M='| more'
alias -g S='&> /dev/null'



# HISTORY

# zsh history
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=${HISTSIZE}

# make some commands not show up in history
export HISTIGNORE="ls:ll:cd:cd -:pwd:exit:date:* --help"

# multiple zsh sessions will append to the same history file (incrementally, after each command is executed)
setopt inc_append_history

# purge duplicates first
setopt hist_expire_dups_first

# if a new command line being added to the history list duplicates an older one, the older command is removed from the list
setopt hist_ignore_all_dups

# prefix a command with a space to keep it out of the history
setopt hist_ignore_space

# reduce unnecessary blanks from commands being written to history
setopt hist_reduce_blanks

# import new commands from history (mostly)
setopt share_history



# COMMAND COMPLETION

# treat `#', `~' and `^' characters as part of patterns for filename generation
setopt extended_glob

# case insensitive matching when performing filename expansion
setopt no_case_glob

# if command not found, but directory found, cd into this directory
setopt auto_cd

# turn off automatic matching of ~/ directories (speeds things up)
setopt no_cdable_vars

# perform implicit tees or cats when multiple redirections are attempted
setopt multios

# do not send the HUP signal to backround jobs on shell exit
setopt no_hup

# parameter expansion, command substitution and arithmetic expansion are performed in prompts
setopt prompt_subst

# speed-up the git completion for filenames
__git_files () {
  _wanted files expl 'local files' _files
}

# fuzzy matching for typos
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# cd will never select parent
zstyle ':completion:*:cd:*' ignore-parents parent pwd

# tab completion for PIDs
zstyle ':completion:*:*:*:*:processes' command "ps -u `whoami` -o pid,user,comm,command -w -w"
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always

# zsh completions chache
CACHEDIR="$HOME/.zsh/cache"

# create $CACHEDIR if it does not exist
if [ ! -d $CACHEDIR ]; then
  mkdir -p $CACHEDIR
fi

# cache completions
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path $CACHEDIR

# load completions
autoload -U compinit
compinit -d $CACHEDIR/zcompdump

# If a pattern for filename generation has no matches, print an error,
# instead of leaving it unchanged in the argument list. This also
# applies to file expansion of an initial ~ or =.
unsetopt nomatch

# heroku autocomplete setup
HEROKU_AC_ZSH_SETUP_PATH=~/Library/Caches/heroku/autocomplete/zsh_setup && test -f $HEROKU_AC_ZSH_SETUP_PATH && source $HEROKU_AC_ZSH_SETUP_PATH



# KEY BINDINGS

# 200ms wait (20 == 200ms) for a longer bound string (usually ESC + something; wait 200ms for 'something' and if it doesn't come, just execute normal <Esc>)
export KEYTIMEOUT=20

# VIM style keybindings by default (unnecessary)
bindkey -v

# make backward-word and forward-word move to each word separated by a '/'
export WORDCHARS=''

# edit command line (insert mode) (vv for command mode edit)
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line

alias ←="pushd -q +1"
alias →="pushd -q -0"

case "$TERM" in
  *xterm*|screen-256color)
    # alt + arrows
    bindkey '[D' backward-word
    bindkey '[C' forward-word
    bindkey '^[[1;3D' backward-word
    bindkey '^[[1;3C' forward-word
    bindkey "\e\e[D" backward-word
    bindkey "\e\e[C" forward-word

    # VI MODE KEYBINDINGS (ins mode)
    bindkey -M viins '^a' beginning-of-line
    bindkey -M viins '^e' end-of-line
    bindkey -M viins '^k' kill-line
    bindkey -M viins '^o' history-beginning-search-backward
    bindkey -M viins '^p' history-beginning-search-backward
    bindkey -M viins '^n' history-beginning-search-forward
    bindkey -M viins '^y' yank
    bindkey -M viins '^w' backward-kill-word
    bindkey -M viins '^u' backward-kill-line
    bindkey -M viins '^h' backward-delete-char
    bindkey -M viins '^?' backward-delete-char
    bindkey -M viins '^_' undo

    # VI MODE KEYBINDINGS (cmd mode)
    bindkey -M vicmd '^a' beginning-of-line
    bindkey -M vicmd '^e' end-of-line
    bindkey -M vicmd '^k' kill-line
    bindkey -M vicmd '^o' history-beginning-search-backward
    bindkey -M vicmd '^p' history-beginning-search-backward
    bindkey -M vicmd '^n' history-beginning-search-forward
    bindkey -M vicmd '^y' yank
    bindkey -M vicmd '^w' backward-kill-word
    bindkey -M vicmd '^u' backward-kill-line
    bindkey -M vicmd '/'  vi-history-search-forward
    bindkey -M vicmd '?'  vi-history-search-backward
    bindkey -M vicmd '^_' undo
    bindkey -M vicmd 'H'  beginning-of-line
    bindkey -M vicmd 'L'  end-of-line
  ;;
esac

# Fancy ctrl+z
function fancy-ctrl-z () {
  if [[ $#BUFFER -eq 0 ]]; then
    fg
    zle redisplay
  else
    zle push-input
    zle clear-screen
  fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z



# PROMPT

# [zsh-git-prompt] location
export __GIT_PROMPT_DIR=~/.zsh/bundles/olivierverdier/zsh-git-prompt

# use Haskell's version of zsh-git-prompt (if available)
if [[ -f $__GIT_PROMPT_DIR/src/.bin/gitstatus ]]; then GIT_PROMPT_EXECUTABLE="haskell"; fi

# result of last command displays either a happy or sad face as the prompt
smiley="%(?,%{$fg[green]%}☺%{$reset_color%},%{$fg[red]%}☹%{$reset_color%})"

# vim mode indicator in prompt
vim_insert_mode="%{$fg[cyan]%}[INS]%{$reset_color%}"
vim_replace_mode="%{$fg[red]%}[REP]%{$reset_color%}"
vim_visual_mode="%{$fg[blue]%}[VIS]%{$reset_color%}"
vim_normal_mode="%{$fg[green]%}[CMD]%{$reset_color%}"

function zvm_after_select_vi_mode() {
  case $ZVM_MODE in
    $ZVM_MODE_NORMAL)
      vim_mode=$vim_normal_mode
    ;;
    $ZVM_MODE_INSERT)
      vim_mode=$vim_insert_mode
    ;;
    $ZVM_MODE_VISUAL)
      vim_mode=$vim_visual_mode
    ;;
    $ZVM_MODE_VISUAL_LINE)
      vim_mode=$vim_visual_mode
    ;;
    $ZVM_MODE_REPLACE)
      vim_mode=$vim_replace_mode
    ;;
  esac
}

# background jobs indicator in prompt (https://gist.github.com/remy/6079223)
function background_jobs() {
  [[ $(jobs -l | wc -l) -gt 0 ]] && echo "⚙"
}

# online indicator in prompt (https://gist.github.com/remy/6079223)
ONLINE="%{%F{green}%}◉%{$reset_color%}"
OFFLINE="%{%F{red}%}⦿%{$reset_color%}"

function prompt_online() {
  if [[ -f ~/.offline ]]; then
    echo $OFFLINE
  else
    echo $ONLINE
  fi
}

function ssh_prompt_color() {
  if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
    echo '%{%F{blue}%}'
  else
    echo '%{%F{green}%}'
  fi
}


vim_mode="N/A"

PROMPT='
%(!.%{$fg[red]%}.%{$fg[green]%})%n$(ssh_prompt_color)@%m%{$reset_color%}: %{$fg[blue]%}%~%{$reset_color%} $(git_super_status) %{$fg[white]%}$(ruby --disable=gems,did_you_mean -e "print \"ruby-#{RUBY_VERSION}\"")%{$reset_color%} ${vim_mode} %{$fg[white]%}$(background_jobs)
${smiley} %{$reset_color%}'

RPROMPT='$(prompt_online) %{$fg[white]%}%T%{$reset_color%}'



# SPELLING CORRECTIONS

# limit correction only to commands
setopt correct

# When offering typo corrections, do not propose anything which starts with an underscore (such as many of Zsh's shell functions)
CORRECT_IGNORE='_*'

# general exceptions
for i in {'cp','git','gist','man','mv','mysql','mkdir'}; do
  alias $i="nocorrect $i"
done

# ruby/rails exceptions
for i in {'bundle','cap','capify','cucumber','foreman','gem','guard','heroku','puma','pry','rake','rspec','ruby','spec','spork','thin'}; do
  alias $i="nocorrect $i"
done



# CHRUBY / RVM (load either one conditionally)
if [ -d /usr/local/opt/chruby/share/chruby ]; then
  # CHRUBY (load conditionally if exists)
  source /usr/local/opt/chruby/share/chruby/chruby.sh
  source /usr/local/opt/chruby/share/chruby/auto.sh
elif [ -x "$HOME/.rvm/scripts/rvm" ]; then
  # RVM (load conditionally if exists)
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
    if [ -d /usr/local/opt/chruby/share/chruby ]; then
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
if [ -d /usr/local/opt/chruby/share/chruby ]; then
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

# set GitHub credentials
[[ -e ~/.github_credentials ]] && source ~/.github_credentials

# alias hub to git (https://github.com/defunkt/hub)
function git() { hub "$@" }

# SMART URLS
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

# Don’t clear the screen after quitting a manual page
export MANPAGER="less -X"

# display CPU usage stats for commands taking more than 10 seconds
REPORTTIME=10

# Rails production environment by default for all non-development machines
[[ $(hostname -s) != 'genesis' ]] && [[ $(hostname -s) != 'mini' ]] && [[ $(hostname -s) != 'legacy' ]] && export RAILS_ENV="production"

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# set DISPLAY if Xvfb is running (expects it to run on :0)
xdpyinfo -display :0 &> /dev/null && export DISPLAY=:0

# bat's theme
export BAT_THEME="OneHalfLight"

# Objective C security issue with forking
# https://blog.phusion.nl/2017/10/13/why-ruby-app-servers-break-on-macos-high-sierra-and-what-can-be-done-about-it/
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

# Disable ads from npm packages installs
export ADBLOCK=true

# Load iTerm2 shell integration (if available)
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Load FZF shell integration (if available)
if _has fzf && _has ag; then
  export FZF_DEFAULT_COMMAND='ag --nocolor --ignore-dir=public/pictures --ignore-dir=tmp --ignore-dir=vendor/plugins -g ""'
fi

# [zsh-vi-mode]

# readkey engine
ZVM_READKEY_ENGINE=$ZVM_READKEY_ENGINE_NEX

# key timeout [s]
ZVM_KEYTIMEOUT=0.2

ZVM_VI_HIGHLIGHT_BACKGROUND=#dff2f9

# Always starting with insert mode for each command line
ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT


# will auto execute
function zvm_after_init() {
  # Load fzf key bindings
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

  # those keybindings need to be defined here, otherwise they don't work
  zvm_bindkey viins '^O' history-beginning-search-backward
  zvm_bindkey viins '^P' history-beginning-search-backward
  zvm_bindkey viins '^N' history-beginning-search-forward
}

# default keybindings override
function zvm_after_lazy_keybindings() {
  # alt + arrows
  zvm_bindkey vicmd "\e\e[D" backward-word
  zvm_bindkey vicmd "\e\e[C" forward-word

  zvm_bindkey vicmd '^a' beginning-of-line
  zvm_bindkey vicmd '^e' end-of-line
}
