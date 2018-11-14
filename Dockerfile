FROM centos:centos7

RUN yum install -y yum-plugin-priorities
RUN rpm -Uvh http://repo.opensciencegrid.org/osg/3.4/osg-3.4-el7-release-latest.rpm
RUN yum install -y epel-release
RUN yum install -y osg-ca-certs fetch-crl osg-ce-bosco
RUN yum install -y openssh-clients openssh-server
RUN yum install -y supervisor

RUN systemctl enable fetch-crl-cron
RUN systemctl enable fetch-crl-boot
RUN systemctl enable gratia-probes-cron

RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N ''
RUN ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ''
RUN ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N ''

COPY supervisord.conf /etc/
COPY sshd_config /etc/ssh/
COPY ce_startup_wrapper /usr/bin/ce_startup_wrapper

RUN adduser osg

RUN mkdir -p /etc/osg/config.d/
RUN touch /etc/osg/config.d/99-local.ini
RUN mkdir -p /etc/gratia/htcondor-ce/
RUN mkdir -p /home/osg/.ssh

ENTRYPOINT /usr/bin/supervisord -c /etc/supervisord.conf
