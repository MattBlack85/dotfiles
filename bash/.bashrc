# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
      . /etc/bashrc
fi

if [ -f /usr/share/git/contrib/completion/git-completion.tcsh ]; then
      . /usr/share/git/contrib/completion/git-completion.tcsh
fi

if [ -f /usr/share/git-core/contrib/completion/git-prompt.sh ]; then
      . /usr/share/git-core/contrib/completion/git-prompt.sh
fi

\[ and \]

GIT_PS1_SHOWDIRTYSTATE=true
PS1='\[\033[32m\][\[\033[0m\]\t\[\033[32m\]]\[\033[0m\]:\[\033[33m\][\W]\[\033[0m\]\[\033[31m\]$(__git_ps1)\[\033[0m\]\$ '

# User specific aliases and functions
alias sudo='sudo -E'

#export HTTP_PROXY='someproxy.some.thing'
export HTTPS_PROXY=$HTTP_PROXY
export http_proxy=$HTTP_PROXY
export https_proxy=$HTTP_PROXY

function ppath {
      export PYTHONPATH=$PYTHONPATH:$(pwd)
      export PATH=$PATH:$(pwd)
}

function gpath {
      export PATH=$PATH:/usr/local/go/bin
}
