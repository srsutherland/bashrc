#!/bin/bash
# ~/.bash_aliases : sourced by ~/.bashrc

alias ls='ls --color=auto'
alias l='ls -CF --color=auto'
alias la='ls -A --color=auto'
alias ll='ls -AlF --color=auto'
alias l.='ls -d --color=auto .!(|.)'
alias ld='ls -d --color=auto */ 2> /dev/null' #Shadows built-in linker

alias cd..='cd ..'
alias cd...='cd ../..'
alias cd....='cd ../../..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ls..='ls .. --color=auto'

alias h='history'
alias pu='pushd'
alias po='popd'

alias sh=$SHELL

alias rc='ls ~/.*rc ~/.*_aliases'
alias catrc='if [ -f ~/.bash_aliases ]; then cat ~/.bash_aliases; else cat ~/.bashrc; fi'
alias realias='if [ -f ~/.bash_aliases ]; then source ~/.bash_aliases; else source ~/.bashrc; fi'
alias vilias='if [ -f ~/.bash_aliases ]; then vi ~/.bash_aliases; else vi ~/.bashrc; fi'

if declare -F aptdate > /dev/null; then
    alias upgrade='aptdate && sudo apt upgrade'
    alias install='aptdate && sudo apt install' #Shadows built-in "install"
    alias ai='aptdate && sudo apt install'
else
    alias upgrade='sudo apt update && sudo apt upgrade'
    alias aptdate='sudo apt update'
    alias install='sudo apt install' #Shadows built-in "install"
    alias ai='sudo apt install'
fi

alias version="lsb_release -a || cat /etc/os-release || hostnamectl"
alias -- --version="lsb_release -a || cat /etc/os-release || hostnamectl"

alias gits='git status -s'
alias gita='git status -s && read -p "Add all? " -n 1 -r; if [[ $REPLY =~ ^[Yy]$ ]]; then echo; git add .; fi; git status -s'
alias gitm='git commit -m'

alias rot13='tr A-Za-z N-ZA-Mn-za-m'
alias rot47='tr ''!-~'' ''P-~!-O'

alias ccat='pygmentize'

alias grepath='echo $PATH | grep '
alias greph='history | grep '
function gran() { local cmd="$1"; shift; man $cmd | grep -B1 -A3 "$@"; }

function filesize() { ls -lah $1 | awk -F " " {'print $5'}; }

alias ?='echo returned $?'
alias +x='chmod +x'

# aliases local to only this machine (untracked)
if [ -f ~/.local_aliases ]; then
    . ~/.local_aliases 
fi
