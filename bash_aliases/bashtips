export BASHTIPS_FILE=$(cd $(dirname $_); pwd)/bashtips
function bashtips() {
    if [ $# -eq 0 ]; then
        echo "Usage: bashtips <tipname>"
        echo ""
        echo "where <tipname> is one of: "
        egrep "^function bashtips_[^ ]* {" $BASHTIPS_FILE \
        | sed -e "s:function bashtips_\(.*\)\(() { #\):    \1 \:  :g"
    else
        bashtips_$@
    fi
}


function bashtips_bashvars() { # Info on \$BASH* vars
    echo "
     Bash Meta
    ---------
    + \$BASH: path to bash binary
    + \$BASH_ENV: startup file to be invoked when a script is invoked
    + \$BASH_SUBSHELL: A variable indicating the subshell level. This is a new addition to Bash, version 3
    + \$BASHPID: process id of current instance of bash. Subshells get their own value which is not the same as for parent process
    + \$BASH_VERSINFO[n]: 6 element array
    + \$BASH_VERSION: Bash version                                

    See also: debgvars
    "
}

function bashtips_debgvars() { # Special vars for debugging in scripts
    echo "
    Special vars for Debug
    ----------------------
    + \$BASH_ARG: Number of command-line arguments passed to script, similar to $#.
    + \$BASH_ARGV: Final command-line parameter passed to script, equivalent ${!#}.
    + \$BASH_COMMAND: Command currently executing.
    + \$BASH_EXECUTION_STRING: The option string following the -c option to Bash.
    + \$BASH_LINENO: In a function, indicates the line number of the function call.
    + \$BASH_REMATCH: Array variable associated with =~ conditional regex matching.
    + \$BASH_SOURCE: This is the name of the script, usually the same as $0.
    + \$BASH_SUBSHELL: A variable indicating the subshell level. This is a new addition to Bash, version 3

    See also: bashvars
    "
}

function bashtips_pathvars() { # Vars that operate on or modify interpretation of various paths
    echo "
    Paths
    -----
    + \$CDPATH:                                
    + \$DIRSTACK:                                
    + \$HOME:                                
    + \$PWD:
    + \$OLDPWD:
    + \$PATH:
    "
}

function bashtips_procvars() { # Process vars
    echo "
    Process, Users, Permissions
    ---------------------------
    + \$EUID: Effective user id
    + \$GROUPS:                                
    + \$PIPESTATUS:
    + \$PPID:
    + \$UID:
    "
}

function bashtips_machvars() { # Machine vars
    echo "
    Machine Info
    ------------
    + \$HOSTNAME:                                
    + \$HOSTTYPE:                                
    + \$MACHTYPE:
    + \$OSTYPE:
    "
}

function bashtips_ctxtvars() { # Context vars
    echo "
    Current Context
    ---------------
    + \$FUNCNAME:
    + \$LINENO:
    + \$SECONDS:
    "
}

function bashtips_shelvars() { # Prompt vars
    echo "
    Shell Prompt
    ------------
    + \$PROMPT_COMMAND:
    + \$PS1:
    + \$PS2:
    + \$PS3:
    + \$PS4:
    + \$TMOUT:
    "
}

function bashtips_posivars() { # Positional parameters
    echo "
    Positional Params
    -----------------
    + \$0:
    + \$#:
    + \$*:
    + \$@:
    "

}

function bashtips_specvars() { # Special vars
    echo "
    Special Params
    --------------
    + \$-: Flags passed to script
    + \$!: PID of last bg job
    + \$_: Final argument of prev command (script name when executed as first command in the script with no #!)
    + \$?: Exit status
    + \$\$: Process id (See also \$BASHPID)
    "
}

function bashtips_miscvars() { # Miscellaneous vars
    echo "
    Miscellaneous
    -------------
    + \$REPLY:
    + \$SHELLOPTS: (readonly)
    + \$SHLVL:
    + \$EDITOR:
    + \$GLOBIGNORE:                                
    + \$IFS:
    + \$IGNOREEOF:
    + \$LC_COLLATE:
    + \$LC_CTYPE:
    "
}
 
function bashtips_allvars() { # Info on all standard vars
    bashtips_bashvars
    bashtips_debgvars
    bashtips_pathvars
    bashtips_procvars
    bashtips_machvars
    bashtips_ctxtvars
    bashtips_shelvars
    bashtips_posivars
    bashtips_specvars
}

function bashtips_signals() { # OS signals
     egrep "^#define.SIG[A-Z]" /usr/include/sys/signal.h | egrep -o "SIG.*$" | grep -v SIGEV_ | grep -v SIGSTKSZ
 }
