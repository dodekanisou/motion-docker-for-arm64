# syntax = docker/dockerfile:1.2
FROM ubuntu:20.04

RUN --mount=type=cache,target=/var/cache/apt \
  apt update && apt install -y curl \
  && curl -fsSL https://github.com/Motion-Project/motion/releases/download/release-4.4.0/_SHA256.txt.gpg | apt-key add - && \
  && curl https://github.com/Motion-Project/motion/releases/download/release-4.4.0/focal_motion_4.4.0-1_arm64.deb -o /var/cache/apt/motion.deb \
  && apt install -y /var/cache/apt/motion.deb \
  && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["motion"]
