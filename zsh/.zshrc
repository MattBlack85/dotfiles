export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="agnoster"
CASE_SENSITIVE="true"

export UPDATE_ZSH_DAYS=7
export DEFAULT_USER="matt"
prompt_context(){}

plugins=(git dnf python)

source $ZSH/oh-my-zsh.sh

alias activate_venv='. venv/bin/activate'
alias sudo='sudo -E'
alias glog_extra='git log --all --decorate=full --oneline --graph'
alias docker-prune='docker system prune'
alias nuke-stopped-docker-container='docker rm `docker ps --no-trunc -aq`'
alias lock-screen='i3lock --color=#000000'

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/home/$USER/.local/bin:/home/$USER/bin"
export EDITOR='emacs'

function open_github_page()
{
    if [ ! -d .git ] ;
        then echo "ERROR: This isnt a git directory" && return false;
    fi
    git_url=`git config --get remote.origin.url`
    if [[ $git_url != https://github* ]] ;
        then git_url=`echo $git_url | sed 's/git@/https:\/\//; s/.com:/.com\//'`;
    fi
    url=${git_url%.git}
    xdg-open $url
}

function monitor_volume_down() {
    if [ -n "$1" ]
    then
	pactl set-sink-volume 0 -"$1"%
    fi
}

function monitor_volume_up() {
    if [ -n "$1" ]
    then
	pactl set-sink-volume 0 +"$1"%
    fi
}

function monitor_set_volume_to() {
    if [ -n "$1" ]
    then
	pactl set-sink-volume 0 "$1"%
    fi
}

function headphones_volume_down() {
    if [ -n "$1" ]
    then
	pactl set-sink-volume 1 -"$1"%
    fi
}

function headphones_volume_up() {
    if [ -n "$1" ]
    then
	pactl set-sink-volume 1 +"$1"%
    fi
}

function headphones_set_volume_to() {
    if [ -n "$1" ]
    then
	pactl set-sink-volume 1 "$1"%
    fi
}

export GPG_TTY=$(tty)
