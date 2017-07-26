#!/bin/bash

source util/check_openssl.sh
source util/check_user.sh
source util/check_dir.sh
source util/wipe_dir.sh
source util/prompt_info.sh
source util/die.sh
source config.sh

cd "$SELFCA_ROOT"
wipe_dir "$DISTRIBUTE_DIR"

cp "certs/ca.cert.pem" "$DISTRIBUTE_DIR"
cp "$INTERMEDIATE_CERT_NAME/certs/$INTERMEDIATE_CERT_NAME.cert.pem" "$DISTRIBUTE_DIR"
cp "$INTERMEDIATE_CERT_NAME/certs/ca-chain.cert.pem" "$DISTRIBUTE_DIR"
