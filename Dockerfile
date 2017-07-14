
# Download base image ubuntu 16.04
FROM ubuntu:16.04

LABEL "maintainer"="Aaron Boyd <aaronmboyd@gmail.com>"

# RUN echo "deb http://archive.ubuntu.com/ubuntu xenial main universe multiverse restricted" > /etc/apt/sources.list

# Install build dependancies
RUN apt-get update && apt-get -y --no-install-recommends install \
  build-essential \
  cmake \
  cmake-curses-gui \
  git \
  libcurl4-gnutls-dev \
  libjansson-dev \
  libssl-dev \
  wget -f \
  && rm -r /var/lib/apt/lists/*

# openSSL / ca-certificates
RUN apt-get update && apt-get install -y ca-certificates

# Retrieve xmrMiner master
RUN git clone https://github.com/xmrMiner/xmrMiner.git

# Retrieve NVIDA CUDA .deb file and install
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_8.0.61-1_amd64.deb

# Install NVIDIA CUDA dependencies
RUN dpkg -i cuda-repo-ubuntu1604_8.0.61-1_amd64.deb \
    && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install \
    nvidia-cuda-toolkit \
    cuda \
    && rm -r /var/lib/apt/lists/*

RUN cd xmrMiner \
    mkdir build \
    cd build

#RUN cmake -DCMAKE_C_COMPILER=/usr/lib/gcc -DCMAKE_CXX_COMPILER=/usr/lib/gcc -DCMAKE_INSTALL_PREFIX=$HOME/xmrMiner ../xmrMiner
RUN cmake -DCMAKE_INSTALL_PREFIX=$HOME/xmrMiner ../xmrMiner

RUN make -j install
RUN cd $HOME/xmrMiner

RUN DEBIAN_FRONTEND=newt

ENTRYPOINT ["/bin/bash", "--help"]
CMD ["/bin/sh"]
#ENTRYPOINT["xmrMiner"]
#ENTRYPOINT["xmrMiner", "--url", "--launch", "--bfactor", "--bsleep", "--user", "-p", "--donate"]
#CMD ["stratum+tcp://mine.xmrpool.net:5555", "11x24", "4", "100", "44NxHdzAJPVZkfXGnRd7kiGc1xCrg3GPncMwECKCmfbXRhVqhTreT7a2DGWcwCD3f7FnDsu1eCYusaTJoaETPajD3dPTdpQ", "docker_miner_1:aaronmboyd@gmail.com", "1"]
