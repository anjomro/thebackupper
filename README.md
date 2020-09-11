# The Backupper
### Quickstart
- Prerequisites: Docker installed and Linux (obviously)
- Creating a config file:
  - Install rclone (e.g. sudo apt install rclone)
  - Call `rclone config` and follow the steps
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
    - Mount config file for rclone at `/remote.conf`
  - Public Key
    - Mount Public Key at `public_key.pem`
    - If you dont whish to encrypt your Backup just omit the public key

Example Command:
~~~
docker run --rm \
	-e remotepath=Backup/TheBackupper/ \
	-e remote=arbitraryconfigname
	-e name=myserver
	-v /path/to/backup:/backup/A/ \
	-v /another/backup:/backup/B/ \
	-v /home/$USER/.config/rclone/rclone.conf:/remote.conf \
	-v /public/key.pem:/public_key.pem \
	anjomro/thebackupper

~~~
#### Decrypt Backup
- Access backup folder with bash
- Run `chmod +x decryptBackup.sh`
- Change default private key location (`~/.ssh/id_rsa`) to your own location in `decryptBackup`
- Execute it: `./decryptBackup.sh`

#### Build yourself (if you're paranoid):
Just run `./build_image` :)
