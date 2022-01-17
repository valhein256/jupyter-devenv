JUPYTER_IMAGE_TAG := jupyter-devenv

build: build-jupyter

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
