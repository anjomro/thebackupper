openssl rsautl -decrypt -inkey ~/.ssh/id_rsa -in key.bin.enc -out key.bin
echo "Decrypted key.bin with private key"
openssl enc -d -aes-256-cbc -iter 1000000  -in $todecrypt.enc -out $todecrypt -pass file:./key.bin
echo "Decrypted file!"
