#variables prepended: todecrypt
#keyfiles
#pubkeyhashes
#keylocation
backupdir=$(dirname $(readlink -f $0))
cd $keylocation
success=false
for (( i=0; i<${#keyfiles[@]}; i++ )); do
	echo "Trying for ${keyfiles[$i]}" ;
	keyfile=${keyfiles[$i]}
	storedhash=${pubkeyhashes[$i]}
	for file in *; do
		if grep -q "BEGIN PRIVATE KEY" $file || grep -q "BEGIN ENCRYPTED PRIVATE KEY" $file; then
			echo "Trying private key found in $file"
			hash=($(openssl rsa -in ~/.ssh/id_rsa -pubout | openssl dgst -sha256 -r))
			if [[ "$hash" == "$storedhash" ]]; then
				echo "$file seems to be the right privatekey!"
				openssl rsautl -decrypt -inkey $file -in $backupdir/$keyfile -out $backupdir/key.bin
				if [ $? ]; then
					echo "Successfully decrypted $keyfile with private key $file"
					success=true
					break
				else
					echo "Decryption failed, searching for other private key."
				fi
			fi
		else
			echo "Skipping '$file', no PKCS#8 compatible private key (no 'BEGIN PRIVATE KEY')"
		fi
	done
	if [ "$success" = true ]; then
		break
	fi
done
cd $backupdir
if [ "$success" = true ]; then
	openssl enc -d -aes-256-cbc -iter 1000000  -in $backupdir/$todecrypt.enc -out $backupdir/$todecrypt -pass file:$backupdir/key.bin
	echo "Decryption finished!"
else
	echo "No fitting private key file found!"
fi
