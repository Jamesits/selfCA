#!/bin/bash

source util/check_openssl.sh
source util/check_user.sh
source util/check_dir.sh
source util/wipe_dir.sh
source util/prompt_info.sh
source util/escape_sed.sh
source config.sh

prompt_info "Please make sure the follow info is correct\n" \
            "Creating intermediate CA under $SELFCA_ROOT/$INTERMEDIATE_CERT_NAME\n" \
            "Current user: $CURRENT_USER\n" \
            "OpenSSL: $OPENSSL_VERSION\n" \
            "Using templates from: $PROGRAM_DIR\n" \
            "\nPress <Enter> to proceed."
if [ ! $? -eq 0 ]; then
    exit -1
fi

cd "$SELFCA_ROOT"

wipe_dir "$INTERMEDIATE_CERT_NAME"
cd "$INTERMEDIATE_CERT_NAME"

mkdir -p certs crl csr newcerts private
chmod 700 private
touch index.txt
echo 1000 > serial
echo 1000 > crlnumber

cp $PROGRAM_DIR/template/openssl.intermediate.cnf openssl.cnf
sed -i "" -e "s/$(escape_sed_regex %intermediatedir%)/$(escape_sed_replace $SELFCA_ROOT/$INTERMEDIATE_CERT_NAME)/g" openssl.cnf
