#!/bin/bash -l

apt-get update
apt-get -y dist-upgrade
apt-get -y remove wget git
apt-get -y install wget git nano openssh
wget --user=ssh-user --ask-password -qO - http://ssh-server.rg-10.hm/ssh/install.sh | bash
