#!/bin/bash

# Ensure a directory exists and is empty (if not specified by user)
wipe_dir() {
    if [ -d "$1" ]; then
        # dir exists
        if [ "$(ls -A $1)" ]; then
            # dir not empty
            dialog --title "Warning"  --yesno "Directory not empty. Wipe it?" 6 25
            if [ $? -eq 0 ]
            then
                rm -rf $1
            fi
        fi
    else
        if [ -e "$1" ]; then
            # name taken by a regular file
            dialog --title "Warning"  --yesno "Name already taken. Delete that file?" 6 25
            if [ $? -eq 0 ]
            then
                rm -f $1
            fi
    fi
    mkdir -p $1
}
