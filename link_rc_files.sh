DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
echo Running from $DIR

function einfo() { echo -e "\033[1;36m${@}\033[0m" 2>&1; }
function ewarn() { echo -e "\033[1;33m${@}\033[0m" 2>&1; }
function eerror() { echo -e "\033[1;31m${@}\033[0m" 2>&1; }

link_file () {
    einfo "link ~/$1 -> $DIR/$1"
    ln -s "$DIR/$1" ~/"$1"
}

files=(.bash_aliases .vimrc .inputrc)

for file in "${files[@]}"; do
    link_file "$file"
done

if ! grep -q -F ". ~/.bash_aliases" ~/.bashrc; then
    echo "if [ -f ~/.bash_aliases ]; then" >> ~/.bashrc
    echo "    . ~/.bash_aliases" >> ~/.bashrc
    echo "fi" >> ~/.bashrc
    echo added \"". ~/.bash_aliases"\" to \~/.bashrc
else
    echo \"". ~/.bash_aliases"\" already in \~/.bashrc
fi
if ! grep -q -F ". ~/.psrc" ~/.bashrc; then
    echo "if [ -f ~/.psrc ]; then" >> ~/.bashrc
    echo "    . ~/.psrc" >> ~/.bashrc
    echo "fi" >> ~/.bashrc
    echo added \"". ~/.psrc"\" to \~/.bashrc
else
    echo \"". ~/.psrc"\" already in \~/.bashrc
fi
