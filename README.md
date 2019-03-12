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
* Удалена директория /root/.bundle;
* Удалены зависимости для билда.
```

<details><summary>Результат</summary>

```
$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
amolodchenko/ui     2.5                 e668864b5709        10 seconds ago      38.5MB
amolodchenko/ui     2.1                 d4c8a71d4084        23 minutes ago      209MB
amolodchenko/ui     2.0                 3b2ec8ad8887        35 minutes ago      445MB
amolodchenko/ui     1.0                 d005d8fd3f20        8 hours ago         767MB
```
</details>

### Создание Docker Volume

```
$ docker volume create reddit_db
```

<details><summary>Результат</summary>

```
$ docker volume ls
DRIVER              VOLUME NAME
local               0bebeee2b1f9760c6555c2c5b3c8aa7e9da6c11abc93cebd085170efc2d6f169
local               4af32e3d381086d9536adc2809b89e5cf6123c082c9b5384ef57f3787c08cebe
local               6963a90468a93a613933b2c4861571324016c7988e3044066bfa916ddd4b021e
local               a6c7df89ff00f5e953fa857c2b878702375c9930fc6473ee4c9838e751eb3883
local               aa811515f31925a9c3607c563780168d975b8066901eb0fff6af3df1d5c5b3ec
local               ab14d831a699d183ff9fe9637c532b634fd3d79696675abca57bba96de7dab74
local               reddit_db
```
</details>

</details>

## HW #15 - Работа с сетью в Docker

<details>
  <summary>Результаты</summary>

### Запуск контейнера с использованием none-драйвера

<details><summary>Cодержимое</summary>

```
$ docker run -ti --rm --network none joffotron/docker-net-tools -c ifconfig
Unable to find image 'joffotron/docker-net-tools:latest' locally
latest: Pulling from joffotron/docker-net-tools
3690ec4760f9: Pull complete
0905b79e95dc: Pull complete
Digest: sha256:5752abdc4351a75e9daec681c1a6babfec03b317b273fc56f953592e6218d5b5
Status: Downloaded newer image for joffotron/docker-net-tools:latest
lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
```
</details>

### Запуск контейнера в сетевом пространстве docker-хоста

<details><summary>Cодержимое</summary>

```
$ docker run -ti --rm --network host joffotron/docker-net-tools -c ifconfig
br-3dad778da17e Link encap:Ethernet  HWaddr 02:42:F7:10:5C:BB
          inet addr:172.18.0.1  Bcast:172.18.255.255  Mask:255.255.0.0
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

docker0   Link encap:Ethernet  HWaddr 02:42:22:23:E5:3C
          inet addr:172.17.0.1  Bcast:172.17.255.255  Mask:255.255.0.0
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

ens4      Link encap:Ethernet  HWaddr 42:01:0A:84:00:0C
          inet addr:10.132.0.12  Bcast:10.132.0.12  Mask:255.255.255.255
          inet6 addr: fe80::4001:aff:fe84:c%32585/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1460  Metric:1
          RX packets:765 errors:0 dropped:0 overruns:0 frame:0
          TX packets:671 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:5883244 (5.6 MiB)  TX bytes:92393 (90.2 KiB)

lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1%32585/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
```
</details>

### Запуск контейнера nginx несколько раз

<details><summary>Cодержимое</summary>

```
$ docker run --network host -d nginx
В docker ps только один контейнер, потому что порт уже занят и все последующие падают с ошибкой
Проверит можно командой docker logs <container_id>
docker logs 0e15ceaca53920aeb1cb7647a849e6179139461c3e4b06d70d438cb8b923c45f
[emerg] 1#1: bind() to 0.0.0.0:80 failed (98: Address already in use)
nginx: [emerg] bind() to 0.0.0.0:80 failed (98: Address already in use)
```
</details>

### Cоздание bridge-сети

<details><summary>Cодержимое</summary>

```
docker network create reddit
```
</details>

### Запуск приложения с использованием bridge-сети

<details><summary>Cодержимое</summary>

```
$ docker run -d --network=reddit mongo:latest
bfc0824330cd88f77646caabc6b033231f4e4cf73343429e2bb68e6e9f8aee5e
$ docker run -d --network=reddit amolodchenko/post:1.0
64ee92dcb85c86df2aabdc6bae80f14775a88a72195e39b714863b9d2dfe28db
$ docker run -d --network=reddit amolodchenko/comment:1.0
0e252769d59b6eb86431d5a5a3c52abbb2be61ede1c760d6c821df9b384b8be9
$ docker run -d --network=reddit -p 9292:9292 amolodchenko/ui:1.0
605504f84eafd3e7e9ea5ec2aafd45c88e39091b8a0a2ede5591332d8e3798a7
```
</details>

### Запуск контейнеров с алиасами

<details><summary>Cодержимое</summary>

```
$ docker run -d --network=reddit --network-alias=post_db --network-alias=comment_db mongo:latest
7bdf54f32947a146802411972a50b2ddabf51714026c62420fbb4972f71e7b4e
$ docker run -d --network=reddit --network-alias=post amolodchenko/post:1.0
f3d1cc7d889dfee8a4578f95e5c54f4086e8b0817b5c90e080557f7e768c44d1
$ docker run -d --network=reddit --network-alias=comment amolodchenko/comment:1.0
0e4d5b1648af77619278ced1ca57816fdd76166ace601cad90c2b8fe67019577
$ docker run -d --network=reddit -p 9292:9292 amolodchenko/ui:1.0
8a2cff03b56346ef0339f7b0aca955ea61bb0f515950749d028a498eb58d13a6
```
</details>

### Запуск приложения в 2-х bridge сетях
<details><summary>Cодержимое</summary>

```
$ docker network create back_net --subnet=10.0.2.0/24
db0befca59c8edd5b1cf00dd2a07272de6b55c8e3fab0775911062760f4f002e
$ docker network create front_net --subnet=10.0.1.0/24
8c9c600a4873cadf9a1b9f174974e38048b1b544f29d9bec0927859fc143ca14

$ docker run -d --network=front_net -p 9292:9292 --name ui amolodchenko/ui:1.0
33fdbfa5df0e11441e82f03205e23ab25f2294a61f452eda719de58c65ad9275
$ docker run -d --network=back_net --name comment amolodchenko/comment:1.0
6b79981a7bb35f8f331e73dd3ea67b20d1cb75bed5c2eecb4a4eab8c4f6569ce
$ docker run -d --network=back_net --name post amolodchenko/post:1.0
f93b671fc0704ec7383ed9c859a5768ba34a6e8de9482086648c17ec3db6eab6
$ docker run -d --network=back_net --name mongo_db --network-alias=post_db --network-alias=comment_db mongo:latest
9b9f7c50a2c0b714ff7506626c99ae745205ce319e7f7493538bee88bd3d6cae
```
</details>

### Подключение контейнеров к другой сети
<details><summary>Cодержимое</summary>

```
$ docker network connect front_net post
$ docker network connect front_net comment
```
</details>

### Cетевой стек на хосте с docker
<details><summary>Cодержимое</summary>

```
$ sudo docker network ls
NETWORK ID          NAME                DRIVER              SCOPE
db0befca59c8        back_net            bridge              local
0c738e867b94        bridge              bridge              local
8c9c600a4873        front_net           bridge              local
34a31b94d2c3        host                host                local
c3b5e1da3ced        none                null                local
3dad778da17e        reddit              bridge              local
```
</details>

### Список bridge-интерфейсов на docker-хосте
<details><summary>Cодержимое</summary>

```
$ sudo ifconfig | grep br
br-3dad778da17e Link encap:Ethernet  HWaddr 02:42:f7:10:5c:bb
br-8c9c600a4873 Link encap:Ethernet  HWaddr 02:42:bd:c8:6d:12
br-db0befca59c8 Link encap:Ethernet  HWaddr 02:42:db:8d:d1:44
```
</details>

### Информация по bridge-интерфейсу br-db0befca59c8
<details><summary>Cодержимое</summary>

```
$ brctl show br-db0befca59c8
bridge name	bridge id		STP enabled	interfaces
br-db0befca59c8		8000.0242db8dd144	no		veth0c218a7
							veth3306c08
							veth3b12803
