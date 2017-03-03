# --------------------------------------------
__git_ps1 ()
{
    local pcmode=no;
    local detached=no;
    local ps1pc_start='\u@\h:\w ';
    local ps1pc_end='\$ ';
    local printf_format=' (%s)';
    case "$#" in
        2 | 3)
            pcmode=yes;
            ps1pc_start="$1";
            ps1pc_end="$2";
            printf_format="${3:-$printf_format}"
        ;;
        0 | 1)
            printf_format="${1:-$printf_format}"
        ;;
        *)
            return
        ;;
    esac;
    local ps1_expanded=yes;
    [ -z "$ZSH_VERSION" ] || [[ -o PROMPT_SUBST ]] || ps1_expanded=no;
    [ -z "$BASH_VERSION" ] || shopt -q promptvars || ps1_expanded=no;
    local repo_info rev_parse_exit_code;
    repo_info="$(git rev-parse --git-dir --is-inside-git-dir 		--is-bare-repository --is-inside-work-tree 		--short HEAD 2>/dev/null)";
    rev_parse_exit_code="$?";
    if [ -z "$repo_info" ]; then
        if [ $pcmode = yes ]; then
            PS1="$ps1pc_start$ps1pc_end";
        fi;
        return;
    fi;
    local short_sha;
    if [ "$rev_parse_exit_code" = "0" ]; then
        short_sha="${repo_info##*
}";
        repo_info="${repo_info%
*}";
    fi;
    local inside_worktree="${repo_info##*
}";
    repo_info="${repo_info%
*}";
    local bare_repo="${repo_info##*
}";
    repo_info="${repo_info%
*}";
    local inside_gitdir="${repo_info##*
}";
    local g="${repo_info%
