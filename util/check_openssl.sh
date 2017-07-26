#!/bin/bash

OPENSSL_VERSION=$(openssl version)
if [ $? -eq 0 ]
then
    echo "Using OpenSSL version: $OPENSSL_VERSION"
else
    echo "FATAL: OpenSSL not found" >&2
    exit 127
fi
