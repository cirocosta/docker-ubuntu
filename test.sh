#!/bin/bash

set -o errexit

main() {
  run_container
  sleep 3
  run_ssh_command
}

run_container() {
  docker run \
    --privileged \
    --security-opt seccomp=unconfined \
    --tmpfs /run \
    --tmpfs /run/lock \
    --volume /sys/fs/cgroup:/sys/fs/cgroup:ro \
    --detach \
    --publish 2222:22 \
    cirocosta/ubuntu
}

run_ssh_command() {
  chmod 400 ./zesty/keys/key.rsa
  ssh \
    -i ./zesty/keys/key.rsa root@localhost \
    -p 2222 \
    ls -lah
}

main "$@"
