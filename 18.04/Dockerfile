ARG BASE_IMAGE="ubuntu:18.04"
FROM ${BASE_IMAGE}
ARG KERNEL_VERSION
ARG PASSWORD

SHELL ["/bin/bash", "-c"]
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y --no-install-recommends \
    sudo ubuntu-minimal openssh-server \
    ubuntu-desktop \
    fonts-ubuntu \
    systemd-coredump vim git \
    grub-efi-amd64 \
    linux-image-${KERNEL_VERSION} linux-headers-${KERNEL_VERSION} linux-modules-extra-${KERNEL_VERSION} \
    apt-utils python3-pip usbutils \
    gcc libc6-dev \
    dirmngr rsyslog gpg-agent initramfs-tools \
    g++ \
    python3.8 python3.8-venv python3.8-dev \
    libcurl4-openssl-dev libssl-dev

RUN git clone https://github.com/tier4/ota-client /tmp/ota-client
RUN python3.8 -m venv /opt/ota/.venv
RUN source /opt/ota/.venv/bin/activate && \
	pip install -U pip && \
	pip install /tmp/ota-client && \
        pip install -t /opt/ota --no-deps /tmp/ota-client
RUN cp -r /tmp/ota-client/bootstrap/root/* /
RUN sed -i 's/python3/pyton3.8/g' /etc/systemd/system/otaclient.service
RUN systemctl enable otaclient

# add autoware user
RUN useradd -m autoware -s /bin/bash && \
    echo autoware:${PASSWORD} | chpasswd && \
    gpasswd -a autoware sudo
