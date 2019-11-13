# syntax=docker/dockerfile:experimental
FROM --platform=${TARGETPLATFORM:-linux/amd64} alpine:3.10

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

ARG TARGETPLATFORM
ARG BUILDPLATFORM
RUN printf "I am running on ${BUILDPLATFORM:-linux/amd64}, building for ${TARGETPLATFORM:-linux/amd64}\n$(uname -a)\n"

LABEL maintainer="CrazyMax" \
  org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.name="rrdcached" \
  org.label-schema.description="RRDcached" \
  org.label-schema.version=$VERSION \
  org.label-schema.url="https://github.com/crazy-max/docker-rrdcached" \
  org.label-schema.vcs-ref=$VCS_REF \
  org.label-schema.vcs-url="https://github.com/crazy-max/docker-rrdcached" \
  org.label-schema.vendor="CrazyMax" \
  org.label-schema.schema-version="1.0"

ENV RRDCACHED_VERSION="1.7.2" \
  TZ="UTC" \
  PUID="1000" \
  PGID="1000"

COPY entrypoint.sh /entrypoint.sh
COPY assets/ /

RUN apk add --update --no-cache \
    rrdtool-cached=${RRDCACHED_VERSION}-r0 \
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

HEALTHCHECK --interval=10s --timeout=5s \
  CMD echo PING | nc 127.0.0.1 42217 | grep PONG || exit 1