```
</details>

### Правила iptables
<details><summary>Cодержимое</summary>

```
$ sudo iptables -nL -t nat
Chain PREROUTING (policy ACCEPT)
target     prot opt source               destination
DOCKER     all  --  0.0.0.0/0            0.0.0.0/0            ADDRTYPE match dst-type LOCAL

Chain INPUT (policy ACCEPT)
target     prot opt source               destination

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination
DOCKER     all  --  0.0.0.0/0           !127.0.0.0/8          ADDRTYPE match dst-type LOCAL

Chain POSTROUTING (policy ACCEPT)
target     prot opt source               destination
MASQUERADE  all  --  10.0.1.0/24          0.0.0.0/0
MASQUERADE  all  --  10.0.2.0/24          0.0.0.0/0
MASQUERADE  all  --  172.17.0.0/16        0.0.0.0/0
MASQUERADE  all  --  172.18.0.0/16        0.0.0.0/0
MASQUERADE  tcp  --  10.0.1.2             10.0.1.2             tcp dpt:9292

Chain DOCKER (2 references)
target     prot opt source               destination
RETURN     all  --  0.0.0.0/0            0.0.0.0/0
RETURN     all  --  0.0.0.0/0            0.0.0.0/0
RETURN     all  --  0.0.0.0/0            0.0.0.0/0
RETURN     all  --  0.0.0.0/0            0.0.0.0/0
DNAT       tcp  --  0.0.0.0/0            0.0.0.0/0            tcp dpt:9292 to:10.0.1.2:9292
```
</details>

### Изменение префиска проекта в docker-compose
<details><summary>Cодержимое</summary>

```
$ export COMPOSE_PROJECT_NAME=reddiaapp
$ docker-compose up -d

Creating network "reddiaapp_back_net" with the default driver
Creating network "reddiaapp_front_net" with the default driver
Creating volume "reddiaapp_post_db" with default driver
Creating reddiaapp_post_db_1 ... done
Creating reddiaapp_post_1    ... done
Creating reddiaapp_comment_1 ... done
Creating reddiaapp_ui_1      ... done

```
</details>

</details>

## HW #16 - Устройство Gitlab CI. Построение процесса непрерывной интеграции

<details>
  <summary>Результаты</summary>

### Запуск docker-хоста для Gitlab CI

<details><summary>Cодержимое</summary>

```
$ docker-machine create --driver google \
  --google-machine-image https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/family/ubuntu-1604-lts \  --google-machine-type n1-standard-1 \
  --google-disk-size "100" \
  --google-zone europe-west1-c \
  --google-open-port 80/tcp \
  --google-open-port 443/tcp \
  --google-project "docker-1234920" \
  gitlab-ci
```
</details>

### Создание необходимых директорий для установки Gitlab CI

<details><summary>Cодержимое</summary>

```
$ mkdir -p /srv/gitlab/config /srv/gitlab/data /srv/gitlab/logs
```
</details>

### Создание docker-compose.yml для установки Gitlab CI

<details><summary>Cодержимое</summary>

```
web:
  image: 'gitlab/gitlab-ce:latest'
  restart: always
  hostname: 'gitlab.example.com'
  environment:
    GITLAB_OMNIBUS_CONFIG: |
      external_url 'http://34.76.124.163'
  ports:
    - '80:80'
    - '443:443'
    - '2222:22'
  volumes:
    - '/srv/gitlab/config:/etc/gitlab'
    - '/srv/gitlab/logs:/var/log/gitlab'
    - '/srv/gitlab/data:/var/opt/gitlab'
```
</details>

### Добавление remote в микросервисном репозитории

<details><summary>Cодержимое</summary>

```
$ git checkout -b gitlab-ci-1
$ git remote add gitlab http://34.76.124.163/homework/example.git
$ git push gitlab gitlab-ci-1
```

</details>

### Установка Gitlab CI Runner

<details><summary>Cодержимое</summary>

```
$ docker run -d --name gitlab-runner --restart always \
  -v /srv/gitlab-runner/config:/etc/gitlab-runner \
  -v /var/run/docker.sock:/var/run/docker.sock \
  gitlab/gitlab-runner:latest
