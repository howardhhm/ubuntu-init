#!/bin/sh
# @Author:       howardhhm
# @Email:        howardhhm@126.com
# @DateTime:     2016-12-21 12:43:41
# @Description:  Description

export OLDSOURCE=$(cat /etc/apt/sources.list | egrep  "(deb|# deb)" | sed "s/^# //g" | grep "deb " | cut -d " " -f2 | sort | uniq -c | sort -rn | sed  's/  */ /g;s/^ //g' | cut -d " " -f2 | head -1)
export NEWSOURCE=$(sudo netselect -s1 `wget -q -O- https://launchpad.net/ubuntu/+archivemirrors | grep -P -B8 "statusUP|statusSIX" | grep -o -P "(f|ht)tp.*\"" | tr '"\n' '  '` | sed  's/  */ /g;s/^ //g' | cut -d " " -f2 )

if [ ! -f /etc/apt/sources.list.bak ]; then
    sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
fi

sudo sed -i "s|$OLDSOURCE|$NEWSOURCE|g" /etc/apt/sources.list

sudo apt-get update
# sudo apt-get -y upgrade