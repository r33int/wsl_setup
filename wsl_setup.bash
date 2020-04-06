#!/bin/bash
if [ -z $1 ]; then
    echo "Please supply Windows Username"
    exit 0
fi

WIN_USERNAME=$1

# Get SSH keys from Windows environment
umask 077
if [ ! -d ~/.ssh ]
then
  cp -r /mnt/c/Users/$WIN_USERNAME/.ssh ~/
  chmod 600 ~/.ssh/config
  chmod 400 ~/.ssh/id*
fi

# Setup SSH agent, umask, aliases and prompt
echo "umask 077" >> ~/.profile
cat ./scripts/ssh_scripts >> ~/.profile

## Debian Specific stuff
# Install ansible packages, for Debian like environments
sudo apt update -y
sudo apt upgrade -y
sudo apt install curl wget tmux vim openssh-client git man-db -y
# Repo clean up
sudo apt autoremove --purge -y
sudo apt clean all
## Debian specific stuff ends here

# Making changes to SSH client config, after it is installed
sudo sed -i "s/#   StrictHostKeyChecking ask/    StrictHostKeyChecking no/g" /etc/ssh/ssh_config
sudo sed -i 's/HashKnownHosts yes/HashKnownHosts no/' /etc/ssh/ssh_config
# Passwordless sudo
echo "echo \"$USER ALL=(ALL) NOPASSWD:ALL\" >> /etc/sudoers" | sudo bash

exit 0
