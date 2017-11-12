docker-ubuntu - a mini-ubuntu that has systemd with SSH configured.

Usage:

  1.  Default password
    
      The easiest way to get `cirocosta/ubuntu` running is using
      the default password for the `ubuntu` or `root` user.

          docker run \
            --privileged \
            --security-opt seccomp=unconfined \
            --tmpfs /run \
            --tmpfs /run/lock \
            --volume /sys/fs/cgroup:/sys/fs/cgroup:ro \
            --detach \
            --publish 2222:22 \
            cirocosta/ubuntu
          
          ssh root@localhost -p 2222
          Password: root

          ssh ubuntu@localhost -p 2222
          Password: ubuntu

  2.  Public and Private keys
    
      As the image represents a mini version of ubuntu and runs
      a normal sshd process you can mount your public key into
      /root/.ssh/authorized_keys and use your own private key.

          ssh-keygen -t rsa -b 4096 -C "test@test.com" -f ./key.rsa -P ""

            Generating public/private rsa key pair.
            Your identification has been saved in ./key.rsa.
            Your public key has been saved in ./key.rsa.pub.
            ...

          tree ./ 
            .
            ├── key.rsa
            └── key.rsa.pub

          chmod 400 ./key.rsa

          docker run \
            --privileged \
            --security-opt seccomp=unconfined \
            --tmpfs /run \
            --tmpfs /run/lock \
            --volume /sys/fs/cgroup:/sys/fs/cgroup:ro \
            --volume `pwd`/mykeys/key.rsa.pub:/root/.ssh/authorized_keys:ro \
            --detach \
            --publish 2222:22 \
            cirocosta/ubuntu
          
          ssh -i ./key.rsa root@localhost -p 2222


