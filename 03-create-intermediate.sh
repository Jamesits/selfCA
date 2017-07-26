#!/bin/bash

source util/check_openssl.sh
source util/check_user.sh
source util/check_dir.sh
source util/wipe_dir.sh
source util/prompt_info.sh
source config.sh

cd "$SELFCA_ROOT"

echo "You will be prompted to enter your intermediate key pass phrase. Enter a strong passphrase and remember it. "
openssl genrsa -aes256 -out $INTERMEDIATE_CERT_NAME/private/ca.key.pem 4096
chmod 400 $INTERMEDIATE_CERT_NAME/private/ca.key.pem

echo "You will be prompted to enter your intermediate key pass phrase again, and information for your intermediate certificate. "

# Generate CSR
openssl req -config "$INTERMEDIATE_CERT_NAME/openssl.cnf" -new -sha256 -key "$INTERMEDIATE_CERT_NAME/private/intermediate.key.pem" -out "$INTERMEDIATE_CERT_NAME/csr/intermediate.csr.pem"

# Sign with root cert
openssl ca -config openssl.cnf -extensions v3_intermediate_ca -days INTERMEDIATE_CERT_DAYS -notext -md sha256 -in "$INTERMEDIATE_CERT_NAME/csr/intermediate.csr.pem" -out "$INTERMEDIATE_CERT_NAME/certs/intermediate.cert.pem"

chmod 444 "$INTERMEDIATE_CERT_NAME/certs/intermediate.cert.pem"

echo "Verifying your root certificate"
openssl x509 -noout -text -in "$INTERMEDIATE_CERT_NAME/certs/intermediate.cert.pem"
openssl verify -CAfile certs/ca.cert.pem $INTERMEDIATE_CERT_NAME/certs/intermediate.cert.pem
