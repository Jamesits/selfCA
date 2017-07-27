#!/bin/bash

# Request subjectAltName from user
echo "Specify your server subjectAltName. Format: DNS:www.example.com,DNS:*.example.com"
if [[ -z "$SAN" ]]; then
    # unset, ask
    read -p "subjectAltName: " SAN
else
    read -p "subjectAltName[$SAN]: " NEW_SAN
    if [[ ! -z "$NEW_SAN" ]]; then
        SAN=$NEW_SAN
    fi
fi

export SAN
