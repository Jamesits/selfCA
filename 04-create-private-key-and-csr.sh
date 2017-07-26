#!/bin/bash
# Create a private key
# Run this on your own web server (you need to copy your intermediate openssl.conf)
# Note: key is not encrypted

source util/check_openssl.sh
source util/check_user.sh
source util/check_dir.sh
source util/wipe_dir.sh
source util/prompt_info.sh
source util/die.sh
source config.sh

if [[ "$#" -ne 1 ]]; then
    die "Usage: $0 common_name\nThis will generate common_name.key.pem and common_name.csr.pem"
fi

COMMON_NAME=$1

openssl genrsa -out "$COMMON_NAME.key.pem" $DEFAULT_KEY_LENGTH
chmod 400 "$COMMON_NAME.key.pem"
openssl req -config "$SELFCA_ROOT/$INTERMEDIATE_CERT_NAME/openssl.cnf" -key "$COMMON_NAME.key.pem" -new -sha256 -extensions san_env -out "$COMMON_NAME.csr.pem"
