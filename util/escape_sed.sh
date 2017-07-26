#!/bin/bash

# Escape strings for sed
# Usage:
# sed -i "" -e "s/$(escape_sed_regex regex)/$(escape_sed_replace replacement)/g" file

# Escapes a string so it can be used as a regex string in sed
escape_sed_regex() {
    echo -n $(sed 's/[^^]/[&]/g; s/\^/\\^/g' <<<"$*")
}

# Escapes a string so it can be used as a replace string in sed
escape_sed_replace() {
    echo -n $(sed 's/[&/\]/\\&/g' <<<"$*")
}
