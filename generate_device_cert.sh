#!/bin/bash
set -e

# Variables
DEVICE_NAME="$1"
PRIVATE_KEY="./certs/private/${DEVICE_NAME}.key.pem" 
CSR="./certs/csr/${DEVICE_NAME}.csr.pem"
DEVICE_CERT="./certs/certs/${DEVICE_NAME}.cert.pem"
FULL_CHAIN_CERT="./certs/certs/${DEVICE_NAME}-full-chain.cert.pem"
PFX_CERT="./certs/certs/${DEVICE_NAME}-full-chain.cert.pfx"
PFX_PASSWORD="1234"
INTERMEDIATE_CERT="./certs/certs/azure-iot-test-only.intermediate.cert.pem"
ROOT_CA="./certs/certs/azure-iot-test-only.root.ca.cert.pem"

# Create a new private key for the device
openssl genrsa -out "$PRIVATE_KEY" 4096

# Create a CSR (Certificate Signing Request) for the device
openssl req -config ./certs/openssl_device_intermediate_ca.cnf -key "$PRIVATE_KEY" -subj "/CN=${DEVICE_NAME}" -new -sha256 -out "$CSR"

# Create the device certificate using the intermediate CA
openssl ca -batch -config ./certs/openssl_device_intermediate_ca.cnf -passin pass:1234 -extensions usr_cert -days 30 -notext -md sha256 -in "$CSR" -out "$DEVICE_CERT"

# Concatenate the device certificate with the intermediate and root certificates to create the full chain
cat "$DEVICE_CERT" "$INTERMEDIATE_CERT" "$ROOT_CA" > "$FULL_CHAIN_CERT"

# Create a PFX file from the full chain certificate and private key
openssl pkcs12 -inkey "$PRIVATE_KEY" -in "$FULL_CHAIN_CERT" -export -passin pass:1234 -passout pass:"$PFX_PASSWORD" -out "$PFX_CERT"

echo "Certificate for $DEVICE_NAME generated successfully."
