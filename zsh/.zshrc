export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="robbyrussell"

CASE_SENSITIVE="true"
export UPDATE_ZSH_DAYS=7

plugins=(git yum python)

source $ZSH/oh-my-zsh.sh

alias sudo='sudo -E'
alias glog_extra='git log --all --decorate=full --oneline --graph'
alias pip3='python3-pip'

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/home/matt/.local/bin:/home/matt/bin"
export EDITOR='emacs'
export PATH=$PATH:/home/matt/repos/relx
export PATH=$PATH:/home/matt/repos/rebar
export PYHTONPATH=$PYTHONPATH:/home/matt/repos/billing
export ERL_FLAGS="-pa /home/matt/repos/geocouch/ebin"
