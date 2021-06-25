function einfo() { echo -e "\033[1;36m${@}\033[0m" 2>&1; }
function ewarn() { echo -e "\033[1;33m${@}\033[0m" 2>&1; }
function eerror() { echo -e "\033[1;31m${@}\033[0m" 2>&1; }

# Set Termcap vars for prettier manpages
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;36m'

# Run sudo apt update if it has not run recently
function aptdate() {
    local updateInterval="${1}"
	
	local aptDate="$(stat -c %Y '/tmp/apt_updated')"
    local nowDate="$(date +'%s')"
	local lastAptGetUpdate=$((nowDate - aptDate))

    if [[ -z $updateInterval ]]
    then
        # Default To 24 hours
        updateInterval="$((24 * 60 * 60))"
    fi

    if [[ "${lastAptGetUpdate}" -gt "${updateInterval}" ]]
    then
        einfo "apt update"
        sudo apt update -m
        touch /tmp/apt_updated
    else
        local lastUpdate="$(date -u -d @"${lastAptGetUpdate}" +'%-Hh %-Mm %-Ss')"
        einfo "Skip apt-get update because its last run was '${lastUpdate}' ago"
    fi
}

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [ -f ~/.psrc ]; then
    . ~/.psrc
fi
