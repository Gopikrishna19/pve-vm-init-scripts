#!/bin/ash -l

apk update
apk upgrade
apk del wget git
apk add wget git nano openssh
echo "export TERM=xterm" >> /etc/profile
