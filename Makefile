TAG := develop
CREDENTIAL :=
JUPYTER_IMAGE_TAG := jupyter-${TAG}
SERVICE_IMAGE_TAG := service-${TAG}

build: build-jupyter build-service

# jupyter
build-jupyter:
	@echo "Build jupyter docker iamge..."
	@docker build -f ./jupyter/Dockerfile . \
		-t ${JUPYTER_IMAGE_TAG}

launch-jupyter:
	@docker run \
		-v ${PWD}/jupyter/ipynbfiles:/opt/app/ipynbfiles \
		-v ${PWD}/dataset:/opt/app/dataset \
		-v ${PWD}/models:/opt/app/models \
		-p 8888:8888 \
		--rm -it ${JUPYTER_IMAGE_TAG} \
		jupyter notebook --port=8888 --ip=0.0.0.0 --allow-root

jupyter-dev:
	@docker run \
		-v ${PWD}/jupyter:/opt/app \
		--rm -it ${JUPYTER_IMAGE_TAG} \
		/bin/bash

jupyter-libs-update:
	@docker run \
		-v ${PWD}/jupyter:/opt/app \
		--rm -it ${JUPYTER_IMAGE_TAG} \
		poetry update

# service
build-service:
	@echo "Build jupyter docker iamge..."
	@docker build -f ./service/Dockerfile . \
		-t ${SERVICE_IMAGE_TAG}

launch-service:
	@docker run \
		-v ${PWD}/service:/opt/app \
		-p 5031:5031 \
		--rm ${SERVICE_IMAGE_TAG}

service-dev:
	@docker run \
		-v ${PWD}/service:/opt/app \
		--rm -it ${SERVICE_IMAGE_TAG} \
		/bin/bash

service-libs-update:
	@docker run \
		-v ${PWD}/service:/opt/app \
		--rm -it ${SERVICE_IMAGE_TAG} \
		poetry update

# lint and libs-update
lint:
	@docker run \
		-v ${PWD}:/opt/app \
		--rm -it ${SERVICE_IMAGE_TAG} \
		flake8 --ignore=E501

clean-uploads-images:
	@rm -rf ./service/static/uploads/*
