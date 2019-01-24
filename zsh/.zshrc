export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="agnoster"
CASE_SENSITIVE="true"

export UPDATE_ZSH_DAYS=7
export DEFAULT_USER="matt"
prompt_context(){}

plugins=(git python archlinux django emacs)

source $ZSH/oh-my-zsh.sh
source /usr/share/nvm/init-nvm.sh

alias activate_venv='pipenv shell'
alias sudo='sudo -E'
alias glog_extra='git log --all --decorate=full --oneline --graph'
alias docker-prune='docker system prune'
alias nuke-stopped-docker-container='docker rm `docker ps --no-trunc -aq`'
alias lock-screen='i3lock --color=#000000'
alias commit_all_shit='git add . && git commit --amend --no-edit'
alias clean-from-temp='find . \( -name "*~" -o -name "*#" \) -exec rm -rf {} \;'
alias clean-pyc='find . -name "*.pyc*" -exec rm -rf {} \;'

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/home/$USER/.local/bin:/home/$USER/bin:/home/$USER/.gem/ruby/2.5.0/bin:/home/$USER/Android/Sdk/platform-tools"
export EDITOR='emacs'
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

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

eval "$(pyenv init -)"

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/bin/vault vault
