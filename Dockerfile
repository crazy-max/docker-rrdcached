FROM --platform=${TARGETPLATFORM:-linux/amd64} crazymax/alpine-s6:3.12

ARG TARGETPLATFORM
ARG BUILDPLATFORM
RUN printf "I am running on ${BUILDPLATFORM:-linux/amd64}, building for ${TARGETPLATFORM:-linux/amd64}\n$(uname -a)\n"

LABEL maintainer="CrazyMax"

ENV RRDCACHED_VERSION="1.7.2" \
  RRDCACHED_RELEASE="r3" \
  TZ="UTC" \
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
