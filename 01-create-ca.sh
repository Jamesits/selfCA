#!/bin/bash

source util/check_openssl.sh
source util/check_user.sh
source util/check_dir.sh
source util/wipe_dir.sh
source util/prompt_info.sh
source util/die.sh
source config.sh

cd "$SELFCA_ROOT"

echo "You will be prompted to enter your root key pass phrase. Enter a strong passphrase and remember it. "
openssl genrsa -aes256 -out private/ca.key.pem 4096
chmod 400 private/ca.key.pem

echo "You will be prompted to enter your root key pass phrase again, and information for your root certificate. "
openssl req -config openssl.cnf -key private/ca.key.pem -new -x509 -days $ROOT_CERT_DAYS -sha256 -extensions v3_ca -out certs/ca.cert.pem || die "Unable to sign cert, maybe wrong root key pass phrase?"
chmod 444 certs/ca.cert.pem

echo "Verifying your root certificate"
openssl x509 -noout -text -in certs/ca.cert.pem
