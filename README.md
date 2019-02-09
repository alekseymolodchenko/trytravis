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

