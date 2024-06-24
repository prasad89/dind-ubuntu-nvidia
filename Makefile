IMAGE_NAME = dind-ubuntu-nvidia
TAG ?= latest
REGISTRY_PREFIX ?= ghcr.io/prasad89

GPU_COUNT ?= all

build:
	@docker build -f Dockerfile -t ${REGISTRY_PREFIX}/${IMAGE_NAME}:${TAG} .

run_standard:
	@docker run -it --rm --privileged ${REGISTRY_PREFIX}/${IMAGE_NAME}:${TAG}

run_gpu:
	@docker run -it --rm --privileged --gpus ${GPU_COUNT} ${REGISTRY_PREFIX}/${IMAGE_NAME}:${TAG}

pull:
	@docker pull ${REGISTRY_PREFIX}/${IMAGE_NAME}:${TAG}

push:
	@docker push ${REGISTRY_PREFIX}/${IMAGE_NAME}:${TAG}

build_run_standard: build run_standard

build_run_gpu: build run_gpu

build_push: build push

k8s_deploy:
	@kubectl apply -f k8s-deployment.yml