*}";
    local r="";
    local b="";
    local step="";
    local total="";
    if [ -d "$g/rebase-merge" ]; then
        __git_eread "$g/rebase-merge/head-name" b;
        __git_eread "$g/rebase-merge/msgnum" step;
        __git_eread "$g/rebase-merge/end" total;
        if [ -f "$g/rebase-merge/interactive" ]; then
            r="|REBASE-i";
        else
            r="|REBASE-m";
        fi;
    else
        if [ -d "$g/rebase-apply" ]; then
            __git_eread "$g/rebase-apply/next" step;
            __git_eread "$g/rebase-apply/last" total;
            if [ -f "$g/rebase-apply/rebasing" ]; then
                __git_eread "$g/rebase-apply/head-name" b;
                r="|REBASE";
            else
                if [ -f "$g/rebase-apply/applying" ]; then
                    r="|AM";
                else
                    r="|AM/REBASE";
                fi;
            fi;
        else
            if [ -f "$g/MERGE_HEAD" ]; then
                r="|MERGING";
            else
                if [ -f "$g/CHERRY_PICK_HEAD" ]; then
                    r="|CHERRY-PICKING";
                else
                    if [ -f "$g/REVERT_HEAD" ]; then
                        r="|REVERTING";
                    else
                        if [ -f "$g/BISECT_LOG" ]; then
                            r="|BISECTING";
                        fi;
                    fi;
                fi;
            fi;
        fi;
        if [ -n "$b" ]; then
            :;
        else
            if [ -h "$g/HEAD" ]; then
                b="$(git symbolic-ref HEAD 2>/dev/null)";
            else
                local head="";
                if ! __git_eread "$g/HEAD" head; then
                    if [ $pcmode = yes ]; then
                        PS1="$ps1pc_start$ps1pc_end";
                    fi;
                    return;
                fi;
                b="${head#ref: }";
                if [ "$head" = "$b" ]; then
                    detached=yes;
                    b="$(
				case "${GIT_PS1_DESCRIBE_STYLE-}" in
				(contains)
					git describe --contains HEAD ;;
				(branch)
					git describe --contains --all HEAD ;;
				(describe)
					git describe HEAD ;;
				(* | default)
					git describe --tags --exact-match HEAD ;;
				esac 2>/dev/null)" || b="$short_sha...";
                    b="($b)";
                fi;
            fi;
        fi;
    fi;
    if [ -n "$step" ] && [ -n "$total" ]; then
        r="$r $step/$total";
    fi;
    local w="";
    local i="";
    local s="";
    local u="";
    local c="";
    local p="";
    if [ "true" = "$inside_gitdir" ]; then
        if [ "true" = "$bare_repo" ]; then
            c="BARE:";
        else
            b="GIT_DIR!";
        fi;
    else
        if [ "true" = "$inside_worktree" ]; then
            if [ -n "${GIT_PS1_SHOWDIRTYSTATE-}" ] && [ "$(git config --bool bash.showDirtyState)" != "false" ]; then
                git diff --no-ext-diff --quiet --exit-code || w="*";
                if [ -n "$short_sha" ]; then
                    git diff-index --cached --quiet HEAD -- || i="+";
                else
                    i="#";
                fi;
            fi;
            if [ -n "${GIT_PS1_SHOWSTASHSTATE-}" ] && [ -r "$g/refs/stash" ]; then
                s="$";
            fi;
            if [ -n "${GIT_PS1_SHOWUNTRACKEDFILES-}" ] && [ "$(git config --bool bash.showUntrackedFiles)" != "false" ] && git ls-files --others --exclude-standard --error-unmatch -- '*' > /dev/null 2> /dev/null; then
                u="%${ZSH_VERSION+%}";
            fi;
            if [ -n "${GIT_PS1_SHOWUPSTREAM-}" ]; then
                __git_ps1_show_upstream;
            fi;
        fi;
    fi;
    local z="${GIT_PS1_STATESEPARATOR-" "}";
    if [ $pcmode = yes ] && [ -n "${GIT_PS1_SHOWCOLORHINTS-}" ]; then
        __git_ps1_colorize_gitstring;
    fi;
    b=${b##refs/heads/};
    if [ $pcmode = yes ] && [ $ps1_expanded = yes ]; then
        __git_ps1_branch_name=$b;
        b="\${__git_ps1_branch_name}";
    fi;
    local f="$w$i$s$u";
    local gitstring="$c$b${f:+$z$f}$r$p";
    if [ $pcmode = yes ]; then
        if [ "${__git_printf_supports_v-}" != yes ]; then
            gitstring=$(printf -- "$printf_format" "$gitstring");
        else
            printf -v gitstring -- "$printf_format" "$gitstring";
        fi;
        PS1="$ps1pc_start$gitstring$ps1pc_end";
    else
        printf -- "$printf_format" "$gitstring";
    fi
}

export HISTIGNORE="history;js;date;w;man *"
export HISTCONTROL=ignoreboth
export HISTSIZE=100000
export GREP_OPTIONS='--color=auto'

# adeshmukh:10/21/2015: Introduced new prompt
# export PS1='[\h \[\033[0;36m\]\w\[\033[0m\]$(__git_ps1 " \[\033[1;32m\](%s)\[\033[0m\]")]\n\$ '
export PS1='\[\033[6;37;43m\]$(__git_ps1 " %s ")\[\033[9;31;41m\] \t \[\033[0;44m\] \h \[\033[8;34;47m\] \w \[\033[0m\]\n\$ '
export PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'

alias tabulate='column -t -s "#"'
function sbp() {
  source ~/.bashrc.d/${1}.bash 2> /dev/null
  source ~/.bashrc.d/${1}.bash.manual 2> /dev/null
}


# --------------------------------------------
function _sbp_completion() {
  COMPREPLY=();
  cur="${COMP_WORDS[COMP_CWORD]}";
  comp_sbp=$(ls -1 ~/.bashrc.d/*.bash{,.manual} | xargs -n1 basename | perl -pe 's:[.]bash([.]manual)?::')
  COMPREPLY=($(compgen -W "${comp_sbp}" -- $cur));
  return 0
}

complete -F _sbp_completion sbp


