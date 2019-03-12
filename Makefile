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