```

</details>

### Регистрация Gitlab CI Runner

<details><summary>Cодержимое</summary>

```
$ docker exec -it gitlab-runner gitlab-runner register \
  --run-untagged --locked=false --url http://34.76.124.163/ \
  --registration-token "q9SrHzmfKXH7kYN_WBeu" --executor docker \
  --description "Docker in Docker runner" --docker-image "docker:stable"  \
  --docker-privileged
```

</details>


### Добавим в шаг build сборку контейнера с redditapp
<details><summary>Cодержимое</summary>

```
...
build_job:
  stage: build
  image: docker:stable

  script:
    - docker info
    - docker build -t $LATEST_VER .
    - echo "$REGISTRY_PASSWORD" | docker login -u "$REGISTRY_USER" --password-stdin
    - docker push $LATEST_VER && docker image rm $LATEST_VER
...
```

</details>

### Добавим нотификацию в канал Slack
<details><summary>Cодержимое</summary>

```
https://devops-team-otus.slack.com/messages/CF25D53SA/details/
```

</details>

</details>

## HW #17 - Введение в мониторинг. Модели и принципы работы систем мониторинга

<details>
  <summary>Результаты</summary>

### Выполнен мониторинг сервисов comment, post, ui с помощью blackbox экспортера

<details><summary>Cодержимое Dockerfile</summary>

```
FROM prom/blackbox-exporter:v0.14.0
COPY blackbox.yml /etc/blackbox_exporter/

ARG VERSION
ARG BUILD_DATE
ARG VCS_URL
ARG VCS_REF
ARG NAME
ARG VENDOR

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name=$NAME \
      org.label-schema.description="Blackbox Exporter" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/Otus-DevOps-2018-11/alekseymolodchenko_microservices" \
      org.label-schema.vendor=$VENDOR \
      org.label-schema.version=$VERSION \
      org.label-schema.docker.schema-version="1.0" \
      org.label-schema.docker.cmd="docker run -t -i -p 9115:9115 -d amolodchenko/blackbox_exporter"

```
</details>

### Makefile для проекта

<details><summary>Cодержимое Makefile</summary>

```
VERSION := $(shell git describe --tags --abbrev=0)
BUILD_DATE := $(shell date -R)
VCS_URL := $(shell basename `git rev-parse --show-toplevel`)
VCS_REF := $(shell git log -1 --pretty=%h)
NAME := $(shell basename `git rev-parse --show-toplevel`)
VENDOR := $(shell whoami)
DOCKER_HOST := docker-host

version:
	@echo VERSION=${VERSION}
	@echo BUILD_DATE=${BUILD_DATE}
	@echo VCS_URL=${VCS_URL}
	@echo VCS_REF=${VCS_REF}
	@echo NAME=${NAME}
	@echo VENDOR=${VENDOR}

start: create_vm build up show_ip


create-vm:
	docker-machine create --driver google \
	--google-machine-image https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/family/ubuntu-1604-lts \
	--google-machine-type n1-standard-1 \
	--google-zone europe-west1-b ${DOCKER_HOST}
	eval $$(docker-machine env ${DOCKER_HOST})

destroy-vm:
  docker-machine rm ${DOCKER_MACHINE_NAME}

build:
	docker build -t ${USER_NAME}/ui:${VERSION} src/ui/
	docker build -t ${USER_NAME}/post:${VERSION} src/post-py/
	docker build -t ${USER_NAME}/comment:${VERSION} src/comment/
	docker build -t ${USER_NAME}/prometheus:${VERSION} --build-arg VERSION="${VERSION}" \
	--build-arg BUILD_DATE="${BUILD_DATE}" \
	--build-arg VCS_URL="${VCS_URL}" \
	--build-arg VCS_REF="${VCS_REF}" \
	--build-arg NAME="${NAME}" \
	--build-arg VENDOR="${VENDOR}" monitoring/prometheus
	docker build -t ${USER_NAME}/mongodb_exporter:${VERSION} --build-arg VERSION="${VERSION}" \
	--build-arg BUILD_DATE="${BUILD_DATE}" \
	--build-arg VCS_URL="${VCS_URL}" \
	--build-arg VCS_REF="${VCS_REF}" \
	--build-arg NAME="${NAME}" \
	--build-arg VENDOR="${VENDOR}" monitoring/mongodb_exporter
	docker build -t ${USER_NAME}/blackbox_exporter:${VERSION} --build-arg VERSION="${VERSION}" \
	--build-arg BUILD_DATE="${BUILD_DATE}" \
	--build-arg VCS_URL="${VCS_URL}" \
	--build-arg VCS_REF="${VCS_REF}" \
	--build-arg NAME="${NAME}" \
	--build-arg VENDOR="${VENDOR}" monitoring/blackbox_exporter

