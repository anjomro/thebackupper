FROM alpine
WORKDIR /thebackupper
RUN apk update && \	
	apk add bash openssl rclone zip && \
	mkdir /backup/ && \
	mkdir /pub/ && \
	mkdir /rc/
COPY src /thebackupper/
ENTRYPOINT bash -c "/thebackupper/start.sh"
