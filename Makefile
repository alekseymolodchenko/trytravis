VERSION := $(shell git describe --tags --abbrev=0)
BUILD_DATE := $(shell date -R)
VCS_URL := $(shell basename `git rev-parse --show-toplevel`)
VCS_REF := $(shell git log -1 --pretty=%h)
NAME := $(shell basename `git rev-parse --show-toplevel`)
VENDOR := $(shell whoami)
DOCKER_HOST := docker-host
USER_NAME ?= $(shell echo $USER_NAME)

.PHONY: all version docker-env build up-app up-down show-ip login push-app
all: create-vm build-app build-monitoring push-app push-monitoring up-app show-ip

version:
	@echo VERSION=${VERSION}
	@echo BUILD_DATE=${BUILD_DATE}
	@echo VCS_URL=${VCS_URL}
	@echo VCS_REF=${VCS_REF}
	@echo NAME=${NAME}
	@echo VENDOR=${VENDOR}

create-vm:
	docker-machine create --driver google \
	--google-machine-image https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/family/ubuntu-1604-lts \
	--google-machine-type n1-standard-1 \
	--google-zone europe-west1-b \
	--engine-opt experimental \
	--engine-opt metrics-addr=0.0.0.0:9999 \
	$(DOCKER_HOST)

set-env:
	eval $$(docker-machine env $(DOCKER_HOST))

destroy-vm:
	eval $$(docker-machine env $(DOCKER_HOST)) ; docker-machine rm ${DOCKER_MACHINE_NAME}

build: build-app build-monitoring
build-app: build-ui build-post build-comment
build-monitoring: build-prometheus build-mongodb-exporter build-blackbox-exporter build-alertmanager build-grafana

build-ui:
	eval $$(docker-machine env $(DOCKER_HOST)) ; docker build -t ${USER_NAME}/ui:${VERSION} -t ${USER_NAME}/ui:latest src/ui/

build-post:
	eval $$(docker-machine env $(DOCKER_HOST)) ; docker build -t ${USER_NAME}/post:${VERSION} -t ${USER_NAME}/post:latest src/post-py/

build-comment:
	eval $$(docker-machine env $(DOCKER_HOST)) ; docker build -t ${USER_NAME}/comment:${VERSION} -t ${USER_NAME}/comment:latest src/comment/

build-prometheus:
	eval $$(docker-machine env $(DOCKER_HOST)) ; docker build -t ${USER_NAME}/prometheus:${VERSION} -t ${USER_NAME}/prometheus:latest \
	--build-arg VERSION="${VERSION}" \
	--build-arg BUILD_DATE="${BUILD_DATE}" \
	--build-arg VCS_URL="${VCS_URL}" \
	--build-arg VCS_REF="${VCS_REF}" \
	--build-arg NAME="${NAME}" \
	--build-arg VENDOR="${VENDOR}" monitoring/prometheus

build-alertmanager:
	eval $$(docker-machine env $(DOCKER_HOST)) ; docker build -t ${USER_NAME}/alertmanager:${VERSION} -t ${USER_NAME}/alertmanager:latest \
	--build-arg VERSION="${VERSION}" \
	--build-arg BUILD_DATE="${BUILD_DATE}" \
	--build-arg VCS_URL="${VCS_URL}" \
	--build-arg VCS_REF="${VCS_REF}" \
	--build-arg NAME="${NAME}" \
	--build-arg VENDOR="${VENDOR}" monitoring/alertmanager

build-grafana:
	eval $$(docker-machine env $(DOCKER_HOST)) ; docker build -t ${USER_NAME}/grafana:${VERSION} -t ${USER_NAME}/grafana:latest \
	--build-arg VERSION="${VERSION}" \
	--build-arg BUILD_DATE="${BUILD_DATE}" \
	--build-arg VCS_URL="${VCS_URL}" \
	--build-arg VCS_REF="${VCS_REF}" \
	--build-arg NAME="${NAME}" \
	--build-arg VENDOR="${VENDOR}" monitoring/grafana

