# This must go first with p10k
export GPG_TTY=$(tty)
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="powerlevel10k/powerlevel10k"
CASE_SENSITIVE="true"
export UPDATE_ZSH_DAYS=7
export DEFAULT_USER="matt"
prompt_context(){}

plugins=(archlinux direnv emacs git python rust)

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
alias generate-ed25519-ssh-key='ssh-keygen -t ed25519 -C "$USER@$HOST"'
alias aws-vault='aws-vault --backend=pass'
alias turn-off='rsync-backup && poweroff'

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/home/$USER/.local/bin:/home/$USER/bin:$HOME/data/.cargo/bin:/opt/tfenv/bin:/opt/PixInsight/bin:/home/$USER/development/flutter/bin:$HOME/.pub-cache/bin:${ASDF_DATA_DIR:-$HOME/.asdf}/shims:${PYENV_ROOT}/bin:$PATH"
export EDITOR='emacsclient -c -a "emacs"'
export PYENV_ROOT="$HOME/.pyenv"
export RUSTUP_HOME="$HOME/data/.rustup"
export CARGO_HOME="$HOME/data/.cargo"
export CHROME_EXECUTABLE="/usr/bin/chromium"
export TERM=xterm-256color


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

function check_cpu_frequency() {
    watch -n 1 "cat /proc/cpuinfo | grep \"^[c]pu MHz\""
}

function git-nuke-local-nonexisting-branches() {
    git branch -vv | grep ": gone" | awk '{print $1}' | xargs git branch -d
}

export GPGKEY=77A8CE8E2EE44564A3CF76C52EB8727E0A0A67A7

eval "$(pyenv init -)"

autoload -U +X bashcompinit && bashcompinit

# add Pulumi to the PATH
export PATH=$PATH:$HOME/.pulumi/bin

# Hook direnv
eval "$(direnv hook zsh)"

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

function rsync-backup () {
    echo "Mounting /dev/nvme0n1p1 on /home/matt/data/rsync-backup-main-disk/boot"
    sudo mount /dev/nvme0n1p1 /home/matt/data/rsync-backup-main-disk/boot
    echo "Mounted /dev/nvme0n1p1"
    echo "Mounting /dev/nvme0n1p2 on /home/matt/data/rsync-backup-main-disk/root"
    sudo mount /dev/nvme0n1p2 /home/matt/data/rsync-backup-main-disk/root
    echo "Mounted /dev/nvme0n1p2"
    echo "Rsyncing /boot"
    sudo rsync -aAXHv --progress  --ignore-existing --delete /boot /home/matt/data/rsync-backup-main-disk/boot
    echo "/boot rysnced"
    echo "Rsyncing now the whole disk"
    sudo rsync -aAXHv --progress --exclude=/dev/\* --exclude=/proc/\* --exclude=/sys/\* --exclude=/var/tmp/\* --exclude=/var/spool/\* --exclude=/tmp/\* --exclude=/run/\* --exclude=/mnt/\* --exclude=/media/\* --exclude=/lost+found --exclude=/boot/\* --exclude=/home/matt/data/\* --exclude=/home/matt/games/\* --exclude=/home/matt/data/rsync-backup-main-disk/\* --ignore-existing --delete / /home/matt/data/rsync-backup-main-disk/root
    echo "Whole disk rsynced"
    echo "Umounting /home/matt/data/rsync-backup-main-disk/boot"
    sudo umount /home/matt/data/rsync-backup-main-disk/boot
    echo "Umounted"
    echo "Umounting /home/matt/data/rsync-backup-main-disk/root"
    sudo umount /home/matt/data/rsync-backup-main-disk/root
    echo "Umounted"
}

eval "$(atuin init zsh)"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
