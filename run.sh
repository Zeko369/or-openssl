#!/bin/sh

# write an array of foo, bar, baz
ARRAY=(baka crvenkapa lovac panda vuk zec)

# Export baka's and vuk's public key
# openssl x509 -pubkey -noout -in ./data/baka.crt > ./data/baka.pem
# openssl x509 -pubkey -noout -in ./data/vuk.crt > ./data/vuk.pem

for person in "${ARRAY[@]}"
do
    # some people are missing private keys derive them from the certificate
    openssl x509 -pubkey -noout -in ./data/$person.crt > ./data/$person.pem

    echo "---------------"
    echo "Testing $person"
    signature_valid="$(openssl dgst -sha256 -verify ./data/$person.pem -signature ./data/$person.sig ./data/$person.txt)"

    if [ "$signature_valid" = "Verified OK" ]; then
        echo "Signature is valid"
    else
        echo "!!!Signature is invalid!!!"
    fi

    cert_valid="$(openssl verify -CAfile ./data/ca.crt ./data/$person.crt)"
    echo "Certificate is valid: $cert_valid"

    expired="$(openssl x509 -checkend 0 -noout -in ./data/$person.crt)"
    echo "Certificate is expired: $expired"
done