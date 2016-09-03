#!/bin/bash
export USER_ID=$(id -u)
export GROUP_ID=$(id -g)
envsubst < /mirrorchecker/passwd.template > /tmp/passwd
export LD_PRELOAD=libnss_wrapper.so
export NSS_WRAPPER_PASSWD=/tmp/passwd
export NSS_WRAPPER_GROUP=/etc/group
cp /mirrorchecker/.ssh/ssh-private-key /mirrorchecker/.ssh/id_rsa
chown mirrorchecker:mirrorchecker /mirrorchecker/.ssh/id_rsa
chmod 600 /mirrorchecker/.ssh/id_rsa
exec "$@"
