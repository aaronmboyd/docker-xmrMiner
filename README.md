# docker-xmrMiner

A Docker image for running [xmrMiner](https://github.com/xmrMiner/xmrMiner) based on Ubuntu 16.04 x86_64. Uses the CUDA 8.0 toolkit. Whilst there are a couple of steps to pass your host system's NVIDIA devices to the container, this image is intended mostly to abstract managing and installing CUDA dependencies and C compilation of the source.

 - Note - this is a very large Docker image due to the CUDA drivers being over 1.5GiB - future updates will focus on using a smaller Docker base image and only adding the absolute minimum of build dependencies.

### Getting started

1. [Verify you have a CUDA-enabled GPU](http://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#verify-you-have-cuda-enabled-system)
* [Install Docker](https://docs.docker.com/engine/installation/)
* Clone this repository `git clone https://github.com/aaronmboyd/docker-xmrMiner.git`
* Build this Docker image `docker build /docker-xmrMiner/. -t xmrminer`

### Running

1. You need to pass your devices to the Docker container before running.
* Run `ls -la /dev | grep nvidia` to show your NVIDIA devices. The results should look something like this:
  ```
  crw-rw-rw-   1 root root      195,   0 Jul 13 15:55 nvidia0
  crw-rw-rw-   1 root root      195, 255 Jul 13 15:55 nvidiactl
  crw-rw-rw-   1 root root      195, 254 Jul 13 15:55 nvidia-modeset
  crw-rw-rw-   1 root root      243,   0 Jul 13 15:55 nvidia-uvm
  crw-rw-rw-   1 root root      243,   1 Jul 13 17:21 nvidia-uvm-tools
  ```
* Run the Docker container
  * With the command `docker run `
  * Passing in all your devices as parameters, in this example it would be: `--device /dev/nvidia0 --device /dev/nvidiactl --device /dev/nvidia-modeset --device /dev/nvidia-uvm --device /dev/nvidia-uvm-tools`
  * Plus the name of the container you built: `xmrminer`
  * Passing in the xmrMiner arguments as per normal e.g. `--url=stratum+tcp://mine.xmrpool.net:5555 --launch=10x24 --bfactor=4 --bsleep=100 --user=44NxHdzAJPVZkfXGnRd7kiGc1xCrg3GPncMwECKCmfbXRhVqhTreT7a2DGWcwCD3f7FnDsu1eCYusaTJoaETPajD3dPTdpQ -p docker_worker_1 --donate=1`

* Putting it all together:
  ```
  docker run --device /dev/nvidia0 --device /dev/nvidiactl --device /dev/nvidia-modeset --device /dev/nvidia-uvm --device /dev/nvidia-uvm-tools xmrminer --url=stratum+tcp://mine.xmrpool.net:5555 --launch=10x24 --bfactor=4 --bsleep=100 --user=44NxHdzAJPVZkfXGnRd7kiGc1xCrg3GPncMwECKCmfbXRhVqhTreT7a2DGWcwCD3f7FnDsu1eCYusaTJoaETPajD3dPTdpQ -p docker_worker_1 --donate=1
  ```

Enjoy hashing!

### Further reading

- [xmrMiner GitHub](https://github.com/xmrMiner/xmrMiner)
- [xmrMiner on Reddit](https://www.reddit.com/r/Monero/comments/5xciun/xmrminer_a_new_high_optimized_nvidia_gpu_miner/)
- [CUDA Home](http://www.nvidia.com/object/cuda_home_new.html)

### Donations

Donations for work on dockerizing are accepted at:

- XMR: `44NxHdzAJPVZkfXGnRd7kiGc1xCrg3GPncMwECKCmfbXRhVqhTreT7a2DGWcwCD3f7FnDsu1eCYusaTJoaETPajD3dPTdpQ`
- ETH: `0x9d6f47245a2b55d298aab47acb64de4a61f71bc8`
- LTC: `LUQEF6NwWf3fzzxau7BSCb97B566C9DmZV`
- BTC: `1HvcUNwktq8g3DjSteH7dhAS9BXMqdGt1L`

Thanks to [psychocrypt](https://github.com/psychocrypt) for the source:
- XMR: `43NoJVEXo21hGZ6tDG6Z3g4qimiGdJPE6GRxAmiWwm26gwr62Lqo7zRiCJFSBmbkwTGNuuES9ES5TgaVHceuYc4Y75txCTU`
