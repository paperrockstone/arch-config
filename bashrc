#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export EDITOR=vim

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias vim='nvim'

[ ! -e ~/.dircolors ] && eval $(dircolors -p > ~/.dircolors)
[ -e /bin/dircolors ] && eval $(dircolors -b ~/.dircolors)

function set_bash_prompt () {
	# Color codes for easy prompt building
	COLOR_DIVIDER="\[\e[30;1m\]"
	COLOR_CMDCOUNT="\[\e[34;1m\]"
	COLOR_USERNAME="\[\e[34;1m\]"
	COLOR_USERHOSTAT="\[\e[34;1m\]"
	COLOR_HOSTNAME="\[\e[34;1m\]"
	COLOR_GITBRANCH="\[\e[33;1m\]"
	COLOR_VENV="\[\e[33;1m\]"
	COLOR_GREEN="\[\e[32;1m\]"
	COLOR_PATH_OK="\[\e[32;1m\]"
	COLOR_PATH_ERR="\[\e[31;1m\]"
	COLOR_NONE="\[\e[0m\]"
	# Change the path color based on return value.
	if test $? -eq 0 ; then
		PATH_COLOR=${COLOR_PATH_OK}
	else
		PATH_COLOR=${COLOR_PATH_ERR}
	fi
	# Set the PS1 to be "[workingdirectory:commandcount"
	PS1="${COLOR_DIVIDER}${PATH_COLOR} \w${COLOR_DIVIDER}"
	# Add git branch portion of the prompt, this adds ":branchname"
	if ! git_loc="$(type -p "$git_command_name")" || [ -z "$git_loc" ]; then
		# Git is installed
		if [ -d .git ] || git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
			# Inside of a git repository
			GIT_BRANCH=$(git symbolic-ref --short HEAD)
			PS1="${PS1}:${COLOR_GITBRANCH}${GIT_BRANCH}${COLOR_DIVIDER}"
		fi
	fi
	# Add Python VirtualEnv portion of the prompt, this adds ":venvname"
	if ! test -z "$VIRTUAL_ENV" ; then
		PS1="${PS1}:${COLOR_VENV}`basename \"$VIRTUAL_ENV\"`${COLOR_DIVIDER}"
	fi
	# Close out the prompt, this adds "]\n[username@hostname] "
	PS1="${PS1} ${COLOR_DIVIDER}${COLOR_USERNAME}\u${COLOR_USERHOSTAT}   ${COLOR_DIVIDER}${COLOR_NONE} "
}

# Tell Bash to run the above function for every prompt
export PROMPT_COMMAND=set_bash_prompt

export TRASH=~/.local/share/Trash/files
# 
rm() {
    for f in $*;
    do
        dir=$TRASH/$(date '+%Y%m%d-%H%M')
        target=$dir/${f##*/}
        mkdir -p $dir
        [ -f $f ] && mv $f $target;
        [ -d $f ] && mv $f $target;
    done
}
