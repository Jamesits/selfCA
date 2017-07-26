#!/bin/bash

# like PHP's die()
die() {
    echo "$*" >&2
    exit -1
}
