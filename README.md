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
