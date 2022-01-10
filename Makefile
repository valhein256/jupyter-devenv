SERVICE := jupyter
STAGE := stg
APP := main.py
CREDENTIAL :=
IMAGE_TAG := ${SERVICE}:${STAGE}

.PHONY: config build scripts run devenv lint update

build:
	@echo "Build docker iamge..."
	@docker build -f ./Dockerfile . \
		--build-arg PROJECT_ENV=${STAGE} \
		-t ${IMAGE_TAG}

run:
ifeq (${CREDENTIAL}, true)
	@docker run \
		-v ${PWD}:/opt/app \
		-e AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY_ID) \
		-e AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_ACCESS_KEY) \
		-e AWS_SESSION_TOKEN=$(AWS_SESSION_TOKEN) \
		-e AWS_SECURITY_TOKE=$(AWS_SECURITY_TOKEN) \
		--rm ${IMAGE_TAG} \
		python ${APP}
else
	@docker run \
		-v ${PWD}:/opt/app \
		--rm ${IMAGE_TAG} \
		python ${APP}
endif

devenv:
	@docker run \
		-v ${PWD}:/opt/app \
		--rm -it ${IMAGE_TAG} \
		/bin/bash

lint:
	@docker run \
		-v ${PWD}:/opt/app \
		--rm ${IMAGE_TAG} \
		flake8 --ignore=E501

update:
	@docker run \
		-v ${PWD}:/opt/app \
		--rm ${IMAGE_TAG} \
		poetry update

jupyter:
	@docker run \
		-v ${PWD}:/opt/app \
		-p 8888:8888 \
		-it ${IMAGE_TAG} \
		ipython notebook --port=8888 --ip=0.0.0.0 --allow-root

launch-web:
	@docker run \
		-p 5031:5031 \
		--rm ${IMAGE_TAG}
