#!/bin/bash

# Delete GPUcaches for broken app when ChromeOS/Crostini linux containers update and break them.
fix_cache() {
    if [ -z "$1" ]; then
        echo "Usage: fix_cache <app_name>"
        return 1
    fi

    app_name=$1

    # Find the directory containing the app name and the GPUCache subdirectory inside it
    gpu_cache_path=$(find ~/.config -type d -iname "*$app_name*" -exec find {} -type d -name "GPUCache" \; 2>&1)

    # Check if any errors occurred during the find command
    if [[ $? -ne 0 ]]; then
        echo "Error finding the GPUCache directory:"
        echo "$gpu_cache_path"
        return 1
    fi

    # Check if GPUCache directory was found
    if [ -z "$gpu_cache_path" ]; then
        echo "No GPUCache directory found for the app: $app_name"
        return 1
    fi

    # Replace the home directory path with "~" for display
    display_path=${gpu_cache_path/#$HOME/\~}

    read -p "Delete \"$display_path/\" (y/n)? " confirmation

    # Delete dir
    if [[ "$confirmation" == "y" || "$confirmation" == "Y" ]]; then
        rm -rf "$gpu_cache_path"
        echo "Deleted: $display_path"
    else
        echo "Deletion canceled."
    fi
}

