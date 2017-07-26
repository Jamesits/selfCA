#!/bin/bash

source util/check_openssl.sh
source util/check_user.sh
source util/wipe_dir.sh
source config.sh

echo "Creating CA under $SELFCA_ROOT..."
wipe_dir $SELFCA_ROOT
cd $SELFCA_ROOT
mkdir certs crl newcerts private
chmod 700 private
touch index.txt
echo 1000 > serial
