FROM prom/alertmanager:v0.14.0
COPY config.yml /etc/alertmanager/

ARG VERSION
ARG BUILD_DATE
ARG VCS_URL
ARG VCS_REF
ARG NAME
ARG VENDOR

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name=$NAME \
      org.label-schema.description="Prometheus Alertmanager" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/Otus-DevOps-2018-11/alekseymolodchenko_microservices" \
      org.label-schema.vendor=$VENDOR \
      org.label-schema.version=$VERSION \
      org.label-schema.docker.schema-version="1.0" \
      org.label-schema.docker.cmd="docker run -t -i -p 3000:3000 -d amolodchenko/alertmanager"
