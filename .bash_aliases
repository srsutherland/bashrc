# These belong in ~/.bash_aliases
alias ls='ls --color=auto'
alias l='ls -CF --color=auto'
alias la='ls -A --color=auto'
alias ll='ls -AlF --color=auto'
alias l.='ls -d --color=auto .!(|.)'
alias ld='ls -d --color=auto */ 2> /dev/null' #Shadows built-in linker

alias rc='ls ~/.*rc ~/.bash_aliases'
alias catrc='if [ -f ~/.bash_aliases ]; then cat ~/.bash_aliases; else cat ~/.bashrc; fi'
alias realias='if [ -f ~/.bash_aliases ]; then source ~/.bash_aliases; else source ~/.bashrc; fi'
alias vilias='if [ -f ~/.bash_aliases ]; then vi ~/.bash_aliases; else vi ~/.bashrc; fi'

alias upgrade='sudo apt-get update && sudo apt-get upgrade'
alias aptdate='sudo apt-get update'
alias install='sudo apt-get install' #Shadows built-in "install"
alias ai='sudo apt-get install'

alias cd..='cd ..'
alias ls..='ls .. --color=auto'

alias h='history'
alias pu='pushd'
alias po='popd'

alias version="cat /etc/os-release || lsb_release -a || hostnamectl"
alias -- --version="cat /etc/os-release || lsb_release -a || hostnamectl"

alias gits='git status -s'
alias gita='git status -s && read -p "Add all? " -n 1 -r; if [[ $REPLY =~ ^[Yy]$ ]]; then echo; git add .; fi'
alias gitm='git commit -m'

alias rot13='tr A-Za-z N-ZA-Mn-za-m'
alias rot47='tr ''!-~'' ''P-~!-O'

alias ccat='pygmentize'

alias grepath='echo $PATH | grep '