build-mongodb-exporter:
	eval $$(docker-machine env $(DOCKER_HOST)) ; docker build -t ${USER_NAME}/mongodb_exporter:${VERSION} -t ${USER_NAME}/mongodb_exporter:latest \
	--build-arg VERSION="${VERSION}" \
	--build-arg BUILD_DATE="${BUILD_DATE}" \
	--build-arg VCS_URL="${VCS_URL}" \
	--build-arg VCS_REF="${VCS_REF}" \
	--build-arg NAME="${NAME}" \
	--build-arg VENDOR="${VENDOR}" monitoring/mongodb_exporter

build-blackbox-exporter:
	eval $$(docker-machine env $(DOCKER_HOST)) ; docker build -t ${USER_NAME}/blackbox_exporter:${VERSION} -t ${USER_NAME}/blackbox_exporter:latest \
	--build-arg VERSION="${VERSION}" \
	--build-arg BUILD_DATE="${BUILD_DATE}" \
	--build-arg VCS_URL="${VCS_URL}" \
	--build-arg VCS_REF="${VCS_REF}" \
	--build-arg NAME="${NAME}" \
	--build-arg VENDOR="${VENDOR}" monitoring/blackbox_exporter

login:
	docker login -u ${USER_NAME}

push: push-app push-monitoring
push-app: push-ui push-post push-comment
push-monitoring: push-prometheus push-mongodb-exporter push-blackbox-exporter push-alertmanager push-grafana

push-ui:
	eval $$(docker-machine env $(DOCKER_HOST)) ; docker login -u ${USER_NAME} ; docker push ${USER_NAME}/ui:${VERSION} ; docker push ${USER_NAME}/ui:latest

push-post:
	eval $$(docker-machine env $(DOCKER_HOST)) ; docker login -u ${USER_NAME} ; docker push ${USER_NAME}/post:${VERSION} ; docker push ${USER_NAME}/post:latest

push-comment:
	eval $$(docker-machine env $(DOCKER_HOST)) ; docker login -u ${USER_NAME} ; docker push ${USER_NAME}/comment:${VERSION} ; docker push ${USER_NAME}/comment:latest

push-prometheus:
	eval $$(docker-machine env $(DOCKER_HOST)) ; docker login -u ${USER_NAME} ; docker push ${USER_NAME}/prometheus:${VERSION} ; docker push ${USER_NAME}/prometheus:latest

push-alertmanager:
	eval $$(docker-machine env $(DOCKER_HOST)) ; docker login -u ${USER_NAME} ; docker push ${USER_NAME}/alertmanager:${VERSION} ; docker push ${USER_NAME}/alertmanager:latest

push-grafana:
	eval $$(docker-machine env $(DOCKER_HOST)) ; docker login -u ${USER_NAME} ; docker push ${USER_NAME}/grafana:${VERSION} ; docker push ${USER_NAME}/grafana:latest

push-mongodb-exporter:
	eval $$(docker-machine env $(DOCKER_HOST)) ; docker login -u ${USER_NAME} ; docker push ${USER_NAME}/mongodb_exporter:${VERSION} ; docker push ${USER_NAME}/mongodb_exporter:latest

push-blackbox-exporter:
	eval $$(docker-machine env $(DOCKER_HOST)) ; docker login -u ${USER_NAME} ; docker push ${USER_NAME}/blackbox_exporter:${VERSION} ; docker push ${USER_NAME}/blackbox_exporter:latest

up-app: down-app
	eval $$(docker-machine env $(DOCKER_HOST)) ; cd docker/ ; docker-compose up -d
down-app:
	eval $$(docker-machine env $(DOCKER_HOST)) ; cd docker/ ; docker-compose down

up-monitoring:
	eval $$(docker-machine env $(DOCKER_HOST)) ; cd docker/ ; docker-compose -f docker-compose-monitoring.yml up -d
down-monitoring:
	eval $$(docker-machine env $(DOCKER_HOST)) ; cd docker/ ; docker-compose -f docker-compose-monitoring.yml down

show-ip:
	@echo ${DOCKER_HOST} ip-address: $(shell docker-machine ip ${DOCKER_HOST})
