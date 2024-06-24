# Use Ubuntu 24.04 as the base image
FROM ubuntu:24.04

# Install necessary packages
RUN apt-get update && apt-get install -y \
	ca-certificates \
	curl \
	gpg \
	iptables \
	supervisor

# Install Docker using a script from Docker's official website
RUN curl -fsSL https://get.docker.com | sh

# Install NVIDIA Container Toolkit for GPU support
RUN curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
	&& curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
	sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
	tee /etc/apt/sources.list.d/nvidia-container-toolkit.list \
	&& apt-get update \
	&& apt-get install -y nvidia-container-toolkit \
	&& nvidia-ctk runtime configure --runtime=docker \
	&& rm -rf /var/lib/apt/lists/*

# Copy entrypoint script and Supervisor configuration files into the container
COPY entrypoint.sh /usr/local/bin/
COPY supervisor/ /etc/supervisor/conf.d/

# Make entrypoint script executable
RUN chmod +x /usr/local/bin/entrypoint.sh

# Create a volume for Docker's data directory
VOLUME /var/lib/docker

# Define the entrypoint for the container
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Default command to run if no other command is specified
CMD ["bash"]
