if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# These belong in ~/.bash_aliases
alias ls='ls --color=auto'
alias l='ls -CF --color=auto'
alias la='ls -A --color=auto'
alias ll='ls -AlF --color=auto'
alias l.='ls -d --color=auto .*'
alias ld='ls -d --color=auto */'
alias rc='ls ~/.*rc ~/.bash_aliases'

alias cd..='cd ..'
alias ls..='ls .. --color=auto'
