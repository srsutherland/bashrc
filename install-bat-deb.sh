#!/bin/bash

architecture="$(dpkg --print-architecture)"
cd /tmp

curl https://api.github.com/repos/sharkdp/bat/releases/latest \
    | grep "browser_download_url" \
    | grep ${architecture}.deb \
    | cut -d '"' -f 4 \
    | tee /dev/tty \
    | wget --show-progress -qi - &&
    ls bat_*.deb &&
    sudo dpkg -i bat_*.deb
