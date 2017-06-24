#!/bin/bash
# @Author:       howardhhm
# @Email:        howardhhm@126.com
# @DateTime:     2017-02-22 11:29:07
# @Description:  Description


## update kernel
sudo apt-get update
echo
echo "+++++++++++++++ alternative kernels +++++++++++++++"
export ALL=$(apt-cache search linux-image | grep -v lowlatency \
    | grep "Linux kernel image for version" | grep "generic" \
    | awk '{print $1}' | sed 's/-generic//g;s/linux-image-//g' \
    | sort -rV | head -n10)
for i in $ALL
do
    echo $i
done
echo "+++++++++++++++ kernels end +++++++++++++++"
echo
echo "+++++++++++++++ LATEST kernels start +++++++++++++++"
export LATEST=$(apt-cache search linux-image | grep -v lowlatency \
    | grep "Linux kernel image for version" | grep "generic" \
    | awk '{print $1}' | sed 's/-generic//g;s/linux-image-//g' \
    | sort -rV | head -n1)
echo $LATEST
echo "+++++++++++++++ LATEST kernels end +++++++++++++++"
echo
sudo apt-get install linux-image-$LATEST linux-headers-$LATEST \
    linux-headers-$LATEST-generic
sudo apt-get install linux-image-$LATEST-lowlatency \
    linux-headers-$LATEST-lowlatency

## remove system cache
sudo apt-get autoclean
sudo apt-get -y autoremove
## remove old images
echo
echo "+++++++++++++++ all kernels start +++++++++++++++"
dpkg --get-selections | grep linux- | awk '{print $1}'
echo "+++++++++++++++ all kernels end +++++++++++++++"
echo
export ALL=$(dpkg --get-selections | cut -f1 | grep -e "linux-image-[0-9]" \
| sed 's/-generic//g;s/linux-image-//g;s/-lowlatency//g' | sort -urV)
export LATEST=$(dpkg --get-selections | cut -f1 | grep -e "linux-image-[0-9]" \
| sed 's/-generic//g;s/linux-image-//g;s/-lowlatency//g' | sort -urV \
| head -n 1)
echo "+++++++++++++++ LATEST kernels start +++++++++++++++"

# display the latest kernel
dpkg --get-selections | grep linux | grep $LATEST | awk '{print $1}'

echo "+++++++++++++++ LATEST kernels end +++++++++++++++"
echo
export OLD=$(dpkg --get-selections | cut -f1 | grep -e "linux-image-[0-9]" \
| sed 's/-generic//g;s/linux-image-//g;s/-lowlatency//g' | grep -v $LATEST)
for i in $OLD
do
    sudo apt-get purge $(dpkg --get-selections | grep linux \
    | grep -v $LATEST | grep $i | cut -f1)
done
