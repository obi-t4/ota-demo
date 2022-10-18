.PHONY: all
all: docker-build

.PHONY: docker-build
docker-build: docker-build-18.04 docker-build-20.04 docker-build-22.04

.PHONY: docker-build-18.04
docker-build-18.04:
	@echo "# build base docker image"
	docker build -t ota-image:18.04 \
		--build-arg BASE_IMAGE=ubuntu:18.04 \
		--build-arg KERNEL_VERSION=5.0.0-32-generic \
		--build-arg PASSWORD=${PASSWORD} \
	    18.04

.PHONY: docker-build-20.04
docker-build-20.04:
	@echo "# build base docker image"
	docker build -t ota-image:20.04 \
		--build-arg BASE_IMAGE=ubuntu:20.04 \
		--build-arg KERNEL_VERSION=5.8.0-53-generic \
		--build-arg PASSWORD=${PASSWORD} \
	    20.04

.PHONY: docker-build-22.04
docker-build-22.04:
	@echo "# build base docker image"
	docker build -t ota-image:22.04 \
		--build-arg BASE_IMAGE=ubuntu:22.04 \
		--build-arg KERNEL_VERSION=5.15.0-35-generic \
		--build-arg PASSWORD=${PASSWORD} \
	    20.04
