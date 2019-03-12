FROM golang:1.9 as build

ENV APP_PATH $GOPATH/src/github.com/percona/mongodb_exporter
WORKDIR $APP_PATH

RUN git clone "https://github.com/percona/mongodb_exporter" "$APP_PATH" \
    && go get -d && go build -o /bin/mongodb_exporter \
    && rm -rf "$GOPATH"

FROM alpine:3.9

COPY --from=build /bin/mongodb_exporter /bin/mongodb_exporter

ARG VERSION
ARG BUILD_DATE
ARG VCS_URL
ARG VCS_REF
ARG NAME
ARG VENDOR

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name=$NAME \
      org.label-schema.description="Prometheus Percona MongoDB Exporter" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/Otus-DevOps-2018-11/alekseymolodchenko_microservices" \
      org.label-schema.vendor=$VENDOR \
      org.label-schema.version=$VERSION \
      org.label-schema.docker.schema-version="1.0" \
      org.label-schema.docker.cmd="docker run -t -i -p 9216:9216 -d amolodchenko/mongodb_exporter"

EXPOSE 9216

ENTRYPOINT [ "/bin/mongodb_exporter" ]
