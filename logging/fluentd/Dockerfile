FROM fluent/fluentd:edge

# Use root account to use apk
USER root

# below RUN includes plugin as examples elasticsearch is not required
# you may customize including plugins as you wish
RUN apk add --no-cache --update --virtual .build-deps \
        build-base ruby-dev \
 && gem install \
        fluent-plugin-elasticsearch --no-rdoc --no-ri --version 3.3.3 \
 && gem install \
        fluent-plugin-grok-parser --no-rdoc --no-ri --version 2.5.0 \
 && gem sources --clear-all \
 && apk del .build-deps \
 && rm -rf /home/fluent/.gem/ruby/2.5.0/cache/*.gem

COPY fluent.conf /fluentd/etc
USER fluent

ARG VERSION
ARG BUILD_DATE
ARG VCS_URL
ARG VCS_REF
ARG NAME
ARG VENDOR

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name=$NAME \
      org.label-schema.description="Fluentd: Unified Logging Layer" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/Otus-DevOps-2018-11/alekseymolodchenko_microservices" \
      org.label-schema.vendor=$VENDOR \
      org.label-schema.version=$VERSION \
      org.label-schema.docker.schema-version="1.0" \
      org.label-schema.docker.cmd="run -d -p 24224:24224 -p 24224:24224/udp -v /data:/fluentd/log amolodchenko/fluentd"
