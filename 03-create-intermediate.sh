#!/bin/bash

source util/check_openssl.sh
source util/check_user.sh
source util/check_dir.sh
source util/wipe_dir.sh
source util/prompt_info.sh
source util/die.sh
source config.sh

cd "$SELFCA_ROOT"

echo "You will be prompted to enter your intermediate key pass phrase. Enter a strong passphrase and remember it. "
openssl genrsa -aes256 -out "$INTERMEDIATE_CERT_NAME/private/$INTERMEDIATE_CERT_NAME.key.pem" $INTERMEDIATE_KEY_LENGTH
chmod 400 "$INTERMEDIATE_CERT_NAME/private/$INTERMEDIATE_CERT_NAME.key.pem"

# Generate CSR
echo "You will be prompted to enter your intermediate key pass phrase again, and information for your intermediate certificate. "
openssl req -config "$INTERMEDIATE_CERT_NAME/openssl.cnf" -new -sha256 -extentions san_env -key "$INTERMEDIATE_CERT_NAME/private/$INTERMEDIATE_CERT_NAME.key.pem" -out "$INTERMEDIATE_CERT_NAME/csr/$INTERMEDIATE_CERT_NAME.csr.pem" || die "Unable to generate CSR, maybe wrong intermediate key passphrase?"

# Sign with root cert
echo "You will be prompted to enter your root key pass phrase"
openssl ca -config openssl.cnf -extensions v3_intermediate_ca -days $INTERMEDIATE_CERT_DAYS -notext -md sha256 -extentions san_env -in "$INTERMEDIATE_CERT_NAME/csr/$INTERMEDIATE_CERT_NAME.csr.pem" -out "$INTERMEDIATE_CERT_NAME/certs/$INTERMEDIATE_CERT_NAME.cert.pem" || die "Unable to sign cert, maybe wrong root key pass phrase?"

chmod 444 "$INTERMEDIATE_CERT_NAME/certs/$INTERMEDIATE_CERT_NAME.cert.pem"

echo "Verifying your intermediate certificate"
openssl x509 -noout -text -in "$INTERMEDIATE_CERT_NAME/certs/$INTERMEDIATE_CERT_NAME.cert.pem"
openssl verify -CAfile "certs/ca.cert.pem" "$INTERMEDIATE_CERT_NAME/certs/$INTERMEDIATE_CERT_NAME.cert.pem"

echo "Creating certificate chain"
cat "$INTERMEDIATE_CERT_NAME/certs/$INTERMEDIATE_CERT_NAME.cert.pem" "certs/ca.cert.pem" > "$INTERMEDIATE_CERT_NAME/certs/$INTERMEDIATE_CERT_NAME.cert.pem"
chmod 444 "$INTERMEDIATE_CERT_NAME/certs/$INTERMEDIATE_CERT_NAME-ca-chain.cert.pem"
