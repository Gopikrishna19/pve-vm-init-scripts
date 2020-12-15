#!/bin/bash -l

apt update
apt dist-upgrade -y
apt remove -y wget git
apt install -y wget git nano openssh
wget --user=ssh-user --ask-password -qO - http://ssh-server.rg-10.hm/ssh/install.sh | bash
