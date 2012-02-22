# If not running interactively, don't do anything
if [ -z "$PS1" ]; then
  return;
fi

export PATH="/usr/local/bin:/usr/local/sbin:${PATH}"

# Prompt goodness
GRAY='\[\033[01;30m\]'; ORANGE='\[\033[01;31m\]'; BLUE='\[\033[01;34m\]'; GREEN='\[\033[01;32m\]'; YELLOW='\[\033[01;33m\]';WHITE='\[\033[00m\]' 
export PS1="${GRAY}\u@\h ${BLUE}\w ${GREEN}\d ${YELLOW}\t ${WHITE}\n $ "

# history
HISTTIMEFORMAT='%r  '
HISTIGNORE="both"

if [ -d ~/.bash_aliases ]; then
  for f in $(find ~/.bash_aliases -type f); do
    source $f
  done
fi

