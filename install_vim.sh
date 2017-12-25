#!/bin/bash

####################################
#Author:      howardhhm
#Email:       howardhhm@126.com
#DateTime:    25-12-2017 10:19
#Description: Description
####################################

username=$(echo $SUDO_USER)
mkdir ~/debian-init-tmp
wget --no-cache "http://7xvxlx.com1.z0.glb.clouddn.com/vim.tar.gz" -P \
    ~/debian-init-tmp
mkdir ~/.vim
rm -rvf ~/.vim/*
tar zxvf ~/debian-init-tmp/vim.tar.gz -C ~/.vim
sudo chown $username:$username -R ~/.viminfo ~/.vimrc ~/.vim
echo "********* DONE *********"
