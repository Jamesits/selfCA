#!/bin/bash

# Ensure a directory exists and is empty (if not specified by user)
wipe_dir() {
    if [ -d "$1" ]; then
        # dir exists
        if [ "$(ls -A $1)" ]; then
            # dir not empty
            dialog --title "Warning"  --yesno "Directory \"$1\" not empty. Wipe it?" 8 80
            if [ $? -eq 0 ]; then
                rm -rf $1
            fi
        fi
    else
        if [ -e "$1" ]; then
            # name taken by a regular file
            dialog --title "Warning"  --yesno "Name \"$1\" already taken. Delete that file?" 8 80
            if [ $? -eq 0 ]; then
                rm -f $1
            fi
        fi
    fi
    mkdir -p $1
}
