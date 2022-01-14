#!/bin/bash

echo -e "\033[1;36m""> youtube-dl --version" "\033[0m"
youtube-dl --version
echo -e "\033[1;36m""> sudo curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/youtube-dl" "\033[0m"
sudo curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/youtube-dl
echo -e "\033[1;36m""> sudo chmod a+rx /usr/local/bin/youtube-dl" "\033[0m"
sudo chmod a+rx /usr/local/bin/youtube-dl
echo -e "\033[1;36m""> youtube-dl --version" "\033[0m"
youtube-dl --version
