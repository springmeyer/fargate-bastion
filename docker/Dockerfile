# docker build -t fargate-bastion -f docker/Dockerfile ./docker
# docker run -it fargate-bastion

FROM ubuntu:22.04
ENV DEBIAN_FRONTEND noninteractive
WORKDIR /home

RUN apt-get update && apt-get install unzip curl jq python-is-python3 netcat-traditional tini openssh-server awscli -y

RUN mkdir -p /run/sshd && \
    adduser --disabled-password --shell /bin/sh --gecos "" ops && \
    echo "ops:*" | chpasswd && \
    mkdir -p /home/ops/.ssh/ && \
    chown -R ops:ops /home/ops/.ssh/

EXPOSE 443
EXPOSE 42
EXPOSE 22

ADD entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "/bin/sh", "/usr/local/bin/entrypoint.sh" ]
