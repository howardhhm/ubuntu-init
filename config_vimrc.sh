#!/bin/bash
# @Author:       howardhhm
# @Email:        howardhhm@126.com
# @DateTime:     2017-02-23 15:00:38
# @Description:  Description

grep '=========== added by hhm ===========' ~/.vimrc
if [ $? -ne 0 ]; then
    sudo sed -i '$ a =========== added by hhm ===========' ~/.vimrc
    cd
    wget --no-cache "https://raw.githubusercontent.com/howardhhm/ubuntu-init/"\
"master/vimrc"
    cat vimrc >> ~/.vimrc
    rm vimrc
    chown $username:$username ~/.vimrc
    sudo sed -i '$ a =========== added by hhm ===========' ~/.vimrc
fi