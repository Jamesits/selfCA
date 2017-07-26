#!/bin/bash

source util/check_openssl.sh
source util/check_user.sh
source util/check_dir.sh
source util/wipe_dir.sh
source util/prompt_info.sh
source util/die.sh
source config.sh

if [[ "$#" -ne 3 ]]; then
    die "Usage: $0 csr_file.csr.pem cert_file.cert.pem days"
fi

CSR="$1"
CERT="$2"
DAYS="$3"

openssl ca -config "$SELFCA_ROOT/$INTERMEDIATE_CERT_NAME/openssl.cnf" -extensions server_cert -days $DAYS -notext -md sha256 -extensions san_env -in "$CSR" -out "$CERT"
chmod 444 "$CERT"
openssl x509 -noout -text -in "$CERT"
openssl verify -CAfile "$SELFCA_ROOT/$INTERMEDIATE_CERT_NAME/certs/ca-chain.cert.pem" "$CERT"
