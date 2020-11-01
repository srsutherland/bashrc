#!/bin/bash

echo -e "\033[1;36m""> sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl" "\033[0m"
sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
echo -e "\033[1;36m""> sudo chmod a+rx /usr/local/bin/youtube-dl" "\033[0m"
sudo chmod a+rx /usr/local/bin/youtube-dl
echo -e "\033[1;36m""> youtube-dl --version" "\033[0m"
youtube-dl --version
