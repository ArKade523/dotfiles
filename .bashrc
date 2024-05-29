# Bash prompt
export PS1='$(git branch &>/dev/null; if [ $? -eq 0 ]; then \
echo "\[\e[1;36m\]\u@${HOSTNAME:0:10}\[\e[0m\]: \W [\[\e[34m\]$(git branch | grep ^* | sed s/\*\ //)\[\e[0m\]\
$(echo `git status` | grep "nothing to commit" > /dev/null 2>&1; if [ "$?" -ne "0" ]; then \
echo "\[\e[1;31m\]*\[\e[0m\]"; fi)] \$ "; else \
echo "\[\e[1;36m\]\u@${HOSTNAME:0:10}\[\e[0m\]: \W \$ "; fi )'


# Aliases
alias la='ls -a'
alias ll='ls -la'
alias lah='ls -lah'


# -- Custom functionality --
# Function to swap adjacent characters in a command and retry
retry_command() {
    local cmd="$1"
    local length=${#cmd}
    local modified_cmds=()

    # Generate all possible commands by swapping adjacent characters
    for ((i = 0; i < length - 1; i++)); do
        if [[ ${cmd:i:1} =~ [a-zA-Z] && ${cmd:i+1:1} =~ [a-zA-Z] ]]; then
            local swapped_cmd="${cmd:0:i}${cmd:i+1:1}${cmd:i:1}${cmd:i+2}"
            modified_cmds+=("$swapped_cmd")
        fi
    done

    # Check each modified command
    for modified_cmd in "${modified_cmds[@]}"; do
        # Extract the first word (command) to check if it exists in PATH
        local executable=$(echo $modified_cmd | awk '{print $1}')
        if command -v $executable &> /dev/null; then
            echo "Command failed: $cmd"
            echo "Found a potential match: $modified_cmd"
            read -p "Do you want to execute this command? [y/N] " -n 1 confirm
		    echo # move to a new line
   	        if [[ $confirm == [yY] || -z $confirm ]]; then
            	eval "$modified_cmd"
            	return
			else
				break
        	fi
        fi
    done

    echo "Command failed: $cmd. No suitable adjacent swap found or confirmed."
}

# Trap ERR signal to catch failed commands
trap 'last_command=$this_command; this_command=$BASH_COMMAND' DEBUG
trap '[[ $? -ne 0 ]] && retry_command "$last_command"' ERR

