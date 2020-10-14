FROM --platform=${TARGETPLATFORM:-linux/amd64} alpine:3.12

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

ARG TARGETPLATFORM
ARG BUILDPLATFORM
RUN printf "I am running on ${BUILDPLATFORM:-linux/amd64}, building for ${TARGETPLATFORM:-linux/amd64}\n$(uname -a)\n"

LABEL maintainer="CrazyMax" \
  org.opencontainers.image.created=$BUILD_DATE \
  org.opencontainers.image.url="https://github.com/crazy-max/docker-rrdcached" \
  org.opencontainers.image.source="https://github.com/crazy-max/docker-rrdcached" \
  org.opencontainers.image.version=$VERSION \
  org.opencontainers.image.revision=$VCS_REF \
  org.opencontainers.image.vendor="CrazyMax" \
  org.opencontainers.image.title="RRDcached" \
  org.opencontainers.image.description="RRDtool data caching daemon" \
  org.opencontainers.image.licenses="MIT"

ENV RRDCACHED_VERSION="1.7.2" \
  RRDCACHED_RELEASE="r3" \
  TZ="UTC" \
  PUID="1000" \
  PGID="1000"

COPY entrypoint.sh /entrypoint.sh
COPY assets/ /

RUN apk add --update --no-cache \
    rrdtool-cached=${RRDCACHED_VERSION}-${RRDCACHED_RELEASE} \
    shadow \
    su-exec \
    tzdata \
  && chmod a+x /entrypoint.sh /usr/local/bin/* \
  && addgroup -g ${PGID} rrdcached \
  && adduser -D -H -u ${PUID} -G rrdcached -s /bin/sh rrdcached \
  && mkdir -p \
    /data/db \
    /data/journal \
    /etc/rrdcached \
    /var/run/rrdcached \
  && chown -R rrdcached. \
    /data/db \
    /data/journal \
    /etc/rrdcached \
    /var/run/rrdcached \
  && rm -rf /tmp/* /var/cache/apk/*

EXPOSE 42217
WORKDIR /data
VOLUME [ "/data/db", "/data/journal" ]

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/usr/local/bin/rrdcached" ]

HEALTHCHECK --interval=10s --timeout=5s --start-period=5m \
  CMD echo PING | nc 127.0.0.1 42217 | grep PONG || exit 1
