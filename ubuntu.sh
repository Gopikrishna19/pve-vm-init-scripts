#!/bin/bash -l

apt update
apt -y dist-upgrade
apt -y remove wget git
apt -y install wget git nano openssh
wget --user=ssh-user --ask-password -qO - http://ssh-server.rg-10.hm/ssh/install.sh | bash
