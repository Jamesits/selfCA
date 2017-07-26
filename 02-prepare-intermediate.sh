#!/bin/bash

source util/check_openssl.sh
source util/check_user.sh
source util/check_dir.sh
source util/wipe_dir.sh
source util/prompt_info.sh
source util/escape_sed.sh
source config.sh

cd "$SELFCA_ROOT"

mkdir -p "$INTERMEDIATE_CERT_NAME"
cd "$INTERMEDIATE_CERT_NAME"

mkdir -p certs crl csr newcerts private
chmod 700 private
touch index.txt
echo 1000 > serial
echo 1000 > crlnumber

cp $PROGRAM_DIR/template/openssl.intermediate.cnf openssl.cnf
sed -i "" -e "s/$(escape_sed_regex %intermediatedir%)/$(escape_sed_replace $SELFCA_ROOT/$INTERMEDIATE_CERT_NAME)/g" openssl.cnf
