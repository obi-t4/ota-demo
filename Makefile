.PHONY: all
all: docker-build

.PHONY: docker-build
docker-build: docker-build-18.04 docker-build-20.04 docker-build-22.04

.PHONY: rootfs
rootfs: rootfs-18.04 rootfs-20.04 rootfs-22.04

.PHONY: metadata
metadata: metadata-18.04 metadata-20.04 metadata-22.04

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

rootfs-18.04: RELEASE=18.04
rootfs-20.04: RELEASE=20.04
rootfs-22.04: RELEASE=22.04

rootfs-18.04 rootfs-20.04 rootfs-22.04:
	docker_id=`docker create -it --rm ota-image:${RELEASE} bash`; \
	docker start $$docker_id; \
	docker export $$docker_id > ${RELEASE}.tar; \
	docker stop $$docker_id
	mkdir -p rootfs.${RELEASE}/rootfs
	sudo tar xf ${RELEASE}.tar -C rootfs.${RELEASE}/rootfs

metadata-18.04: RELEASE=18.04
metadata-20.04: RELEASE=20.04
metadata-22.04: RELEASE=22.04

metadata-18.04 metadata-20.04 metadata-22.04:
	( \
	cp ota-metadata/metadata/persistents.txt \
		ota-client/tests/keys/sign.pem \
		rootfs.${RELEASE}; \
	cd rootfs.${RELEASE}; \
	sudo python3 ../ota-metadata/metadata/ota_metadata/metadata_gen.py \
		--target-dir rootfs \
		--compressed-dir rootfs.zst \
		--ignore-file ../ota-metadata/metadata/ignore.txt; \
	sudo python3 ../ota-metadata/metadata/ota_metadata/metadata_sign.py \
		--sign-key ../ota-client/tests/keys/sign.key \
		--cert-file sign.pem \
		--persistent-file persistents.txt \
		--rootfs-directory rootfs \
		--compressed-rootfs-directory rootfs.zst; \
	)

.PHONY: clean
clean:
	rm -rf rootfs.* *.tar
