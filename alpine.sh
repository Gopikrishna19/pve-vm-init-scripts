#!/bin/ash -l

apk update
apk upgrade
apk del wget git
apk add wget git
apk add nano
echo "export TERM=xterm" >> /etc/profile
