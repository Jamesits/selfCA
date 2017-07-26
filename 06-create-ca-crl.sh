#!/bin/bash

source util/check_openssl.sh
source util/check_user.sh
source util/check_dir.sh
source util/wipe_dir.sh
source util/prompt_info.sh
source util/die.sh
source config.sh

cd "$SELFCA_ROOT"

echo "You will be prompted to enter your root key pass phrase."
openssl ca -config "openssl.cnf" -gencrl -out "crl/root.crl.pem"
