############################################################
# Dockerfile for ovirt-mirrorchecker
############################################################

FROM centos/python-35-centos7

MAINTAINER Nadav Goldin
USER root
LABEL io.k8s.description="ovirt-mirrorchecker" \
    io.k8s.display-name="ovirt-mirrorchecker" \
    io.openshift.expose-services="8080:http" \
    io.openshift.tags="builder,mirrorchecker" \
    io.openshift.s2i.scripts-url="image:///usr/libexec/s2i/"

RUN mkdir -p /mirrorchecker


COPY ["s2i/bin/run", "s2i/bin/assemble", "s2i/bin/save-artifacts", "s2i/bin/usage", "/usr/libexec/s2i/"]
COPY ["s2i/configs/mirrors.yaml", "/mirrorchecker/"]
COPY ["s2i/configs/mirrors.txt", "/mirrorchecker/"]

ENV SSH_SECRET_KEY none
CMD ["/usr/libexec/s2i/usage"]
