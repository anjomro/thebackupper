# The Backupper
### Quickstart
- Prerequisites: Docker installed and Linux (obviously)
- Configure remote destination with wizard:
  ~~~
	docker run -it --rm \
		--entrypoint "/thebackupper/config.sh" \
		-v /home/$USER/.config/rclone/:/rc \
		anjomro/thebackupper
  ~~~
  - Your config file is generated in `~/.config/rclone/rclone.conf`

- Private/Public Key File: Needs to be compliant with PKCS#8, mount public key.
  - A PKCS#8 compliant public key has `BEGIN PUBLIC KEY` in the header
  - Private/Public Key-Pair can be generated like this:
    ~~~
    openssl genpkey -algorithm RSA -out private_key.pem -pkeyopt rsa_keygen_bits:4096
    openssl rsa -pubout -in private_key.pem -out public_key.pem
    ~~~
##### Docker Options:

You need to modify the paths to fit your files and can edit the names to your taste.
- Environment Variables
  - remotepath
    - Where on the server do you want to store your Backups?
  - remote
    - Needs to match the name of the remote location you configured with `rclone config`
  - name
    - Just give the backup a name, will appear in folder/filename
- volumes
  - Backup Paths:
    - Just mount everything you want to backup inside of /backup/ or subdirectories
  - Remote config
    - Mount config file for rclone (generated earlier) at `/rc/rclone.conf`
  - Public Key(s)
    - Mount Public Keys in folder `/pub/`
    - The Key of the Backup is encrypted with each pubkey, so each private key can decrypt the Backup
    - If you dont whish to encrypt your Backup just don't mount any public keys.

Example Command:
~~~
docker run --rm \
	-e remotepath=Backup/TheBackupper/ \
	-e remote=arbitraryconfigname
	-e name=myserver
	-v /path/to/backup:/backup/A/ \
	-v /another/backup:/backup/B/ \
	-v /home/$USER/.config/rclone/rclone.conf:/rc/rclone.conf \
	-v /public/key.pem:/pub/ \
	anjomro/thebackupper

~~~
#### Decrypt Backup
- Access backup folder with bash
- Run `chmod +x decryptBackup.sh`
- Change default private key location (`~/.ssh/id_rsa`) to your own location in `decryptBackup`
- Execute it: `./decryptBackup.sh`

#### Build yourself (if you're paranoid):
Just run `./build_image` :)
