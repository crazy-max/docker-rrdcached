# syntax=docker/dockerfile:1

ARG RRDCACHED_VERSION=1.9.0
ARG RRDCACHED_RELEASE=r4

FROM alpine:3.22

ENV S6_BEHAVIOUR_IF_STAGE2_FAILS="2" \
  TZ="UTC" \
  PUID="1000" \
  PGID="1000"

ARG RRDCACHED_VERSION
ARG RRDCACHED_RELEASE
RUN apk add --update --no-cache \
    bash \
    rrdtool-cached=${RRDCACHED_VERSION}-${RRDCACHED_RELEASE} \
    s6-overlay \
    shadow \
    tzdata \
  && addgroup -g ${PGID} rrdcached \
  && adduser -D -H -u ${PUID} -G rrdcached -s /bin/sh rrdcached \
  && rm -rf /tmp/*

COPY rootfs /

EXPOSE 42217
WORKDIR /data
VOLUME [ "/data/db", "/data/journal" ]

ENTRYPOINT [ "/init" ]

HEALTHCHECK --interval=10s --timeout=5s --start-period=5m \
  CMD echo PING | nc 127.0.0.1 42217 | grep PONG || exit 1
