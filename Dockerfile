
# Download base image ubuntu 16.04
FROM ubuntu:16.04

LABEL "maintainer"="Aaron Boyd <https://github.com/aaronmboyd>"

# Install git and retrieve repos
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends -f install \
    git \
    ca-certificates \
    wget \
    && rm -r /var/lib/apt/lists/* \
    # Get NVIDIA packages to sources
    && wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_8.0.61-1_amd64.deb \
    && dpkg -i cuda-repo-ubuntu1604_8.0.61-1_amd64.deb \
    # Get xmrMiner git repos
    && git clone https://github.com/xmrMiner/xmrMiner.git \
    && mkdir xmrMiner/build

WORKDIR /xmrMiner/build/

# Install build dependancies
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends -f install \
      build-essential \
      cmake \
      cmake-curses-gui \
      git \
      libcurl4-gnutls-dev \
      libjansson-dev \
      libssl-dev \
      cuda-toolkit-8.0 \
      cuda-runtime-8.0 \
      cuda-drivers \
    && rm -r /var/lib/apt/lists/*   \
    # Ignore GCC unsupported error, remove from host_config.h
    && sed -i 's/#error -- unsupported GNU version! gcc versions later than 5 are not supported!/\-\-#error -- unsupported GNU version! gcc versions later than 5 are not supported!/g' /usr/local/cuda-8.0/targets/x86_64-linux/include/host_config.h \
    # Build the executable
    && cmake \
    -DJANSSON_INCLUDE_DIR=/usr/include/ \
    -DJANSSON_LIBRARY=/usr/lib/x86_64-linux-gnu/libjansson.so \
    -DCMAKE_INSTALL_PREFIX=/xmrMiner/build/ /xmrMiner/ \
    && make -j install  \
    # Remove toolkit after build (not needed for execution) for smaller image size
    && apt-get remove -y --purge cuda-toolkit-8.0 \
    && apt-get -y autoremove  \
    # Reset interactive frontend for shell
    && DEBIAN_FRONTEND=newt

ENTRYPOINT ["/xmrMiner/build/xmrMiner"]
#CMD ["/bin/bash"]
