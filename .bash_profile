# ~/.bash_profile: executed by bash(1) for login shells.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# execute .bashrc
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# add ~/bin to PATH if exists
if [ -d ~/bin ] ; then
    PATH=~/bin:"${PATH}"
fi

# add various directories to PATH
PATH=./:/bin:/sbin:/usr/bin:/usr/sbin:"${PATH}"
export PATH

# umask
umask 022


# Aliases
alias ls='ls -F --color=auto'
alias irb='/usr/bin/irb1.8'
alias ll='ls -al'
alias l='ls -l'
alias su='su -'
alias trf='~/bin/trace-your-referrers'
alias mc='mc -cu'

alias lc="cl"
function cl() { cd "$@" && l; }

alias diff='colordiff -u'

# Subversion
alias svndiff='svn diff --diff-cmd=colordiff'
alias svnaddall='svn status | awk "/\\?/ {print \$2}" | xargs svn add'


# Make Bash append rather than overwrite the history on disk: 
shopt -s histappend

# Whenever displaying the prompt, write the previous line to disk
# so new shell gets the history lines from all previous shells
export PROMPT_COMMAND='history -a'

# don't put duplicate lines in the history
export HISTCONTROL=ignoredups

# increase history limit (1MB or 10K entries)
export HISTFILESIZE=1000000
export HISTSIZE=10000

# Do not bell on TAB completion
set bell-style none


# Set crontab editor
EDITOR=/usr/bin/nano
VISUAL=/usr/bin/nano
export EDITOR
export VISUAL
