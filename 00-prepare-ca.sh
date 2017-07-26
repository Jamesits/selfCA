#!/bin/bash

source util/check_openssl.sh
source util/check_user.sh
source util/check_dir.sh
source util/wipe_dir.sh
source util/prompt_info.sh
source util/escape_sed.sh
source config.sh

prompt_info "Please make sure the follow info is correct\n" \
            "Creating CA under $SELFCA_ROOT\n" \
            "Current user: $CURRENT_USER\n" \
            "OpenSSL: $OPENSSL_VERSION\n" \
            "Using templates from: $PROGRAM_DIR\n" \
            "\nPress <Enter> to proceed."
if [ ! $? -eq 0 ]; then
    exit -1
fi

wipe_dir $SELFCA_ROOT
cd $SELFCA_ROOT
mkdir -p certs crl newcerts private
chmod 700 private
touch index.txt
echo 1000 > serial

cp $PROGRAM_DIR/template/openssl.rootca.cnf openssl.cnf
echo $(escape_sed_regex %rootdir%)
sed -i"" -e "s/$(escape_sed_regex %rootdir%)/$(escape_sed_replace $SELFCA_ROOT)/g" openssl.cnf
