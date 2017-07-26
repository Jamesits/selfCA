#!/bin/bash

# selfCA config
# All the configs are in the form of `KEY=VALUE` as bash variables.

# Root dir to store all your certs and keys. Should in a safe and sound place.
# It don't need to be exist; the script will create it.
SELFCA_ROOT=/root/ca

# Root certificate effective days
ROOT_CERT_DAYS=7300

# Root key length
ROOT_KEY_LENGTH=4096

# Intermediate cert name
INTERMEDIATE_CERT_NAME=test-intermediate

# Intermediate certificate effective days
INTERMEDIATE_CERT_DAYS=3650

# Intermediate key length
INTERMEDIATE_KEY_LENGTH=4096

# Website cert key length
DEFAULT_KEY_LENGTH=2048

# Certificate distribute folder
DISTRIBUTE_DIR=/tmp/ca-dist
