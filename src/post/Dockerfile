FROM python:3.6.8-alpine3.8

RUN addgroup -S post && adduser -S -G post post

WORKDIR /app
COPY requirements.txt /app

RUN apk --no-cache add gcc=6.4.0-r9 musl-dev=1.1.19-r10 \
 && pip install -r /app/requirements.txt \
 && rm -rf /root/.cache \
 && rm -rf /app/requirements.txt

COPY helpers.py post_app.py VERSION /app/
RUN chown -R post:post /app

ENV POST_DATABASE_HOST post_db
ENV POST_DATABASE posts

USER post
ENTRYPOINT ["python3", "post_app.py"]
