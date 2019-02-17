# These belong in ~/.bash_aliases
alias ls='ls --color=auto'
alias l='ls -CF --color=auto'
alias la='ls -A --color=auto'
alias ll='ls -AlF --color=auto'
alias l.='ls -d --color=auto .!(|.)'
alias ld='ls -d --color=auto */' #this clobbers a linker but I'm fine with that 
alias rc='ls ~/.*rc ~/.bash_aliases'
alias catrc='if [ -f ~/.bash_aliases ]; then cat ~/.bash_aliases; else cat ~/.bashrc; fi'

alias upgrade='sudo apt-get update && sudo apt-get upgrade'
alias aptdate='sudo apt-get update'

alias cd..='cd ..'
alias ls..='ls .. --color=auto'
