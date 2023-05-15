PATTERN := jupyter
JUPYTER_IMAGE_TAG := jupyter-devenv

##@ Helpers

.PHONY: help

help: ## Display this help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST) && echo

##@ Build

build: ## Build docker images of service
	@echo "Build jupyter docker iamge..."
	@docker build -f ./jupyter/Dockerfile . \
		-t ${JUPYTER_IMAGE_TAG}

clean-docker-images: ## Remove dangling images of service
	@echo "Remove all docker images of $(PATTERN)"
	@docker images | grep $(PATTERN) | awk '{print $$3}' | xargs docker rmi -f
	@echo "Done!!"

##@ Run

launch-jupyter: ## Launch jupyter notebook
	@docker run \
		-e env="DISPLAY" \
		-v /tmp/.X11-unix:/tmp/.X11-unix:rw \
		-v ${PWD}/jupyter/ipynbfiles:/opt/app/ipynbfiles \
		-v ${PWD}/dataset:/opt/app/dataset \
		-v ${PWD}/models:/opt/app/models \
		-p 8888:8888 \
		--rm -it ${JUPYTER_IMAGE_TAG} \
		jupyter notebook --port=8888 --ip=0.0.0.0 --allow-root

jupyter-bash: ## Launch /bin/bash in jupyter container
	@docker run \
		-v ${PWD}/jupyter:/opt/app \
		--rm -it ${JUPYTER_IMAGE_TAG} \
		/bin/bash

##@ Operation

jupyter-libs-update: ## Update python libraries in jupyter container
	@docker run \
		-v ${PWD}/jupyter:/opt/app \
		--rm -it ${JUPYTER_IMAGE_TAG} \
		poetry update
