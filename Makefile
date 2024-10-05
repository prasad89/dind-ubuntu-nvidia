IMAGE_NAME = dind-ubuntu-nvidia
TAG ?= latest
REGISTRY_PREFIX ?= ghcr.io/prasad89
PLATFORM ?= linux/amd64,linux/arm64

GPU_COUNT ?= all

build:
	@echo "Building Docker image..."
	@echo "Image Name: ${IMAGE_NAME}"
	@echo "Tag: ${TAG}"
	@echo "Registry Prefix: ${REGISTRY_PREFIX}"
	@echo "Platform: ${PLATFORM}"
	@docker buildx build -f Dockerfile -t ${REGISTRY_PREFIX}/${IMAGE_NAME}:${TAG} --platform ${PLATFORM} . 

run_standard:
	@echo "Running standard Docker container..."
	@echo "Image: ${REGISTRY_PREFIX}/${IMAGE_NAME}:${TAG}"
	@docker run -it --rm --privileged ${REGISTRY_PREFIX}/${IMAGE_NAME}:${TAG}

run_gpu:
	@echo "Running Docker container with GPU..."
	@echo "Image: ${REGISTRY_PREFIX}/${IMAGE_NAME}:${TAG}"
	@echo "GPU Count: ${GPU_COUNT}"
	@docker run -it --rm --privileged --gpus ${GPU_COUNT} ${REGISTRY_PREFIX}/${IMAGE_NAME}:${TAG}

pull:
	@echo "Pulling Docker image..."
	@echo "Image: ${REGISTRY_PREFIX}/${IMAGE_NAME}:${TAG}"
	@docker pull ${REGISTRY_PREFIX}/${IMAGE_NAME}:${TAG}

push:
	@echo "Pushing Docker image..."
	@echo "Image: ${REGISTRY_PREFIX}/${IMAGE_NAME}:${TAG}"
	@docker push ${REGISTRY_PREFIX}/${IMAGE_NAME}:${TAG}

build_run_standard: build run_standard

build_run_gpu: build run_gpu

build_push: build push

k8s_deploy:
	@echo "Deploying to Kubernetes..."
	@kubectl apply -f k8s-deployment.yml
