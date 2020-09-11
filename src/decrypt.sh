#!/bin/bash
openssl rsautl -decrypt -inkey ~/.ssh/id_rsa -in key.bin.enc -out key.bin
echo "Decrypted key.bin with private key"
openssl enc -d -aes-256-cbc -iter 100000  -in $1.enc -out $1 -pass file:./key.bin
echo "Decrypted file!"
rm key.bin.enc
rm $1.enc
echo "Cleaned up, finished!"
