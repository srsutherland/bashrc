#!/bin/bash

export YTDL_base_dir="~/Downloads/YT/ytdl"

function loopdl() {
    local base_dir="$1"
    if [ -z "$1" ]; then
        base_dir="$YTDL_base_dir"
    fi
    local cur_dir="$base_dir"
    local next_dir="$base_dir"
    eval cd "$base_dir"
    echo -e "\033[1;36mcd ${base_dir}\033[0m"
    echo -en "\033[1;35mytdl: \033[0m"
    while read url; do
        echo -e "\033[33m$url\033[0m"
        if [[ "$url" =~ t(witter)?\.com? ]]; then
            next_dir="${base_dir}/twitter"
        else
            next_dir="$base_dir"
        fi
        if [[ "$next_dir" != "$cur_dir" ]]; then
            cur_dir="$next_dir"
            eval cd "$cur_dir"
            echo -e "\033[1;36mcd ${cur_dir}\033[0m"
        fi
        echo -e "\033[1;33m$(youtube-dl -4 --get-title --no-playlist "$url")\033[0m"
        youtube-dl -4 --no-playlist "$url"
        echo -en "\033[1;35mytdl: \033[0m"
    done
}
alias dlloop='loopdl'
alias ytloop='loopdl'

function ytclip() {
    local yturl=$1
    local t0=$2
    local dt=$3

    local IFS0="$IFS"
    echo -e "\033[1;36mRequesting video and audio streams for ${yturl}\033[0m"
    IFS=$'\n' read -r -d '' vURL aURL filename <<< $(ytdl -4 --get-url --get-filename -o "%(title)s-%(id)s-clip" $yturl)
    IFS="$IFS0"

    if [[ $vURL != http* ]] ; then
        echo Invalid video stream url: $vURL
    fi
    if [[ $aURL != http* ]] ; then
        echo Invalid audio stream url: $aURL
    fi
    if [[ $vURL != http* ]] | [[ $aURL != http* ]] ; then 
       return 1 
    fi
    
    echo -e "\033[1;36mCreating clip \"${filename}.mp4\"\033[0m"
    if [[ -z $t0 ]] ; then
        echo Error: no start time supplied
        return 1
    fi
    if [[ -z $dt ]] ; then
        echo Error: no clip duration supplied
        return 1
    fi
    ffmpeg -ss "$t0" -i "$vURL" -ss "$t0" -i "$aURL" -t "$dt" -map 0:v -map 1:a "${filename}.mp4"
}
