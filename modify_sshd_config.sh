#!/bin/bash
# @Author:       howardhhm
# @Email:        howardhhm@126.com
# @DateTime:     2017-02-21 20:41:43
# @Description:  Description

grep '=========== added by hhm ===========' /etc/ssh/sshd_config
if [ $? -ne 0 ]; then
    sudo sed -i '$ a # =========== added by hhm ===========' /etc/ssh/sshd_config
    ## speed up
    sudo sed -i '$ a GSSAPIAuthentication no' /etc/ssh/sshd_config
    sudo sed -i '$ a UseDNS no' /etc/ssh/sshd_config
    ## keep online
    sudo sed -i '$ a ClientAliveInterval 60' /etc/ssh/sshd_config
    sudo sed -i '$ a ClientAliveCountMax 3' /etc/ssh/sshd_config
    sudo sed -i '$ a # =========== added by hhm ===========' /etc/ssh/sshd_config
    ## restart
    sudo service ssh restart
fi
