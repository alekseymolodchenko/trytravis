[![Build Status](https://travis-ci.com/Otus-DevOps-2018-11/alekseymolodchenko_microservices.svg?branch=master)](https://travis-ci.com/Otus-DevOps-2018-11/alekseymolodchenko_microservices)
---

## HW #12 - знакомство с Docker

<details>
  <summary>Результаты</summary>

* Узнать версию docker

docker version
```
  Client: Docker Engine - Community
 Version:           18.09.1
 API version:       1.39
 Go version:        go1.10.6
 Git commit:        4c52b90
 Built:             Wed Jan  9 19:33:12 2019
 OS/Arch:           darwin/amd64
 Experimental:      false

Server: Docker Engine - Community
 Engine:
  Version:          18.09.1
  API version:      1.39 (minimum version 1.12)
  Go version:       go1.10.6
  Git commit:       4c52b90
  Built:            Wed Jan  9 19:41:49 2019
  OS/Arch:          linux/amd64
  Experimental:     true

```

* Запускаем контейнер из образа hello-world

docker run hello-world
```
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
1b930d010525: Pull complete
Digest: sha256:2557e3c07ed1e38f26e389462d03ed943586f744621577a99efb77324b0fe535
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/
```

* Получить список запущенных контейнеров

docker ps
```
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
```

* Получить список всех контейнеров

docker ps -a
```
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                     PORTS               NAMES
03839c687548        hello-world         "/hello"            2 minutes ago       Exited (0) 2 minutes ago                       friendly_hypatia
```

* Получить список образов

docker images
```
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
hello-world         latest              fce289e99eb9        5 weeks ago         1.84kB
```

* Запустить контейнер в интерактивном режиме

docker run -it ubuntu:16.04 /bin/bash
```
Unable to find image 'ubuntu:16.04' locally
16.04: Pulling from library/ubuntu
7b722c1070cd: Already exists
5fbf74db61f1: Already exists
ed41cb72e5c9: Already exists
7ea47a67709e: Already exists
Digest: sha256:e4a134999bea4abb4a27bc437e6118fdddfb172e1b9d683129b74d254af51675
Status: Downloaded newer image for ubuntu:16.04
```

* Получить список всех контейнеров и отформатировать результат в нужном формате

docker ps -a --format "table {{.ID}}\t{{.Image}}\t{{.CreatedAt}}\t{{.Names}}"
```
CONTAINER ID        IMAGE               CREATED AT                      NAMES
1a299e1dd3bf        ubuntu:16.04        2019-02-09 15:38:19 +0300 MSK   recursing_merkle
3f6da034a912        ubuntu:16.04        2019-02-09 15:36:41 +0300 MSK   tender_panini
03839c687548        hello-world         2019-02-09 15:32:10 +0300 MSK   friendly_hypatia
```

* Запусить bash в контейнере 1a299e1dd3bf

docker exec -it 1a299e1dd3bf bash

```
root@1a299e1dd3bf:/# ps axf
  PID TTY      STAT   TIME COMMAND
   10 pts/1    Ss     0:00 bash
   19 pts/1    R+     0:00  \_ ps axf
    1 pts/0    Ss+    0:00 /bin/bash
root@1a299e1dd3bf:/# exit
```

* Cоздание образа из существующего контейнера

docker commit 1a299e1dd3bf alekseymolodchenko/ubuntu-tmp-file
```
sha256:d98bc1bea600e7dc39f7c50a09deffc15b1f6d3b4fe0d6c79f6409da8ba0ec8c
```

* Список доступных образов после коммита

docker images
```
REPOSITORY TAG IMAGE ID
CREATED SIZE
yourname/ubuntu-tmp-file latest c9b7e0f6b390 3
seconds ago 122MB
```

* Инфомация о занимаемом дисковом пространстве образами, контейнерами и волюмами

docker system df
```
TYPE                TOTAL               ACTIVE              SIZE                RECLAIMABLE
Images              3                   2                   117.2MB             117.2MB (99%)
Containers          4                   1                   232B                137B (59%)
Local Volumes       20                  0                   265.5MB             265.5MB (100%)
Build Cache         0                   0                   0B                  0B
```
</details>

## HW #13 - Docker контейнеры

<details>
  <summary>Результаты</summary>

### Создан Dockerfile в директории infra

<details><summary>Cодержимое</summary>

```
FROM ubuntu:16.04

RUN apt-get update && apt-get install -y mongodb-server ruby-full ruby-dev build-essential git
RUN gem install bundler
RUN git clone -b monolith https://github.com/express42/reddit.git

COPY mongod.conf /etc/mongod.conf
COPY db_config /reddit/db_config
COPY start.sh /start.sh

RUN cd /reddit && bundle install
RUN chmod 0777 /start.sh

CMD ["/start.sh"]
```
</details>


### Создание docker-machine

```
docker-machine create --driver google \
 --google-machine-image https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/family/ubuntu-1604-lts \
 --google-machine-type n1-standard-1 \
 --google-zone europe-west1-c \
 docker-host
```

<details>
  <summary>Результаты</summary>

```
Creating CA: /Users/oleksiimolodchenko/.docker/machine/certs/ca.pem
Creating client certificate: /Users/oleksiimolodchenko/.docker/machine/certs/cert.pem
Running pre-create checks...
(docker-host) Check that the project exists
(docker-host) Check if the instance already exists
Creating machine...
(docker-host) Generating SSH Key
(docker-host) Creating host...
(docker-host) Opening firewall ports
(docker-host) Creating instance
(docker-host) Waiting for Instance
(docker-host) Uploading SSH Key
Waiting for machine to be running, this may take a few minutes...
Detecting operating system of created instance...
Waiting for SSH to be available...
Detecting the provisioner...
Provisioning with ubuntu(systemd)...
Installing Docker...
Copying certs to the local machine directory...
Copying certs to the remote machine...
Setting Docker configuration on the remote daemon...
Checking connection to Docker...
Docker is up and running!
To see how to connect your Docker Client to the Docker Engine running on this virtual machine, run: docker-machine env docker-host
```
</details>

### Просмотр доступных docker хостов

```
docker-machine ls
```
<details><summary>Результаты</summary>

```
NAME          ACTIVE   DRIVER   STATE     URL                        SWARM   DOCKER     ERRORS
docker-host   -        google   Running   tcp://35.205.105.23:2376           v18.09.2
```
</details>

### Просмотр переменных окружения

```
docker env docker-host
```

<details><summary>Результаты</summary>

```
export DOCKER_TLS_VERIFY="1"
export DOCKER_HOST="tcp://35.205.105.23:2376"
export DOCKER_CERT_PATH="/Users/oleksiimolodchenko/.docker/machine/machines/docker-host"
export DOCKER_MACHINE_NAME="docker-host"
# Run this command to configure your shell:
# eval $(docker-machine env docker-host)
```
</details>

### Билд образа

```
docker build -t reddit:latest .
```

<details><summary>Результаты</summary>

```
Successfully built f1c893e2d5c2
Successfully tagged reddit:latest
```
</details>

### Просмотр образов после билда

```
docker ls -a
```

<details><summary>Результаты</summary>

```
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
<none>              <none>              46b3004ea112        3 minutes ago       678MB
reddit              latest              2e7fc873dd73        3 minutes ago       678MB
<none>              <none>              e06864f9cb52        3 minutes ago       678MB
<none>              <none>              50ae28c86fdc        4 minutes ago       639MB
<none>              <none>              56e70902af5a        4 minutes ago       639MB
<none>              <none>              17f214ca6a47        4 minutes ago       639MB
<none>              <none>              bdb4fcba53ec        4 minutes ago       639MB
<none>              <none>              7cbedbb73ddf        4 minutes ago       638MB
<none>              <none>              ebdede07e55e        4 minutes ago       636MB
<none>              <none>              07f5c8b3ddcb        5 minutes ago       142MB
ubuntu              16.04               7e87e2b3bf7a        3 weeks ago         117MB
```
</details>

### Запуск контейнера

```
docker run --name reddit -d --network=host reddit:latest
```

<details><summary>Результаты</summary>

```
6e5c24dd99234b138002fbee8a7664dc2a7e57f7191e1579762c1a150e53328a
```
</details>

### Просмотр запущенных контейнеров

```
docker container ls
```

<details><summary>Результаты</summary>

```
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
6e5c24dd9923        reddit:latest       "/start.sh"         59 seconds ago      Up 58 seconds                           reddit
```
</details>

### Добавление тега к образу

```
docker tag reddit:latest amolodchenko/otus-reddit:1.0
```

### Пуш образа на Docker Hub

```
docker push amolodchenko/otus-reddit:1.1
```

<details><summary>Результаты</summary>

```
The push refers to repository [docker.io/amolodchenko/otus-reddit]
867f35ec250f: Pushed
a45e832e1613: Pushed
f6acb2b8a963: Pushed
d9707f07272c: Pushed
b695c014824a: Pushed
ab2ba9f9db80: Pushed
1ed07f1969bf: Pushed
ef3b91aa4c43: Pushed
74f5ecde5fa3: Pushed
68dda0c9a8cd: Mounted from library/ubuntu
f67191ae09b8: Mounted from library/ubuntu
b2fd8b4c3da7: Mounted from library/ubuntu
0de2edf7bff4: Mounted from library/ubuntu
1.0: digest: sha256:623ca98dd08175f99f1843623cb061650e7870d8cbf1726ef37f575aa63445f6 size: 3034
```
</details>

</details>

## HW #14 - Docker-образы. Микросервисы

<details>
  <summary>Результаты</summary>

### Скачаем последний образ MongoDB

```
$ docker pull mongo:latest
```

<details><summary>Результат</summary>

```
latest: Pulling from library/mongo
7b722c1070cd: Pull complete
5fbf74db61f1: Pull complete
ed41cb72e5c9: Pull complete
7ea47a67709e: Pull complete
778aebe6fb26: Pull complete
3b4b1e0b80ed: Pull complete
844ccc42fe76: Pull complete
eab01fe8ebf8: Pull complete
e5758d5381b1: Pull complete
dc553720c5c3: Pull complete
67750c781aa2: Pull complete
b00b8942c827: Pull complete
32201bb8ca69: Pull complete
Digest: sha256:002fda672a0d196325a30736d4c80d04adf6f39dd28db41e6799f42844cab7b8
Status: Downloaded newer image for mongo:latest
```
</details>

### Сборка образов post comment ui

```
$ docker build -t amolodchenko/post:1.0 ./post-py
$ docker build -t amolodchenko/comment:1.0 ./comment
$ docker build -t amolodchenko/ui:1.0 ./ui
```

<details><summary>Результат</summary>

```
REPOSITORY             TAG                 IMAGE ID            CREATED             SIZE
amolodchenko/ui        1.0                 f097f6e1a287        29 seconds ago      767MB
amolodchenko/comment   1.0                 c9555708a62f        3 minutes ago       765MB
amolodchenko/post      1.0                 d687efa726cc        5 minutes ago       106MB
```
</details>

### Cоздание сети приложения

```
$ docker network create reddit
$ docker network inspect reddit
```

<details><summary>Результат</summary>

```
[
    {
        "Name": "reddit",
        "Id": "3dad778da17eb6f99688ede2958d39d69c27369d9cc0d92e5192e3f6a27abe42",
        "Created": "2019-02-17T10:54:10.985922986Z",
        "Scope": "local",
        "Driver": "bridge",
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": {},
            "Config": [
                {
                    "Subnet": "172.18.0.0/16",
                    "Gateway": "172.18.0.1"
                }
            ]
        },
        "Internal": false,
        "Attachable": false,
        "Ingress": false,
        "ConfigFrom": {
            "Network": ""
        },
        "ConfigOnly": false,
        "Containers": {
            "3144c1b6f675289024c0f480d96fd0dcafdec7492c67eb446278454be078fba3": {
                "Name": "frosty_kirch",
                "EndpointID": "868b60072fdb11f44ba77c680c4c6341846e0fa5621dac87d4b57aca74de5ffa",
                "MacAddress": "02:42:ac:12:00:03",
                "IPv4Address": "172.18.0.3/16",
                "IPv6Address": ""
            },
            "ae24de46199d57777fcba4d614722096fc405ead14606a2b60a79526d97a45a4": {
                "Name": "naughty_carson",
                "EndpointID": "a6b7757608cb706bd1ce291ef8dc114328ba43ef6189835041ad3c806591f096",
                "MacAddress": "02:42:ac:12:00:02",
                "IPv4Address": "172.18.0.2/16",
                "IPv6Address": ""
            },
            "d8769be40baf52c1d2d78201be23f9a9f9507bb3b813bb94dd583b3f42e5dbea": {
                "Name": "stoic_thompson",
                "EndpointID": "a2ca22304c2752c4b1842a6a5e76bbf6a474c66c0af2c2de48c68f004e398754",
                "MacAddress": "02:42:ac:12:00:04",
                "IPv4Address": "172.18.0.4/16",
                "IPv6Address": ""
            },
            "dd25f842b40088a9c614ae3783f480cf3b08c85d8a12ce6f3dba520307580da6": {
                "Name": "cranky_kilby",
                "EndpointID": "26d6363add1541d6940ee168e3a7dbb428c206ef1b09e7d94dca7b2e6a3a0ca8",
                "MacAddress": "02:42:ac:12:00:05",
                "IPv4Address": "172.18.0.5/16",
                "IPv6Address": ""
            }
        },
        "Options": {},
        "Labels": {}
    }
]
```
</details>

### Запуск контейнеров

```
$ docker run -d --network=reddit --network-alias=post_db --network-alias=comment_db mongo:latest
$ docker run -d --network=reddit --network-alias=post amolodchenko/post:1.0
$ docker run -d --network=reddit --network-alias=comment amolodchenko/comment:1.0
$ docker run -d --network=reddit -p 9292:9292 amolodchenko/ui:1.0
```

<details><summary>Результат</summary>

```
$ docker ps

CONTAINER ID        IMAGE                      COMMAND                  CREATED              STATUS              PORTS                    NAMES
c5437b5330ef        amolodchenko/ui:1.0        "puma"                   About a minute ago   Up About a minute   0.0.0.0:9292->9292/tcp   frosty_diffie
ecc13cc8dd22        amolodchenko/comment:1.0   "puma"                   2 minutes ago        Up 2 minutes                                 silly_newton
7d86eacca531        amolodchenko/post:1.0      "python3 post_app.py"    2 minutes ago        Up 2 minutes                                 determined_rosalind
47f3a78dffd7        mongo:latest               "docker-entrypoint.s…"   4 minutes ago        Up 4 minutes        27017/tcp                heuristic_sanderson
```
</details>

### Изменение network-alias

```
$ docker run -d --network=reddit \
--network-alias=post_db_1 --network-alias=comment_db_1 mongo:latest
$ docker run -d --env "POST_DATABASE_HOST=post_db_1" --network=reddit \
--network-alias=post_1 amolodchenko/post:1.0
$ docker run -d --env "COMMENT_DATABASE_HOST=comment_db_1" --network=reddit \
--network-alias=comment_1 amolodchenko/comment:1.0
$ docker run -d --env "POST_SERVICE_HOST=post_1" --env "COMMENT_SERVICE_HOST=comment_1" --network=reddit \
-p 9292:9292 amolodchenko/ui:1.0
```

<details><summary>Результат</summary>

```
$ docker ps

CONTAINER ID        IMAGE                      COMMAND                  CREATED              STATUS              PORTS                    NAMES
dd25f842b400        amolodchenko/ui:1.0        "puma"                   About a minute ago   Up About a minute   0.0.0.0:9292->9292/tcp   cranky_kilby
d8769be40baf        amolodchenko/comment:1.0   "puma"                   About a minute ago   Up About a minute                            stoic_thompson
3144c1b6f675        amolodchenko/post:1.0      "python3 post_app.py"    About a minute ago   Up About a minute                            frosty_kirch
ae24de46199d        mongo:latest               "docker-entrypoint.s…"   About a minute ago   Up About a minute   27017/tcp
```
</details>

### Изменение network-alias

```
$ docker run -d --network=reddit \
--network-alias=post_db_1 --network-alias=comment_db_1 mongo:latest
$ docker run -d --env "POST_DATABASE_HOST=post_db_1" --network=reddit \
--network-alias=post_1 amolodchenko/post:1.0
$ docker run -d --env "COMMENT_DATABASE_HOST=comment_db_1" --network=reddit \
--network-alias=comment_1 amolodchenko/comment:1.0
$ docker run -d --env "POST_SERVICE_HOST=post_1" --env "COMMENT_SERVICE_HOST=comment_1" --network=reddit \
-p 9292:9292 amolodchenko/ui:1.0
```

<details><summary>Результат</summary>

```
$ docker ps

CONTAINER ID        IMAGE                      COMMAND                  CREATED              STATUS              PORTS                    NAMES
dd25f842b400        amolodchenko/ui:1.0        "puma"                   About a minute ago   Up About a minute   0.0.0.0:9292->9292/tcp   cranky_kilby
d8769be40baf        amolodchenko/comment:1.0   "puma"                   About a minute ago   Up About a minute                            stoic_thompson
3144c1b6f675        amolodchenko/post:1.0      "python3 post_app.py"    About a minute ago   Up About a minute                            frosty_kirch
ae24de46199d        mongo:latest               "docker-entrypoint.s…"   About a minute ago   Up About a minute   27017/tcp
```
</details>

### Оптимизация размера образа ui

```
* Базовый образ Alpine Linux;
*
* Удалены зависимости для билда;


```

<details><summary>Результат</summary>

```
$ docker ps

CONTAINER ID        IMAGE                      COMMAND                  CREATED              STATUS              PORTS                    NAMES
dd25f842b400        amolodchenko/ui:1.0        "puma"                   About a minute ago   Up About a minute   0.0.0.0:9292->9292/tcp   cranky_kilby
d8769be40baf        amolodchenko/comment:1.0   "puma"                   About a minute ago   Up About a minute                            stoic_thompson
3144c1b6f675        amolodchenko/post:1.0      "python3 post_app.py"    About a minute ago   Up About a minute                            frosty_kirch
ae24de46199d        mongo:latest               "docker-entrypoint.s…"   About a minute ago   Up About a minute   27017/tcp
```
</details>


</details>
