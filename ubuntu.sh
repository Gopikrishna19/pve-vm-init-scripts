#!/bin/bash -l

apt-get update
apt-get -y dist-upgrade
apt-get -y install git openssh-client
wget --user=ssh-user --ask-password -qO - http://ssh-server.rg-10.hm/ssh/install.sh | bash
