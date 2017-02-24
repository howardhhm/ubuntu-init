#!/bin/bash
# @Author:       howardhhm
# @Email:        howardhhm@126.com
# @DateTime:     2017-02-23 15:00:38
# @Description:  Description

username=$(echo $SUDO_USER)
username=${username:-$(whoami)}
echo $username
sudo chown $username:$username ~/.viminfo
touch ~/.vimrc
sudo chown $username:$username ~/.vimrc
grep '=========== added by hhm ===========' ~/.vimrc
if [ $? -ne 0 ]; then
    sed -i '$ a =========== added by hhm ===========' ~/.vimrc
    cd
    wget --no-cache "https://raw.githubusercontent.com/howardhhm/ubuntu-init/"\
"master/vimrc"
    cat vimrc >> ~/.vimrc
    rm vimrc
    sed -i '$ a =========== added by hhm ===========' ~/.vimrc
fi
