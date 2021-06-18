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
        echo -e "\033[1;33m$(youtube-dl -4 --get-title "$url")\033[0m"
        youtube-dl -4 --no-playlist "$url"
        echo -en "\033[1;35mytdl: \033[0m"
    done
}
alias dlloop='loopdl'
alias ytloop='loopdl'
