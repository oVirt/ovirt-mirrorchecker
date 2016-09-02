############################################################
# Dockerfile for ovirt-mirrorchecker
############################################################

FROM openshift/base-centos7

MAINTAINER Nadav Goldin
LABEL io.k8s.description="ovirt-mirrorchecker" \
    io.k8s.display-name="ovirt-mirrorchecker" \
    io.openshift.expose-services="8080:http" \
    io.openshift.tags="builder,mirrorchecker" 

USER root
RUN ["mkdir", "/mirrorchecker"]
COPY ["configs/mirrors.yaml", "/mirrorchecker/"]
COPY ["configs/mirrors.txt", "/mirrorchecker/"]

RUN yum install -y centos-release-scl && yum install -y rh-python35 git
RUN yum install -y gcc libffi-devel python-devel openssl-devel  && yum clean all
RUN ["scl", "enable", "rh-python35", "pip install git+http://github.com/nvgoldin/mirrorchecker.git --no-cache-dir --process-dependency-links --allow-all-external"]
RUN ["scl", "enable", "rh-python35", "pip install cryptography"]

EXPOSE 8080
USER 0
CMD ["scl", "enable", "rh-python35", "mirror_checker.py --config_file=/mirrorchecker/mirrors.yaml"]

