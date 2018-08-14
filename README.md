**This project is deprecated. [xmr-stak](https://github.com/fireice-uk/xmr-stak) is the successor to `xmrMiner` and Dockerfiles now exist in the codebase.**

# docker-xmrminer

Docker images for running [psychocrypt's](https://github.com/psychocrypt) Monero miner: [xmrMiner](https://github.com/xmrMiner/xmrMiner) inside a NVIDIA CUDA enabled Docker container. Operating system targets for this image are limited to Linux kernels at this point since [nvidia-docker](https://github.com/NVIDIA/nvidia-docker) is only available for these architectures so far.

By using the [nvidia-docker](https://github.com/NVIDIA/nvidia-docker) wrapper for the Docker CLI, we can achieve true containerisation of a CUDA application and avoid the following:
1. The host machine requiring CUDA installed
2. Passing the NVIDIA devices as command-line arguments to the Docker engine

See the [nvidia-docker "Motivation" Wiki entry for more detail.](https://github.com/NVIDIA/nvidia-docker/wiki/Motivation)
### Prerequisites

1. [Verify you have a CUDA-enabled GPU](http://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#verify-you-have-cuda-enabled-system)
2. [Install Docker](https://docs.docker.com/engine/installation/)
3. [Install nvidia-docker](https://github.com/NVIDIA/nvidia-docker/wiki/Installation)

### Selecting a Docker image

Running a CUDA container requires a machine with at least one CUDA-capable GPU and a driver compatible with the CUDA toolkit version you are using.

**The machine running the CUDA container only requires the NVIDIA driver, the CUDA toolkit doesn't have to be installed on the host.**

NVIDIA drivers are backward-compatible with CUDA toolkits versions so please update your NVIDIA drivers and use the **cuda-8.0** image. The 2.0 and 2.1 GPUs will soon be deprecated in CUDA, and those cards are unlikely to be profitable mining hardware at this point anyway.

| CUDA toolkit version | Driver version | GPU architecture | Docker image |
|----------------------|----------------|------------------|--------------|
| 6.5	| >= 340.29	| >= 2.0 (Fermi) | Unsupported - please use a later driver |
| 7.0	| >= 346.46	| >= 2.0 (Fermi) | May be supported - check back later |
| 7.5	| >= 352.39	| >= 2.0 (Fermi) | May be supported - check back later |
| 8.0	| == 361.93 or >= 375.51 | == 6.0 (P100) | aaronmboyd/xmrminer:latest |
| 8.0	| >= 367.48	| >= 2.0 (Fermi) | aaronmboyd/xmrminer:latest |

### Quickstart

1. Pull from the Docker repository:
```
docker pull aaronmboyd/xmrminer
```

2. Run the container using `nvidia-docker run` instead of `docker run`, and pass in all the same arguments for your pool and username to **xmrminer** as normal.

  * Note - you can isolate the GPUs you want to use in this container by passing in the attribute ``NV_GPU=0`` for the first GPU, ``NV_GPU=0,1`` for the first two, etc. This may be useful where you have different GPUs and need to adjust the thread/block `--launch` parameter for each GPU. This command is not _required_ though, `nvidia-docker` will probe the available devices for you if you omit this argument. See [nvidia-docker](https://github.com/NVIDIA/nvidia-docker) documentation for more on this syntax.

#### Example run command ###
  ```
  nvidia-docker run aaronmboyd/xmrminer --url=stratum+tcp://mine.xmrpool.net:5555 --launch=10x24 --bfactor=4 --bsleep=100 --user=44NxHdzAJPVZkfXGnRd7kiGc1xCrg3GPncMwECKCmfbXRhVqhTreT7a2DGWcwCD3f7FnDsu1eCYusaTJoaETPajD3dPTdpQ -p docker_worker_1 --donate=1
  ```
#### Example run command isolating the first GPU only ###
```
  NV_GPU=0 nvidia-docker run aaronmboyd/xmrminer --url=stratum+tcp://mine.xmrpool.net:5555 --launch=10x24 --bfactor=4 --bsleep=100 --user=44NxHdzAJPVZkfXGnRd7kiGc1xCrg3GPncMwECKCmfbXRhVqhTreT7a2DGWcwCD3f7FnDsu1eCYusaTJoaETPajD3dPTdpQ -p docker_worker_1 --donate=1
```

#### Troubleshooting installation of nvidia-docker (Debian/Ubuntu)

***`nvidia-modprobe` missing? If you see something similar to the following message on install;***
```
Selecting previously unselected package nvidia-docker.
(Reading database ... 308844 files and directories currently installed.)
Preparing to unpack .../nvidia-docker_1.0.1-1_amd64.deb ...
Unpacking nvidia-docker (1.0.1-1) ...
Setting up nvidia-docker (1.0.1-1) ...
Setting up permissions
Job for nvidia-docker.service failed because the control process exited with error code. See "systemctl status nvidia-docker.service" and "journalctl -xe" for details.
nvidia-docker.service couldn't start.
```
Now try ``systemctl status nvidia-docker.service``. If you now see:
```
...systemd[1]: Failed to start NVIDIA Docker plugin.
...systemd[1]: nvidia-docker.service: Unit entered failed state.
...systemd[1]: nvidia-docker.service: Failed with result 'exit-code'.
...systemd[1]: nvidia-docker.service: Service hold-off time over, scheduling restart.
...systemd[1]: Stopped NVIDIA Docker plugin.
...systemd[1]: nvidia-docker.service: Start request repeated too quickly.
...systemd[1]: Failed to start NVIDIA Docker plugin.
```
Try to start the service manually: ``sudo nvidia-docker-plugin`` . If you now see:
```
nvidia-docker-plugin | <timestamp> Loading NVIDIA unified memory
nvidia-docker-plugin | <timestamp> Error: Could not load UVM kernel module. Is nvidia-modprobe installed?
```
Verify you have ``nvidia-modprobe`` installed. If not, install with ``sudo apt-get install nvidia-modprobe`` and retry the ``nvidia-docker`` install.

Enjoy hashing!

### Further reading

- [nvidia-docker](https://github.com/NVIDIA/nvidia-docker)
- [xmrMiner GitHub](https://github.com/xmrMiner/xmrMiner)
- [xmrMiner on Reddit](https://www.reddit.com/r/Monero/comments/5xciun/xmrminer_a_new_high_optimized_nvidia_gpu_miner/)
- [CUDA Home](http://www.nvidia.com/object/cuda_home_new.html)

### Donations

Thanks to [psychocrypt](https://github.com/psychocrypt) for the work on xmrMiner:
- XMR: `43NoJVEXo21hGZ6tDG6Z3g4qimiGdJPE6GRxAmiWwm26gwr62Lqo7zRiCJFSBmbkwTGNuuES9ES5TgaVHceuYc4Y75txCTU`

Donations for work on dockerizing are accepted at:
- XMR: `44NxHdzAJPVZkfXGnRd7kiGc1xCrg3GPncMwECKCmfbXRhVqhTreT7a2DGWcwCD3f7FnDsu1eCYusaTJoaETPajD3dPTdpQ`
