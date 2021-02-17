ARG RRDCACHED_VERSION="1.7.2"
ARG RRDCACHED_RELEASE="r3"

FROM --platform=${TARGETPLATFORM:-linux/amd64} crazymax/alpine-s6:3.12
LABEL maintainer="CrazyMax"

ARG RRDCACHED_VERSION
ARG RRDCACHED_RELEASE

ENV TZ="UTC" \
  PUID="1000" \
  PGID="1000"

RUN apk add --update --no-cache \
    bash \
    rrdtool-cached=${RRDCACHED_VERSION}-${RRDCACHED_RELEASE} \
    shadow \
    su-exec \
    tzdata \
  && addgroup -g ${PGID} rrdcached \
  && adduser -D -H -u ${PUID} -G rrdcached -s /bin/sh rrdcached \
  && rm -rf /tmp/* /var/cache/apk/*

COPY rootfs /

EXPOSE 42217
WORKDIR /data
VOLUME [ "/data/db", "/data/journal" ]

HEALTHCHECK --interval=10s --timeout=5s --start-period=5m \
  CMD echo PING | nc 127.0.0.1 42217 | grep PONG || exit 1
