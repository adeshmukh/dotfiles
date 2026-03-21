# shellrc.d/bash.sh — bash-only configuration
[ -n "$BASH_VERSION" ] || return

export HISTIGNORE="history;js;date;w;man *"
export HISTCONTROL=ignoreboth
export HISTSIZE=100000
export GREP_OPTIONS='--color=auto'

export PS1='\[\033[6;37;43m\]$(__git_ps1 " %s ")\[\033[9;31;41m\] \t \[\033[0;44m\] \h \[\033[8;34;47m\] \w \[\033[0m\]\n\$ '
export PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'

# sbp: source a shellrc.d snippet by name (with tab completion)
function sbp() {
  source ~/.shellrc.d/${1}.sh 2>/dev/null
  source ~/.shellrc.d/${1}.sh.manual 2>/dev/null
}

function _sbp_completion() {
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  comp_sbp=$(ls -1 ~/.shellrc.d/*.sh{,.manual} 2>/dev/null | xargs -n1 basename | perl -pe 's:[.]sh([.]manual)?::')
  COMPREPLY=($(compgen -W "${comp_sbp}" -- "$cur"))
  return 0
}

complete -F _sbp_completion sbp
