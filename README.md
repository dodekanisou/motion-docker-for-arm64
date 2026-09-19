# Docker image for motion targeting arm64

[![Build docker image](https://github.com/dodekanisou/motion-docker-for-arm64/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/dodekanisou/motion-docker-for-arm64/actions/workflows/docker-publish.yml)

Docker image with motion installed targeting arm64 devices like RPI 4b. Docker image published in [docker hub](https://hub.docker.com/r/dodekanisou/motion-docker-for-arm64). 
To configure motion, bint the `/etc/motion` path to a volume and add in the host `the motion.conf` based on the [official motion documentation](https://motion-project.github.io/motion_config.html).

To use local camera (e.g. `/dev/video0` for RPI camera), docker must run as priviledged and you need to bind `"/dev/video0:/dev/video0"`.

## Building locally

You can build locally an image taged as `test/motion:latest` using the following command:

```
docker buildx build -t test/motion:latest --platform linux/arm64 .
```

## Deploy as an IoT Edge module

For IoT Edge deployment use the following settings.

- Docker image url : dodekanisou/motion-docker-for-arm64:2021-03-08 (Check [docker hub](https://hub.docker.com/r/dodekanisou/motion-docker-for-arm64/tags) for latest tag)
- in the **Container Create Options** specify the following:
  ```
  {
    "ExposedPorts": {
      "8081": {},
      "8080/tcp": {}
    },
    "HostConfig": {
      "Binds": [
        "/var/lib/motion/config:/etc/motion",
        "/var/lib/motion/data:/var/lib/motion",
        "/dev/video0:/dev/video0"
      ],
      "Privileged": true,
      "PortBindings": {
        "8081": [
          {
            "HostPort": "8081"
          }
        ],
        "8080/tcp": [
          {
            "HostPort": "8080"
          }
        ]
      }
    }
  }
  ```

In the `/var/lib/motion/config` folder add a `motion.conf` file with the following settings:

```
... more settings needed ...
log_file /var/lib/motion/motion.log
target_dir /var/lib/motion
videodevice /dev/video0
webcontrol_port 8080
webcontrol_localhost off
stream_port 8081
stream_localhost off
... more settings needed ...
```

## Debugging and diagnostics

Install helpful tools on the Raspberry Pi host

``` bash
sudo apt-get update
sudo apt-get install -y psmisc v4l-utils
# Optional tools
sudo apt-get install -y lsof rpicam-apps
```
Useful tools
- `fuser` — find processes using camera devices
- `v4l2-ctl` — inspect and test V4L2 devices
- `media-ctl` — inspect media-controller topology
- `rpicam-hello` — detect Raspberry Pi camera modules

### Common commands
List V4L2 devices:
``` bash
v4l2-ctl --list-devices
ls -l /dev/video*
```
- Identify Raspberry Pi cameras: `rpicam-hello --list-cameras`
- Inspect a device: `v4l2-ctl --all -d /dev/video0`
- Check which process owns the device: `sudo fuser -v /dev/video0 /dev/video1 /dev/video2`
- Inspect media topology: `media-ctl -d /dev/media0 -p`
- Review kernel camera messages: `dmesg | grep -Ei 'camera|ov5647|csi|unicam|imx|sensor'`
- Test streaming (stop Motion first): `v4l2-ctl -d /dev/video0 --stream-mmap --stream-count=30 --stream-to=/dev/null`

If you are running motion on kubernetes:
- Scale down Motion before testing devices: `kubectl scale deployment/motion -n motion --replicas=0`
- Scale up after testing: `kubectl scale deployment/motion -n motion --replicas=1`
- Check device ownership inside a pod: `kubectl exec -it deploy/motion -n motion -- fuser -v /dev/video0 /dev/video1`

### Common error
VIDIOC_REQBUFS ... Device or resource busy usually means Motion or another process is already streaming from the device. Stop Motion before running direct tests.
