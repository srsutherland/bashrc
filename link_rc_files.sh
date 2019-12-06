DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
echo Running from $DIR
echo link \~/.bash_aliases -\> $DIR/.bash_aliases
ln -s $DIR/.bash_aliases ~/.bash_aliases
echo link \~/.vimrc -\> $DIR/.vimrc 
ln -s $DIR/.vimrc ~/.vimrc
echo link \~/.inputrc -\> $DIR/.inputrc
ln -s $DIR/.inputrc ~/.inputrc

if ! grep -q -F ". ~/.bash_aliases" ~/.bashrc; then
    echo "if [ -f ~/.bash_aliases ]; then" >> ~/.bashrc
    echo "    . ~/.bash_aliases" >> ~/.bashrc
    echo "fi" >> ~/.bashrc
    echo added \"". ~/.bash_aliases"\" to \~/.bashrc
else
    echo \"". ~/.bash_aliases"\" already in \~/.bashrc
fi
if ! grep -q -F ". ~/.psrc" ~/.bashrc; then
    echo "if [ -f ~/.psrc]; then" >> ~/.bashrc
    echo "    . ~/.psrc" >> ~/.bashrc
    echo "fi" >> ~/.bashrc
    echo added \"". ~/.psrc"\" to \~/.bashrc
else
    echo \"". ~/.psrc"\" already in \~/.bashrc
fi
