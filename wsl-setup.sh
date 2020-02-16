#!/bin/sh
WIN_USERNAME=$1

# Get SSH keys from Windows environment
# Need to make the below block more readable, basically it sets permissions for ssh-keys. 
umask 077
if [ ! -d ~/.ssh ]
then
  cp -r /mnt/c/Users/$WIN_USERNAME/.ssh ~/
  chmod 600 ~/.ssh/config
  chmod 400 ~/.ssh/id*
fi

# Set less annoying permissions, this is just so I don't get annoying green bars when listing directories (Please don't judge me)
echo "\n#Setting less annoying permissions\numask 077\n" >> ~/.profile

# Setup SSH agent
cat ./ssh-scripts >> ~/.profile

# Set custom aliases to kill ssh-agent quickly
cat ./aliases >> ~/.profile

# Copy .vimrc
cp vimrc ~/.vimrc
# Copy .gitconfig
cp gitconfig ~/.gitconfig

## Debian Specific stuff

# Install ansible packages, for Debian like environments
sudo apt update -y
sudo apt upgrade -y
sudo apt install curl ansible vim openssh-client git -y

# Clean up
sudo apt autoremove --purge -y
sudo apt clean all

## Debian specific stuff ends here

exit 0
