export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="agnoster"
CASE_SENSITIVE="true"

export UPDATE_ZSH_DAYS=7
export DEFAULT_USER="matt"
prompt_context(){}

plugins=(git python archlinux emacs pipenv)

source $ZSH/oh-my-zsh.sh

alias activate_venv='pipenv shell'
alias sudo='sudo -E'
alias glog_extra='git log --all --decorate=full --oneline --graph'
alias docker-prune='docker system prune'
alias nuke-stopped-docker-container='docker rm `docker ps --no-trunc -aq`'
alias lock-screen='i3lock --color=#000000'
alias commit_all_shit='git add . && git commit --amend --no-edit'
alias clean-from-temp='find . \( -name "*~" -o -name "*#" \) -exec rm -rf {} \;'
alias clean-pyc='find . -name "*.pyc*" -exec rm -rf {} \;'
alias git-sync-local-remote-branches='git remote prune origin'
alias generate-ssh-key='ssh-keygen -t ed25519 -C "promat85@gmail.com"'

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/home/$USER/.local/bin:/home/$USER/bin:/home/$USER/.gem/ruby/2.5.0/bin:$HOME/.cargo/bin"
export EDITOR='emacsclient -c -a "emacs"'
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

function mount_nfs_home_media() {
    sudo mount -t nfs -o ro vers=3 10.0.1.31:/stardust/media /home/matt/media
    sudo mount -t nfs -o vers=3 10.0.1.31:/stardust/mattia/astro /home/matt/astro
}

function gsc_kstars() {
    export GSCBIN=/usr/share/GSC/bin
    export GSCDAT=/usr/share/GSC
    export PATH=$GSCBIN:$PATH
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

function check_cpu_frequency() {
    watch -n 1 "cat /proc/cpuinfo | grep \"^[c]pu MHz\""
}

function git-nuke-local-nonexisting-branches() {
    git branch -vv | grep ": gone" | awk '{print $1}' | xargs git branch -d
}

export GPG_TTY=$(tty)

eval "$(pyenv init -)"

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/bin/vault vault

. $HOME/.asdf/asdf.sh

# add Pulumi to the PATH
export PATH=$PATH:$HOME/.pulumi/bin
export PYTHONPATH=$PYTHONPATH:/home/matt/data/repos/cyclope

# Hook direnv
eval "$(direnv hook zsh)"
export PYTHONPATH=$PYTHONPATH:/home/matt/data/repos/waf-allowlist
export PYTHONPATH=$PYTHONPATH:/home/matt/data/repos/infra-ctrl

function find_and_replace_in_files() {
    # $1, the first argument is the file extension
    # $2, the second arg is the string we are looking for (enclose in "" if it conatins white spaces)
    # $3, the third argument is the replacement string ("" if it contains whitespaces"
    find . -name "*.$1" -exec sed -i "s/"$2"/"$3"/g" '{}' \;
}

function see-sslcert () {
  nslookup $1
  (openssl s_client -showcerts -servername $1 -connect $1:443 <<< "Q" | openssl x509 -text | grep "DNS After")
}
