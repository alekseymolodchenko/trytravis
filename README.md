## Remotes 

```
bastion_IP = 35.206.191.187
someinternalhost_IP = 10.132.0.3
testapp_IP = 35.204.237.177
testapp_port = 9292
```

## Настройка ssh bastion
#### 1. Подключение к someinternalhost одной командой

- ##### C использованием Pseudo-terminal

```
ssh -tt -A -i ~/.ssh/gcp_appuser gcp_appuser@35.206.191.187 ssh 10.132.0.3
```

- ##### C использованием ProxyCommand

```
ssh -o ProxyCommand='ssh -A -i ~/.ssh/gcp_appuser -W %h:%p gcp_appuser@35.206.191.187' 10.132.0.3
```

- ##### C Использованием ProxyJump

```
ssh -i ~/.ssh/gcp_appuser -A -J gcp_appuser@35.206.191.187 10.132.0.3
```

#### 2. Подключение к someinternalhost использованием alias-a

В файл-конфигурации ~/.ssh/config внести следующие настройки

```
Host bastion
User gcp_appuser
Hostname 35.206.191.187
IdentityFile ~/.ssh/gcp_appuser

Host someinternalhost
HostName 10.132.0.3
User gcp_appuser
ProxyCommand ssh bastion -W %h:%p
IdentityFile ~/.ssh/gcp_appuser
```

Команда подключения

```
ssh someinternalhost
```

## Настройка OpenVPN
#### 1. На bastion host создаем файл установки vpn-сервера setupvpn.sh

```
#!/bin/bash
echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.4.list
echo "deb http://repo.pritunl.com/stable/apt xenial main" > /etc/apt/sources.list.d/pritunl.list
apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 0C49F3730359A14518585931BC711F9BA15703C6
apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7568D9BB55FF9E5287D586017AE645C0CF8E292A
apt-get --assume-yes update
apt-get --assume-yes upgrade
apt-get --assume-yes install pritunl mongodb-org
systemctl start pritunl mongod
systemctl enable pritunl mongod
```

#### 2. Делаем файл исполняемым и запускаем

```
chmod +x ~/setupvpn.sh
./setupvpn.sh
```

#### 3. Настраиваем сервер pritunl
* Добавляем организацию
* Добавляем пользователя
* Добавляем Сервер
* Привязываем сервер к организации

## Работа с CGP 
#### 1. Создание истанса с использованием gcloud

```
gcloud compute instances create reddit-app\
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --zone europe-west3-a \
  --tags puma-server \
  --restart-on-failure
```

Просмотреть список созданых инстансов можно командой

```
gcloud compute instances list
```

#### 2. Создание истанса с использованием gcloud с ключем startup-script

```
gcloud compute instances create reddit-app \
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --zone europe-west3-a \
  --tags puma-server \
  --restart-on-failure \
  --metadata startup-script='#! /bin/bash
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
    sudo bash -c \"echo \"deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse\" > /etc/apt/sources.list.d/mongodb-org-3.2.list\"
    sudo apt update
    sudo apt install -y mongodb-org ruby-full ruby-bundler build-essential
    sudo systemctl start mongod
    sudo systemctl enable mongod
    git clone -b monolith https://github.com/express42/reddit.git
    cd reddit && bundle install
    puma -d'
```

#### 3. Создание истанса с использованием gcloud с ключем startup-script-url
```
gcloud compute instances create reddit-app \
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --zone europe-west3-a \
  --tags puma-server \
  --restart-on-failure \
  --metadata startup-script-url=https://raw.githubusercontent.com/Otus-DevOps-2018-11/alekseymolodchenko_infra/master/startup.sh
```

#### 4. Добавление правила default-puma-server с использование gcloud 

```
gcloud compute firewall-rules create puma-default-server --allow tcp:9292 \
    --description "Allow incoming traffic on TCP port 9292 for Reddit App" \
    --direction=INGRESS \
    --target-tags="puma-server"
```

Просмотреть список правил firewall'a можно командой

```
gcloud compute firewall-rules list
```

## Работа с HashiCorp Packer 
#### 1. Создание образа reddit-base

ubuntu16.json
```
{
  "variables": {
    "gcp_project_id": null,
    "gcp_source_image_family": null,
    "gcp_machine_type": "f1-micro"
  },

  "sensitive-variables": ["gcp_project_id", "gcp_source_image_family"],

  "builders": [{
    "type": "googlecompute",
    "project_id": "{{user `gcp_project_id`}}",
    "image_name": "reddit-base-{{timestamp}}",
    "image_family": "reddit-base",
    "source_image_family": "{{user `gcp_source_image_family`}}",
    "image_description": "Reddit App Base Image",
    "machine_type": "{{user `gcp_machine_type`}}",
    "disk_size": "10",
    "disk_type": "pd-standard",
    "network": "default",
    "tags": "reddit-base,reddit-image",
    "zone": "europe-west1-b",
    "ssh_username": "appuser"
  }],

  "provisioners": [{
    "type": "shell",
    "scripts": [
      "scripts/install_ruby.sh",
      "scripts/install_mongodb.sh"
    ],
    "execute_command": "sudo {{.Path}}"
  }]
}
```

Собрать образ reddit-base
```
packer build -var-file=variables.json ubuntu16.json
```

#### 2. Создание образа immutable reddit-full на основании reddit-base

immutable.json
```
{
  "variables": {
    "gcp_project_id": null,
    "gcp_source_image_family": null,
    "gcp_machine_type": "f1-micro"
  },

  "sensitive-variables": ["gcp_project_id", "gcp_source_image_family"],

  "builders": [{
    "type": "googlecompute",
    "project_id": "{{user `gcp_project_id`}}",
    "image_name": "reddit-full-{{timestamp}}",
    "image_family": "reddit-full",
    "image_description": "Reddit App Immutable Image",
    "source_image_family": "reddit-base",
    "zone": "europe-west1-b",
    "ssh_username": "appuser",
    "machine_type": "{{user `gcp_machine_type`}}",
    "network": "default",
    "disk_size": "10",
    "disk_type": "pd-standard",
    "tags": "reddit-immutable,reddit-image"
  }],

  "provisioners": [{
      "type": "file",
      "source": "files/redditapp.service",
      "destination": "/tmp/redditapp.service"
    },
    {
      "type": "shell",
      "script": "files/deploy_app.sh",
      "execute_command": "sudo {{.Path}}"
    }
  ]
}
```

Собрать образ reddit-full
```
packer build \ 
  -var 'gcp_project_id=infra-1234567' \
  -var 'gcp_source_image_family=reddit-full' \
  immutable.json
```


