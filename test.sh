#!/bin/bash

set -o errexit

# tests whether we're able to run the
# image that has just been generated and
# ssh into it by executing a command there
# via SSH.
main() {
  generate_keys
  run_container
  sleep 3
  run_ssh_command
}

# generates keys than can be used to
# SSH into the container.
#   -t rsa  : Use RSA as the type of the key
#   -b      : Number of bits in the key to create.
#             For RSA the minimum is 1024.
#   -C      : a command that makes clear that the
#             key is for testing purposes
#   -f      : output for the files. Note: the public
#             key gets named <file>.pub.
#   -P      : passphrase used (none)
generate_keys() {
  ssh-keygen \
    -t rsa \
    -b 4096 \
    -C "test@test.com" \
    -f ./key.rsa -P ""
  chmod 400 ./key.rsa
}

# runs a container with the public key
# bound so that we can SSH into the container
# without the need of ssh-pass.
run_container() {
  docker run \
    --privileged \
    --security-opt seccomp=unconfined \
    --tmpfs /run \
    --tmpfs /run/lock \
    --volume /sys/fs/cgroup:/sys/fs/cgroup:ro \
    --volume $(pwd)/key.rsa.pub:/root/.ssh/authorized_keys:ro \
    --detach \
    --publish 2222:22 \
    cirocosta/ubuntu
}

# just runs an SSH command inside the container.
# this should be enough to verify that:
#   1.  we have SSHD running - initiated by systemd
#   2.  our key is being properly set as authorized
#       for the root user.
run_ssh_command() {
  ssh \
    -i ./key.rsa root@localhost \
    -p 2222 \
    ls -lah
}

main "$@"
