#!/bin/sh

# write an array of foo, bar, baz
ARRAY=(baka crvenkapa lovac panda vuk zec)

# Export baka's and vuk's public key
# openssl x509 -pubkey -noout -in ./data/baka.crt > ./data/baka.pem
# openssl x509 -pubkey -noout -in ./data/vuk.crt > ./data/vuk.pem

rm ./story.txt

for person in "${ARRAY[@]}"
do
    echo "---------------"
    echo "Testing $person"

    # some people are missing public keys derive them from the certificate
    if [ ! -f ./data/$person.pem ]; then
        openssl x509 -pubkey -noout -in ./data/$person.crt > ./data/$person.pem
    elif [ -f ./data/$person.crt ]; then
        # check if the public key is valid and matches the certificate
        openssl x509 -pubkey -noout -in ./data/$person.crt > ./data/$person.pem.tmp

        if ! diff ./data/$person.pem ./data/$person.pem.tmp > /dev/null ; then
            echo "!!!Public key does not match certificate!!!"
        fi

        rm ./data/$person.pem.tmp
    fi

    signature_valid="$(openssl dgst -sha256 -verify ./data/$person.pem -signature ./data/$person.sig ./data/$person.txt)"
    if [ "$signature_valid" = "Verified OK" ]; then
        echo "Signature is valid"
    else
        echo "!!!Signature is invalid!!!"
    fi

    if [ ! -f ./data/$person.crt ]; then
        echo "[[[[Certificate is missing]]]]"
        continue
    fi

    cert_valid="$(openssl verify -CAfile ./data/ca.crt ./data/$person.crt)"
    echo "Certificate is valid: $cert_valid"

    username=$person
    if [ $person = "crvenkapa" ]; then # name in certificate is rrrh
        username="rrrh"
    fi

    if ! grep -q $username ./data/$person.crt; then
        echo "!!!Person name is not in the certificate!!!"
    fi

    echo "$person\n" >> ./story.txt
    cat ./data/$person.txt >> ./story.txt
    echo "\n" >> ./story.txt

    # expired="$(openssl x509 -checkend 0 -in ./data/$person.crt)"
    # echo "Certificate is expired: $expired"
done
