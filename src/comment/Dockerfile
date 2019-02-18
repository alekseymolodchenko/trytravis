FROM alpine:3.9 as builder

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

COPY Gemfile* $APP_HOME/

# https://pkgs.alpinelinux.org/packages
RUN apk --no-cache add make=4.2.1-r2 gcc=8.2.0-r2 libc-dev=0.7.1-r0 \
  ruby=2.5.3-r1 ruby-bundler=1.17.1-r0 ruby-dev=2.5.3-r1 ruby-json=2.5.3-r1 && \
  bundle install && \
  rm -rf /root/.bundle && \
  apk --no-cache del make gcc libc-dev ruby-dev

COPY . $APP_HOME

ENV COMMENT_DATABASE_HOST comment_db
ENV COMMENT_DATABASE comments

CMD ["puma"]
