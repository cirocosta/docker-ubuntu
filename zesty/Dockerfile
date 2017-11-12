FROM ubuntu:zesty

ADD https://github.com/krallin/tini/releases/download/v0.16.1/tini /tini

RUN set -x && \ 
    apt update -y && \
    apt install -y openssh-server git sudo && \
    chmod +x /tini

ADD ./sshd_config /etc/ssh/sshd_config
ADD ./keys/key.rsa.pub /root/.ssh/authorized_keys

RUN set -x && \
    ssh-keygen -A && \
    git config --system user.email "git@example.com" && \
    git config --system user.name "Git User" && \
    mkdir /var/run/sshd && \
    chmod 0755 /var/run/sshd && \
    chmod -R 600 /root/.ssh && \
    systemctl enable /lib/systemd/system/ssh.service  && \
    adduser \
      --home /home/ubuntu \
      --shell /bin/bash \
      --gecos "" \
      ubuntu && \
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' \
      -i /etc/pam.d/sshd && \
    echo "ubuntu:ubuntu" | chpasswd && \
    echo "root:root" | chpasswd


RUN set -e && \
    find /etc/systemd/system \
      /lib/systemd/system \
      -path '*.wants/*' \
      -not -name '*journald*' \
      -not -name '*ssh*' \
      -not -name '*systemd-tmpfiles*' \
      -not -name '*systemd-user-sessions*' \
      -exec rm \{} \; && \
    systemctl set-default multi-user.target

ENTRYPOINT [ "/bin/bash" ]
CMD [ "-c", "exec /sbin/init --log-target=journal 3>&1" ]
