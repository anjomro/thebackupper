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
if [[ -f "/public_key.pem" ]]; then
	if grep "BEGIN PUBLIC KEY" /public_key.pem > /dev/null
	then
		./encrypt.sh $backupname
		backupname=$nameprefix-backup.zip.enc
	else
		echo "Not the right public key format, must be provided as PKCS8 !"
	fi
fi

if [[ -v $remotepath ]]; then
	$remotepath=/
fi

if [[ -v remote ]]; then
	if [[ -f "/remote.conf" ]]; then
		echo "Uploading to $remote"
		echo "#!/bin/bash" > decryptBackup.sh
		echo "todecrypt=$originalbackupname" >> decryptBackup.sh
		cat decrypt.sh >> decryptBackup.sh
		chmod +x decryptBackup.sh
		rclone --config=/remote.conf copy /thebackupper/key.bin.enc $remote:$remotepath/$nameprefix/
		rclone --config=/remote.conf copy /thebackupper/$backupname $remote:$remotepath/$nameprefix/
		rclone --config=/remote.conf copy /thebackupper/decryptBackup.sh $remote:$remotepath/$nameprefix/
		echo "Upload finished!"
	else
		echo "No config file mounted!"
		callhelp
	fi
else
	echo "No remote specified!"
	callhelp
fi
