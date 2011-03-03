# ~/.bash_profile

# set INPUTRC (so that .inputrc is respected)
export INPUTRC=~/.inputrc

# add various directories to PATH
PATH=./:~/bin:/bin:/sbin:/usr/bin:/usr/sbin:"${PATH}"
export PATH

# umask
umask 022

# aliases
alias ll='ls -al'
alias l='ls -l'
alias mc='mc -cu'
alias ..='cd ..'
alias ...='cd ../..'
alias ack='ack-grep'
alias diff='colordiff -u'

alias lc='cl'
function cl() { cd "$@" && l; }

# rails
alias r='rails'
alias b='bundle'
alias bi='b install'
alias bu='b update'
alias be='b exec'

function sc {
  if [ -e script/rails ]; then
    bundle exec rails console
  else
    script/console --debugger
  fi
}

function ss {
  if [ -e script/rails ]; then
    rails server
  else
    script/server --debugger
  fi
}

function sg {
  if [ -e script/rails ]; then
    rails generate
  else
    script/generate
  fi
}

# enable colors
eval "`dircolors -b`"
alias ls='ls --color=auto'

# make less always work with colored input
alias less='less -R'

# subversion
alias svndiff='svn diff --diff-cmd=colordiff'
alias svnaddall='svn status | awk "/\\?/ {print \$2}" | xargs svn add'

# auto-correct directory spelling errors
shopt -s cdspell

# extended pattern matching features enabled
shopt -s extglob

# make bash append rather than overwrite the history on disk
shopt -s histappend

# perform hostname completion when a word containing a @ is being completed
shopt -s hostcomplete

# allow a word beginning with # to cause that word and all remaining characters on that line to be ignored
shopt -s interactive_comments

# bash will not attempt to search the PATH for possible completions when completion is attempted on an empty line
shopt -s no_empty_cmd_completion

# case insensitive matching when performing pathname expansion
shopt -s nocaseglob

# whenever displaying the prompt, write the previous line to disk
# so new shell gets the history lines from all previous shells
export PROMPT_COMMAND='history -a'

# don't put duplicate lines in the history
export HISTCONTROL=ignoredups

# increase history limit (100KB or 5K entries)
export HISTFILESIZE=100000
export HISTSIZE=5000

# set defaul bash editor (for crontab et al.)
EDITOR=/usr/bin/vim
VISUAL=/usr/bin/vim
export EDITOR
export VISUAL

# turn off terminal driver flow control
stty -ixon -ixoff

# check the window size after each command and, if necessary, update the values of LINES and COLUMNS
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# source bash_completion
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi


# PS1 (shell prompt)

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

function parse_git_dirty {
  git diff --quiet HEAD &>/dev/null
  [[ $? == 1 ]] && echo "⚡"
}

function parse_git_branch {
  local branch=$(__git_ps1 "%s")
  [[ $branch ]] && echo "[$branch$(parse_git_dirty)]"
}

PS1="${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\$(parse_git_branch)\[\033[00m\]\$ "
