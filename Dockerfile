FROM alpine:3.9

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

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

ENV RRDCACHED_VERSION="1.7.0"

COPY entrypoint.sh /entrypoint.sh
COPY assets/ /

RUN apk add --update --no-cache \
    rrdtool-cached=${RRDCACHED_VERSION}-r0 \
    shadow \
  && mkdir -p /data \
  && chmod a+x /entrypoint.sh /usr/local/bin/* \
  && addgroup -g 1000 rrdcached \
  && adduser -u 1000 -G rrdcached -h /data -s /sbin/nologin -D rrdcached \
  && chown -R rrdcached. /data \
  && rm -rf /tmp/* /var/cache/apk/*

EXPOSE 42217
WORKDIR /data
VOLUME [ "/data" ]

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/usr/local/bin/rrdcached" ]
