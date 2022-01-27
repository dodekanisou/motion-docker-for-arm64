# syntax = docker/dockerfile:1.2
FROM ubuntu:20.04

RUN --mount=type=cache,target=/var/cache/apt \
  apt update && apt install -y wget gdebi-core \
  && wget -O /tmp/motion.deb https://github.com/Motion-Project/motion/releases/download/release-4.4.0/focal_motion_4.4.0-1_arm64.deb \
  && gdebi -n /tmp/motion.deb \
  && rm -rf /var/lib/apt/lists/* \
  && rm -f /tmp/motion.deb

ENTRYPOINT ["motion"]
