# selfCA

Some OpenSSL wrapper scripts to generate your own CA and sign certs.

## Installation
### macOS
```shell
brew install dialog
```

### Ubuntu
```shell
apt install dialog
```

## Usage

First copy `config.template.sh` to `config.sh`.

### CRL

Add the following content to `v3_intermediate_ca`, `user_cert` or `server_cert`:
```
crlDistributionPoints = URI:http://example.com/intermediate.crl.pem
```

## Thanks

 * [OpenSSL Certificate Authority](https://jamielinux.com/docs/openssl-certificate-authority/index.html)
