DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
echo Running from $DIR
ln -s $DIR/.bash_aliases ~/.bash_aliases
ln -s $DIR/.vimrc ~/.vimrc
ln -s $DIR/.inputrc ~/.inputrc

if ! grep -F ". ~/.bash_aliases" .bashrc; then
    echo "if [ -f ~/.bash_aliases ]; then" >> ~/.bashrc
    echo "    . ~/.bash_aliases" >> ~/.bashrc
    echo "fi" >> ~/.bashrc
fi
if ! grep -F ". ~/.psrc" .bashrc; then
    echo "if [ -f ~/.psrc]; then" >> ~/.bashrc
    echo "    . ~/.psrc" >> ~/.bashrc
    echo "fi" >> ~/.bashrc
fi
