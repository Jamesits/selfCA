# selfCA

Generate your own CA and sign certs fast.

## Safety Notice

 * If use in production (I wish you not), generate CA keys on an airgap PC (**NO NETWORK CONNECTION**, pull out wireless card and glue LAN port)
 * These scripts are provided as-is and doesn't guarantee any level of safety or functionality.
 * Don't leak your key pass phrases. Set strong ones.

## Installation
Works under macOS and (generic) Linux. Depends on `dialog(1)`.

### macOS
```shell
brew install dialog
```

### Ubuntu
```shell
apt install dialog
```

Then clone this repo.

## Usage

First copy `config.template.sh` to `config.sh`, change the settings as your wish.

Execute all the following lines under this directory, do not `cd` to elsewhere.

### Generate Root CA
#### Copy all the files needed
```shell
./00-prepare-ca.sh
```
If you need extra configuration on OpenSSL, now edit `$SELFCA_ROOT/openssl.cnf`.

#### (Optional) CRL settings
Add the following content to `v3_intermediate_ca` section of `$SELFCA_ROOT/openssl.cnf`:
```
crlDistributionPoints = URI:http://example.com/root.crl.pem
```

#### Generate CA key and cert
You will be asked for **Root CA key pass phrase** twice.
```shell
./01-create-ca.sh
```

### Generate Intermediate CA
#### Copy all the files needed
```shell
./02-prepare-intermediate.sh
```
If you need extra configuration on OpenSSL, now edit `$SELFCA_ROOT/$INTERMEDIATE_CERT_NAME/openssl.conf`.

#### (Optional) CRL settings
Add the following content to both `user_cert` and `server_cert` section of `$SELFCA_ROOT/$INTERMEDIATE_CERT_NAME/openssl.conf`:
```
crlDistributionPoints = URI:http://example.com/intermediate.crl.pem
```

#### Generate intermediate CA and sign it using root CA
You will be asked for **Intermediate CA key pass phrase** twice, then **Root CA key pass phrase** once. You will be asked if OK to sign, otherwise OpenSSL failed to generate key or CSR.
```shell
./03-create-intermediate.sh
```

### Create Website Certificate
Using www.example.com as example domain.

#### Generate private key and CSR
Note: to do this on webserver (to prevent private key leaking), package this repo and the `$SELFCA_ROOT` folder together, emitting any key file (extension in `.key.pem`), and put them to webserver.
```shell
./04-create-private-key-and-csr.sh /path/to/your/ssl/key/www.example.com
```
This will generate 2 files: `www.example.com.key.pem` and `www.example.com.csr.pem` under folder `/path/to/your/ssl/key/`.

#### Sign cert by intermediate CA
Note: if your private key is generated on another machine, transfer `www.example.com.csr.pem` back to the machine where intermediate CA keys exist.

You will be asked if OK to sign, otherwise OpenSSL failed to generate key or CSR.
```shell
./05-sign-cert.sh www.example.com.csr.pem www.example.com.cert.pem 365
```
This will generate `www.example.com.cert.pem`.

#### Generate cert chain
```shell
cat www.example.com.cert.pem $SELFCA_ROOT/$INTERMEDIATE_CERT_NAME/certs/$INTERMEDIATE_CERT_NAME-ca-chain.cert.pem > chain.cert.pem
```

#### Config your webserver
use `chain.cert.pem` as certificate file and `www.example.com.key.pem` as certificate key.

### CRL
#### Generate CRL
If you only enabled CRL for one CA, you only need to run one command. If you didn't set up CRL, you can safely ignore this.
```shell
./06-create-ca.crl.sh
./07-create-intermediate-crl.sh
```
CRLs are signed with corresponding private keys so you need to input pass phrase.

#### Host CRL
Get CRL file from `$SELFCA_ROOT/crl/` and `$SELFCA_ROOT/$INTERMEDIATE_CERT_NAME/crl`, put them to the correct location.

## Install Root CA

Distribute `$SELFCA_ROOT/ca/root.cert.pem` to PCs and install them. (You may need to change the extension to `.crt` for better compatiblity.)

 * [Windows](https://msdn.microsoft.com/en-us/library/cc750534.aspx)
 * [macOS](https://www.bounca.org/tutorials/install_root_certificate.html)

## FAQ

If any step failed, check:
 * If file exists already, set to read-only or have no access permission
 * If you inputed wrong pass phrase (always look at program output)
 * If the information you inputed mismatches with OpenSSL config (check the corresponding policy; some field may need to be the same with the CA)
 * If your subjectAltName is wrong or empty

## Thanks

 * [OpenSSL Certificate Authority](https://jamielinux.com/docs/openssl-certificate-authority/index.html)
