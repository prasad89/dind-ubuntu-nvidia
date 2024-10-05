# Ubuntu-based Docker-in-Docker (DinD) Environment with NVIDIA Container Runtime Support

## Overview
This repository offers an Ubuntu-based Docker-in-Docker (DinD) environment tailored for containerized development, enriched with NVIDIA container runtime support. The base image is crafted on Ubuntu 24.10.

## Features
- **Ubuntu 24.10**: Built on the latest stable Ubuntu LTS platform for reliability and long-term support.
- **Docker-in-Docker (DinD)**: Enables nested Docker containerization, ideal for CI/CD pipelines and advanced development workflows.
- **NVIDIA Container Runtime**: Facilitates execution of GPU-accelerated applications leveraging NVIDIA GPUs for enhanced performance.

## Usage

### Pull the Image
To obtain the pre-built Docker image from Docker Hub, execute the following command:

```sh
docker pull ghcr.io/prasad89/dind-ubuntu-nvidia
```

### Run the Container

#### Standard (Non-GPU) Usage
For standard Docker operations without GPU support:

```sh
docker run -it --rm --privileged ghcr.io/prasad89/dind-ubuntu-nvidia
```

#### GPU-Accelerated Usage
To utilize NVIDIA GPU support within the Docker environment:

```sh
docker run -it --rm --privileged --gpus all ghcr.io/prasad89/dind-ubuntu-nvidia
```

Replace `--gpus all` with specific GPU settings (`--gpus device=0,1`) as per your hardware configuration.

#### Deploying in Kubernetes
To deploy the container in a Kubernetes cluster:
 
```sh
kubectl apply -f https://raw.githubusercontent.com/prasad89/dind-ubuntu-nvidia/main/k8s-deployement.yml
```

### Using the Makefile

This repository includes a Makefile to simplify building, running, pulling, and pushing the Docker image. Below are the available commands:

#### Build the Docker Image
```sh
make build
```

By default, this `make` command builds a multiple architecture image using `buildx`. Make sure you have a compatible `buildx` driver installed to run this.

Optionally, if you don't want to build for multiple architectures, you can simply run: `docker build -f Dockerfile -t REGISTRY_PREFIX/IMAGE_NAME:TAG .`

#### Run the Container in Standard Mode (without GPU)
```sh
make run_standard
```

#### Run the Container with GPU Support
```sh
make run_gpu
```

#### Pull the Docker Image from the Registry
```sh
make pull
```

#### Push the Docker Image to the Registry
```sh
make push
```

#### Build and Run the Docker Image in Standard Mode
```sh
make build_run_standard
```

#### Build and Run the Docker Image with GPU Support
```sh
make build_run_gpu
```

#### Build and Push the Docker Image to the Registry
```sh
make build_push
```

#### Deploy the Container in Kubernetes
```sh
make k8s_deploy
```

### Customizing the Makefile

If you need to customize the image name, tag, or registry prefix, you can modify the variables in the Makefile:

- **IMAGE_NAME**: The name of the Docker image (default: `dind-ubuntu-nvidia`).
- **TAG**: The tag for the Docker image (default: `latest`).
- **REGISTRY_PREFIX**: The registry prefix where the image is stored (default: `ghcr.io/prasad89`).
- **GPU_COUNT**: The number of GPUs to use (default: `all`). Adjust this as needed for your specific setup.
- **PLATFORM**: The platforms for which the Docker image is built (default: `linux/amd64,linux/arm64`).