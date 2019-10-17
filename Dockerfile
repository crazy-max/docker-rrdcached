# syntax=docker/dockerfile:experimental
FROM --platform=${TARGETPLATFORM:-linux/amd64} alpine:3.10

ARG TARGETPLATFORM
ARG BUILDPLATFORM
RUN printf "I am running on ${BUILDPLATFORM:-linux/amd64}, building for ${TARGETPLATFORM:-linux/amd64}\n$(uname -a)\n"

LABEL maintainer="CrazyMax" \
  org.label-schema.name="rrdcached" \
  org.label-schema.description="RRDcached" \
  org.label-schema.url="https://github.com/crazy-max/docker-rrdcached" \
  org.label-schema.vcs-url="https://github.com/crazy-max/docker-rrdcached" \
  org.label-schema.vendor="CrazyMax" \
  org.label-schema.schema-version="1.0"

ENV RRDCACHED_VERSION="1.7.2"

COPY entrypoint.sh /entrypoint.sh
COPY assets/ /

RUN apk add --update --no-cache \
    rrdtool-cached=${RRDCACHED_VERSION}-r0 \
    shadow \
  && chmod a+x /entrypoint.sh /usr/local/bin/* \
  && addgroup -g 1000 rrdcached \
  && adduser -u 1000 -G rrdcached -h /data -s /sbin/nologin -D rrdcached \
  && rm -rf /tmp/* /var/cache/apk/*

EXPOSE 42217
WORKDIR /data
VOLUME [ "/data/db", "/data/journal" ]

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/usr/local/bin/rrdcached" ]

HEALTHCHECK --interval=10s --timeout=5s \
  CMD echo PING | nc 127.0.0.1 42217 | grep PONG || exit 1
