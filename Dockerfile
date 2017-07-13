
# Download base image ubuntu 16.04
FROM ubuntu:16.04

MAINTAINER Aaron Boyd <aaronmboyd@gmail.com>

RUN echo "deb http://archive.ubuntu.com/ubuntu xenial main universe" > /etc/apt/sources.list

# Update ubuntu software repository (skip recommends)
RUN apt-get update && apt-get -y --no-install-recommends install

# Install aptitude for better dependency fixes
RUN apt-get install -y aptitude

# Install build dependancies
RUN aptitude update && aptitude -y install \
  cmake \
  cmake-curses-gui \
  git \
  libcurl4-gnutls-dev \
  libjansson-dev \
  libssl-dev \
  wget \
  && rm -r /var/lib/apt/lists/*

# Retrieve NVIDA CUDA .deb file for install
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_8.0.61-1_amd64.deb

RUN dpkg -i cuda-repo-ubuntu1604_8.0.61-1_amd64.deb

RUN aptitude update && aptitude -y install \
    cuda \
#    nvidia-cuda-toolkit \
    && rm -r /var/lib/apt/lists/*

RUN git clone https://github.com/xmrMiner/xmrMiner.git

RUN cd xmrMiner \
    mkdir build \
    cd build

RUN cmake -DCMAKE_INSTALL_PREFIX=$HOME/xmrMiner ../xmrMiner

RUN make -j install

RUN cd $HOME/xmrMiner

ENTRYPOINT ["xmrMiner --help"]
