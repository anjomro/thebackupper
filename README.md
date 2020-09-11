# The Backupper
### Quickstart
* Prerequisites: Docker installed and Linux (obviously)
* Creating a config file:
** Install rclone (e.g. sudo apt install rclone)
** Call `rclone config` and follow the steps
** Your config file is generated in ~/.config/rclone/rclone.conf
* Private/Public Key File: Needs to be compliant with PKCS#8, mount public key.

Command:
'''
docker run \
	--rm
	-e remotepath=Backup/TheBackupper/ \
	-e remote=arbitraryconfigname
	-e name=myserver
	-v /path/to/backup:/backup/A/ \
	-v /another/backup:/backup/B/ \
	-v /home/$USER/.config/rclone/rclone.conf:/remote.conf \
	-v /public/key.pem:/public_key.pem \
	anjomro/thebackupper

'''
#### Build yourself (if you're paranoid):
Just run `./build_image` :)
