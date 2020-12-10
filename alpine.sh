#!/bin/ash -l

apk update
apk upgrade
apk del wget git
apk add wget git nano openssh
echo "export TERM=xterm" >> /etc/profile
wget -qO --user=ssh-user --ask-password - http://ssh-server.rg-10.hm/ssh/install.sh | ash
