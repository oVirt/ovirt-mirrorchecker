############################################################
# Dockerfile for ovirt-mirrorchecker
############################################################

FROM openshift/base-centos7

MAINTAINER Nadav Goldin
LABEL io.k8s.description="ovirt-mirrorchecker" \
    io.k8s.display-name="ovirt-mirrorchecker" \
    io.openshift.expose-services="8080:http" \
    io.openshift.tags="builder,mirrorchecker" \
    io.openshift.s2i.scripts-url="image:///usr/libexec/s2i/"

USER root
RUN ["adduser", "mirrorchecker"]
RUN ["mkdir", "/mirrorchecker"]
COPY ["configs/mirrors.yaml", "/mirrorchecker/"]
COPY ["configs/mirrors.txt", "/mirrorchecker/"]

ENV SSH_SECRET_KEY none
RUN echo "$SSH_SECRET_KEY" > /mirrorchecker/id_rsa
COPY ["configs/id_rsa", "/mirrorchecker/"]
RUN yum install -y centos-release-scl && yum install -y rh-python35 git
RUN yum install -y gcc libffi-devel python-devel openssl-devel  && yum clean all
RUN ["scl", "enable", "rh-python35", "pip install git+http://github.com/nvgoldin/mirrorchecker.git --no-cache-dir --process-dependency-links --allow-all-external"]
RUN ["scl", "enable", "rh-python35", "pip install cryptography"]
RUN ["chown", "-R", "mirrorchecker:mirrorchecker", "/mirrorchecker"]

USER mirrorchecker
CMD ["scl", "enable", "rh-python35", "mirror_checker.py --config_file=/mirrorchecker/mirrors.yaml"]
