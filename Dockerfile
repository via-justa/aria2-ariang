# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-alpine:3.16

ARG BUILD_DATE
ARG GITHUB_SHA
ARG ARIANG_VERSION=1.3.6

LABEL maintainer="via-justa" \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.name="aria2-ariang" \
    org.label-schema.description="Aria2 downloader and AriaNg web UI Docker image based on linuxserver.io" \
    org.label-schema.version=$ARIANG_VERSION \
    org.label-schema.url="https://github.com/via-justa/aria2-ariang" \
    org.label-schema.license="MIT" \
    org.label-schema.vcs-ref=$GITHUB_SHA \
    org.label-schema.vcs-url="https://github.com/via-justa/aria2-ariang" \
    org.label-schema.vcs-type="Git" \
    org.label-schema.vendor="via-justa" \
    org.label-schema.schema-version="1.0"

# bt trackers from https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_best_ip.txt
# Project url: https://github.com/ngosang/trackerslist
ENV TRACKERS="$(curl -s https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_best_ip.txt | tr '\n\n' ',')"


ADD https://github.com/mayswind/AriaNg/releases/download/${ARIANG_VERSION}/AriaNg-${ARIANG_VERSION}.zip /usr/local/www/ariang/ariang.zip


WORKDIR /usr/local/www/ariang

RUN apk update \
    && apk add --no-cache --update caddy aria2 curl su-exec jq \
    && unzip ariang.zip \
    && rm ariang.zip \
    && chmod -R 755 ./

WORKDIR /aria2

COPY aria2.conf ./conf-copy/aria2.conf
COPY Caddyfile /usr/local/caddy/

# copy local files
COPY root/ /

VOLUME /aria2/data
VOLUME /aria2/conf

# ports and volumes
EXPOSE 8080
EXPOSE 6800

HEALTHCHECK --interval=30s --timeout=30s --start-period=30s --retries=3 CMD curl --fail http://localhost:8080 || exit

VOLUME /config /downloads