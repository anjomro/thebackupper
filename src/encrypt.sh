#!/bin/bash
openssl rand -hex -out key.bin 64
echo -n "Key generated:"
cat key.bin
echo -ne "\n"
openssl enc -aes-256-cbc -iter 1000000  -in $1 -out $1.enc -pass file:./key.bin
echo "Encrypted $1, stored as $1.enc!"
mv $1 ORIGINAL$1
openssl rsautl -encrypt --inkey /thebackupper/public_key.pem -pubin -in key.bin -out key.bin.enc
rm key.bin
echo "Encrypted key.bin with public key as key.bin.enc, deleted key.bin."
echo "Finished encryption"
