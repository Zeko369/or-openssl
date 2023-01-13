Netko je baki ukrao kolače! Tko je sumnjivac?

```bash
# check if the certificate is valid if it is signed by a trusted CA

openssl verify -CAfile /etc/ssl/certs/ca-certificates.crt certificate_file

# check if certificate is expired

openssl x509 -checkend 0 -noout -in certificate_file
```


CA je Certificate Authority, u potpunosti vjerujemo CA !!!

Ukoliko trebate izvući javni ključ osobe iz njenog/njegovog certifikata, korisite:

openssl x509 -pubkey -noout -in certificate_file > pubkey_file