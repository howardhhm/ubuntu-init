#!/bin/bash
# @Author:       howardhhm
# @Email:        howardhhm@126.com
# @DateTime:     2017-02-22 11:29:07
# @Description:  Description

## remove system cache
sudo apt-get autoclean
sudo apt-get autoremove
## remove old images
echo
echo "+++++++++++++++ all images start +++++++++++++++"
dpkg --get-selections | grep linux
echo "+++++++++++++++ all images end +++++++++++++++"
echo
export ALL=$(dpkg --get-selections | grep -v linux-image-extra \
| grep -e "linux-image-[0-9]"| cut -f1 | sed "s|-generic||g;s|"\
"linux-image-||g" | sort -r)
export LATEST=$(dpkg --get-selections | grep -v linux-image-extra \
| grep -e "linux-image-[0-9]"| cut -f1 | sed "s|-generic||g;s|"\
"linux-image-||g" | sort -r | head -n 1)
echo "+++++++++++++++ LATEST images start +++++++++++++++"
for i in $LATEST
do
    dpkg --get-selections | grep linux | grep $i
done
echo "+++++++++++++++ LATEST images end +++++++++++++++"
echo
export OLD=$(dpkg --get-selections | grep -v linux-image-extra \
| grep -e "linux-image-[0-9]"| cut -f1 | sed "s|-generic||g;s|"\
"linux-image-||g" | grep -v $LATEST)
for i in $OLD
do
    sudo apt-get purge $(dpkg --get-selections | grep linux \
    | grep -v $LATEST | grep $i | cut -f1)
done
