DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
echo Running from $DIR
ln -s $DIR/.bash_aliases $HOME/.bash_aliases
ln -s $DIR/.vimrc $HOME/.vimrc
ln -s $DIR/.inputrc $HOME/.inputrc
#cat .bashrc >> $HOME/.bashrc
