FROM alpine:latest
LABEL maintainer "John McGonegal <john@plainfast.com>"

RUN apk --no-cache --no-progress add mariadb-client