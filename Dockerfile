# syntax = docker/dockerfile:1.2
FROM ubuntu:20.04

RUN --mount=type=cache,target=/var/cache/apt \
  apt update && cd /var/cache/apt && curl https://github.com/Motion-Project/motion/releases/download/release-4.4.0/bionic_motion_4.4.0-1_arm64.deb -o motion.deb \
  && apt install -y motion.deb \
  && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["motion"]
