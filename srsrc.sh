# curl https://raw.githubusercontent.com/srsutherland/bashrc/master/srsrc.sh | sh
repo='https://raw.githubusercontent.com/srsutherland/bashrc/master'

curl $repo/.bash_aliases >> .bash_aliases 
curl $repo/.bashrc >> .bashrc
curl $repo/.inputrc >> .inputrc 
curl $repo/.vimrc >> .vimrc 
