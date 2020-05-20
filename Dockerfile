############################################################
# Dockerfile for ovirt-mirrorchecker
############################################################

FROM openshift/base-centos7

MAINTAINER Nadav Goldin
LABEL io.k8s.description="ovirt-mirrorchecker" \
    io.k8s.display-name="ovirt-mirrorchecker" \
    io.openshift.expose-services="8080:http" \
    io.openshift.tags="builder,mirrorchecker"
EXPOSE 8080

USER root
RUN yum install -y centos-release-scl && yum install -y rh-python35 libffi-devel \
      python-devel openssl-devel nss_wrapper gettext gcc && yum clean all -y
RUN ["scl", "enable", "rh-python35", "pip install setuptools==18.5 --no-cache-dir --process-dependency-links --allow-all-external"]
RUN ["scl", "enable", "rh-python35", "pip install  git+https://gerrit.ovirt.org/mirrorchecker.git --no-cache-dir --process-dependency-links --allow-all-external"]
RUN ["mkdir", "/mirrorchecker"]

COPY ["configs/mirrors.yaml", "/mirrorchecker/"]
COPY ["configs/mirrors.txt", "/mirrorchecker/"]
COPY ["bin/entry_point.sh", "/mirrorchecker/"]
COPY ["templates/passwd.template", "/mirrorchecker/"]

RUN  ["chown", "-R", "6060:6060", "/mirrorchecker"]

USER 6060
WORKDIR /mirrorchecker
CMD ["/mirrorchecker/entry_point.sh", "scl", "enable", "rh-python35", "mirror_checker.py --config_file=/mirrorchecker/mirrors.yaml"]
