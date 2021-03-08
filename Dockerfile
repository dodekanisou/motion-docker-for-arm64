# syntax = docker/dockerfile:1.2
FROM ubuntu:20.04

RUN --mount=type=cache,target=/var/cache/apt \
  apt-get update && apt-get install -y \
  motion \
  && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["motion"]
