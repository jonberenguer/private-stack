#!/bin/bash


cat << 'EOF' > self-signed-certgen.cnf
[ req ]
default_bits       = 4096
distinguished_name = req_distinguished_name
req_extensions     = v3_req
prompt             = no

[ req_distinguished_name ]
countryName              = US
stateOrProvinceName      = SomeState
localityName             = SomeCity
organizationName         = SomeOrganization
organizationalUnitName   = SomeUnit
commonName               = *.localhost.localdomain

[ v3_req ]
keyUsage                 = nonRepudiation, digitalSignature, keyEncipherment
extendedKeyUsage         = serverAuth
subjectAltName           = @alt_names

[ alt_names ]
DNS.1 = *.localhost.localdomain
DNS.2 = localhost.localdomain
EOF


echo "Generating self-signed certificate..."
# Clean up any existing files
rm -f ./self-signed.key ./self-signed.crt

# Generate a self-signed certificate valid for 10 years (3650 days)
# with a 4096-bit RSA key
openssl req -x509 -nodes -days 3650 -newkey rsa:4096 \
-keyout ./self-signed.key \
-out ./self-signed.crt \
-config ./self-signed-certgen.cnf -extensions v3_req


# Example using openssl
# one liner
#openssl req -x509 -nodes -days 1825 -newkey rsa:4096 -keyout self-signed.key -out self-signed.crt -subj "/CN=localhost.localdomain"
