FROM alpine:latest

RUN apk add --no-cache bash curl unzip rclone

COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD [ "/run.sh" ]
