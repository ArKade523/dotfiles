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
    local modified_cmd

    # Generate possible commands by swapping adjacent characters
    for ((i = 0; i < length - 1; i++)); do
        if [[ ${cmd:i:1} =~ [a-zA-Z] && ${cmd:i+1:1} =~ [a-zA-Z] ]]; then
            modified_cmd="${cmd:0:i}${cmd:i+1:1}${cmd:i:1}${cmd:i+2}"
            # Extract the first word (command) to check if it exists in PATH
            local executable=$(echo $modified_cmd | awk '{print $1}')
            if command -v $executable &> /dev/null; then
                echo "Command failed: $cmd"
                echo "Found a potential match: $modified_cmd"
                read -p "Do you want to execute this command? [Y/n] " -n 1 confirm
                echo  # move to a new line
                if [[ $confirm == [yY] || -z $confirm ]]; then
                    eval "$modified_cmd"
                    return
                else
                    break
                fi
            fi
        fi
    done

    echo "Command failed: $cmd. No suitable adjacent swap found or confirmed."
}

# Trap ERR signal to catch failed commands
trap 'last_command=$this_command; this_command=$BASH_COMMAND' DEBUG
trap '[[ $? -ne 0 ]] && retry_command "$last_command"' ERR

# Check if this file is different from the one in ~/.dotfiles. Run ~/.dotfiles/setup.sh if so
# Path to your dotfiles directory
DOTFILES_DIR="$HOME/.dotfiles"

# Check if .bashrc in the home directory is different from the one in .dotfiles
if ! cmp -s "$DOTFILES_DIR/.bashrc" "$HOME/.bashrc"; then
    echo ".bashrc files differ. Running setup script."
    bash "$DOTFILES_DIR/setup.sh"
	if -f "$HOME/.bashrc"; then
		source "$HOME/.bashrc"
	fi
fi

# Install bash completion
if [ ! -d "$HOME/bash_completion.d" ]; then
	mkdir "$HOME/bash_completion.d"
fi

if [ ! -f "$HOME/bash_completion.d/git" ]; then 
	curl -o ~/bash_completion.d/git https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
	source "$HOME/bash_completion.d/git"
fi

	
