
# Download base image ubuntu 16.04
FROM ubuntu:16.04

MAINTAINER Aaron Boyd <aaronmboyd@gmail.com>

RUN echo "deb http://archive.ubuntu.com/ubuntu xenial main universe" > /etc/apt/sources.list

# Update ubuntu software repository (skip recommends)
# Install build dependancies
RUN apt-get update && apt-get -qq --no-install-recommends install \
    cmake \
    cmake-curses-gui \
    git \
    libcurl4-gnutls-dev \
    libjansson-dev \
    libssl-dev \
    && rm -r /var/lib/apt/lists/*

RUN dpkg -i cuda-repo-ubuntu1604_8.0.61-1_amd64.deb

RUN apt-get update && apt-get -qq --no-install-recommends install \
    nvidia-cuda-dev \
    nvidia-cuda-toolkit \    
    && rm -r /var/lib/apt/lists/*

RUN mkdir xmrMiner \
    cd xmrMiner \

RUN git clone https://github.com/xmrMiner/xmrMiner.git

RUN mkdir build \
    cd build

RUN cmake -DCMAKE_INSTALL_PREFIX=$HOME/xmrMiner ../xmrMiner

RUN make -j install

RUN cd $HOME/xmrMiner

ENTRYPOINT ["xmrMiner --help"]