build-ui:
	docker build -t ${USER_NAME}/ui:${VERSION} src/ui/

build-post:
	docker build -t ${USER_NAME}/post:${VERSION} src/post-py/

build-comment:
	docker build -t ${USER_NAME}/comment:${VERSION} src/comment/

build-prometheus:
	docker build -t ${USER_NAME}/prometheus:${VERSION} --build-arg VERSION="${VERSION}" \
	--build-arg BUILD_DATE="${BUILD_DATE}" \
	--build-arg VCS_URL="${VCS_URL}" \
	--build-arg VCS_REF="${VCS_REF}" \
	--build-arg NAME="${NAME}" \
	--build-arg VENDOR="${VENDOR}" monitoring/prometheus

build-mongodb-exporter:
	docker build -t ${USER_NAME}/mongodb_exporter:${VERSION} --build-arg VERSION="${VERSION}" \
	--build-arg BUILD_DATE="${BUILD_DATE}" \
	--build-arg VCS_URL="${VCS_URL}" \
	--build-arg VCS_REF="${VCS_REF}" \
	--build-arg NAME="${NAME}" \
	--build-arg VENDOR="${VENDOR}" monitoring/mongodb_exporter

build-blackbox-exporter:
	docker build -t ${USER_NAME}/blackbox_exporter:${VERSION} --build-arg VERSION="${VERSION}" \
	--build-arg BUILD_DATE="${BUILD_DATE}" \
	--build-arg VCS_URL="${VCS_URL}" \
	--build-arg VCS_REF="${VCS_REF}" \
	--build-arg NAME="${NAME}" \
	--build-arg VENDOR="${VENDOR}" monitoring/blackbox_exporter

login:
	docker login -u ${USER_NAME}

push: login
	docker push ${USER_NAME}/ui:${VERSION}
	docker push ${USER_NAME}/ui:latest
	docker push ${USER_NAME}/post:${VERSION}
	docker push ${USER_NAME}/post:latest
	docker push ${USER_NAME}/comment:${VERSION}
	docker push ${USER_NAME}/comment:latest
	docker push ${USER_NAME}/prometheus:${VERSION}
	docker push ${USER_NAME}/prometheus:latest
	docker push ${USER_NAME}/mongodb_exporter:${VERSION}
	docker push ${USER_NAME}/mongodb_exporter:latest
	docker push ${USER_NAME}/blackbox_exporter:${VERSION}
	docker push ${USER_NAME}/blackbox_exporter:latest

push-ui: login
	docker push ${USER_NAME}/ui:${VERSION}
	docker push ${USER_NAME}/ui:latest

push-post: login
	docker push ${USER_NAME}/post:${VERSION}
	docker push ${USER_NAME}/post:latest

push-comment: login
	docker push ${USER_NAME}/comment:${VERSION}
	docker push ${USER_NAME}/comment:latest

push-prometheus: login
	docker push ${USER_NAME}/prometheus:${VERSION}
	docker push ${USER_NAME}/prometheus:latest

push-mongodb-exporter: login
	docker push ${USER_NAME}/mongodb_exporter:${VERSION}
	docker push ${USER_NAME}/mongodb_exporter:latest

push-blackbox-exporter: login
	docker push ${USER_NAME}/blackbox_exporter:${VERSION}
	docker push ${USER_NAME}/blackbox_exporter:latest

up: down
	cd docker/ ; docker-compose up -d
down:
	cd docker/ ; docker-compose down

show-ip:
	@echo ${DOCKER_HOST} ip-address: $(shell docker-machine ip ${DOCKER_HOST})


```
</details>

</details>
