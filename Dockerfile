# syntax = docker/dockerfile:1.2
FROM ubuntu:24.04

ARG MOTION_VERSION=4.7.1
ARG UBUNTU_RELEASE=noble # Ubuntu 24

RUN --mount=type=cache,target=/var/cache/apt \
  apt update && apt install -y wget gdebi-core libcamera-tools \
  && wget -O /tmp/motion.deb \
     https://github.com/Motion-Project/motion/releases/download/release-${MOTION_VERSION}/${UBUNTU_RELEASE}_motion_${MOTION_VERSION}-1_arm64.deb \
  && gdebi -n /tmp/motion.deb \
  && rm -rf /var/lib/apt/lists/* \
  && rm -f /tmp/motion.deb

ENTRYPOINT ["libcamerify", "motion"]
