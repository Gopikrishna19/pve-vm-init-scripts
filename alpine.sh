#!/bin/ash -l

apk update
apk upgrade
apk del wget git
apk add wget git nano openssh
echo "export TERM=xterm" >> /etc/profile
wget --user=ssh-user --ask-password -qO - http://ssh-server.rg-10.hm/ssh/install.sh | ash
