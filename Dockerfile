FROM alpine
WORKDIR /thebackupper
RUN apk update && \	
	apk add bash openssl rclone zip && \
	mkdir /thebackupper/tobackup/
COPY src /thebackupper/
ENTRYPOINT bash -c "/thebackupper/start.sh"
