#!/bin/bash

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
