#!/bin/bash
cd /thebackupper
nameprefix=$(date +%Y-%m-%d_%H-%M)
callhelp(){
	echo "Please read the readme which can be found at https://github.com/anjomro/thebackupper/"
	echo "Exiting now!"
	exit 1
}
if [[ -v name ]]; then
	nameprefix=$nameprefix+$name
fi

zip -r $nameprefix-backup.zip /backup/
backupname=$nameprefix-backup.zip
originalbackupname=$backupname
encrypted=false
keyfiles=()
pubkeyhashes=()
if [ -z "$(ls -A /pub)" ]; then
	echo "PubKey Directory is empty, Backup won't be encrypted!"
else
		openssl rand -hex -out key.bin 64
		echo -n "Key generated:"
		cat key.bin
		echo -ne "\n"
		openssl enc -aes-256-cbc -iter 1000000  -in $backupname -out $backupname.enc -pass file:./key.bin
		if [[ $? == 0 ]]; then
			echo "Encrypted $backupname, stored as $backupname.enc!"
			#mv $1 ORIGINAL$1
			cd /pub/
			for pubkey in *; do
				echo "Encrypting with $pubkey"
				openssl rsautl -encrypt --inkey /pub/$pubkey -pubin -in /thebackupper/key.bin -out /thebackupper/$pubkey.key.bin.enc
				if [[ $? == 0 ]]; then
					encrypted=true
					keyfiles+=("$pubkey.key.bin.enc")
					hash=($(cat $pubkey | openssl dgst -sha256 -r))
					pubkeyhashes+=(${hash[0]})
				fi
			done
			cd /thebackupper/
			rm key.bin
			echo "Encrypted key.bin with public key as key.bin.enc, deleted key.bin."
			echo "Finished encryption"
			if [ "$encrypted" = true ]; then
				backupname=$nameprefix-backup.zip.enc
			fi
		else
			echo "File encryption has failed! Doing unencrypted Backup!"
		fi
fi

if [[ -v $remotepath ]]; then
	$remotepath=/
fi

if [[ -v remote ]]; then
	if [[ -f "/rc/rclone.conf" ]]; then
		echo "Uploading to $remote"
		if [ "$encrypted" = true ]; then
			echo "#!/bin/bash" > decryptBackup.sh
			echo "keylocation=~/.ssh/  #change to your location if necessary" >> decryptBackup.sh
			echo "todecrypt=$originalbackupname" >> decryptBackup.sh
			echo "keyfiles=( ${keyfiles[@]} )" >> decryptBackup.sh
			echo "pubkeyhashes=( ${pubkeyhashes[@]} )" >> decryptBackup.sh
			cat decrypt.sh >> decryptBackup.sh
			chmod +x decryptBackup.sh
			rclone --config=/rc/rclone.conf copy /thebackupper/decryptBackup.sh $remote:$remotepath/$nameprefix/
			for keyfile in "${keyfiles[@]}"; do
				echo "Uploading Keyfile: $keyfile"
				rclone --config=/rc/rclone.conf copy /thebackupper/$keyfile $remote:$remotepath/$nameprefix/
			done
		fi
		rclone --config=/rc/rclone.conf copy /thebackupper/$backupname $remote:$remotepath/$nameprefix/

		echo "Upload finished!"
	else
		echo "No config file mounted!"
		callhelp
	fi
else
	echo "No remote specified!"
	callhelp
fi
