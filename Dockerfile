
# Download base image ubuntu 16.04
FROM ubuntu:16.04

LABEL "maintainer"="Aaron Boyd <https://github.com/aaronmboyd>"

# Install build dependancies
RUN apt-get update && apt-get -y --no-install-recommends -f install \
  build-essential \
  cmake \
  cmake-curses-gui \
  git \
  libcurl4-gnutls-dev \
  libjansson-dev \
  libssl-dev \
  wget \
  ca-certificates \
  && rm -r /var/lib/apt/lists/*

# Retrieve NVIDA CUDA .deb file and install
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_8.0.61-1_amd64.deb

# Install NVIDIA CUDA dependencies
RUN dpkg -i cuda-repo-ubuntu1604_8.0.61-1_amd64.deb \
    && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install \
    cuda-toolkit-8.0 \
    cuda-runtime-8.0 \
    cuda-drivers \
    && rm -r /var/lib/apt/lists/*

# Remove errors for using latest GCC versions
RUN sed -i 's/#error -- unsupported GNU version! gcc versions later than 5 are not supported!/\-\-#error -- unsupported GNU version! gcc versions later than 5 are not supported!/g' /usr/local/cuda-8.0/targets/x86_64-linux/include/host_config.h

# Retrieve xmrMiner master
RUN git clone https://github.com/xmrMiner/xmrMiner.git

RUN mkdir xmrMiner/build
WORKDIR /xmrMiner/build

RUN cmake \
    -DJANSSON_INCLUDE_DIR=/usr/include/ \
    -DJANSSON_LIBRARY=/usr/lib/x86_64-linux-gnu/libjansson.so \
    -DCMAKE_INSTALL_PREFIX=/ ../

RUN make -j install

RUN DEBIAN_FRONTEND=newt

ENTRYPOINT ["/xmrMiner/xmrMiner"]
#CMD ["/bin/bash"]
