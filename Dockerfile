FROM alpine
WORKDIR /thebackupper
COPY src /thebackupper/
RUN apk add openssl rclone && mkdir /thebackupper/tobackup/
ENTRYPOINT /thebackupper/src/start.sh
