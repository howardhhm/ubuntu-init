#!/bin/sh


############################################################################################
##                      Preparation
############################################################################################
if [ ! -f ./netselect_0.3.ds1-26_amd64.deb ]; then
    echo -e "\033[41;37m CAN NOT FIND netselect FILE\!\! \033[0m"
    echo -e "\033[41;37m CAN NOT FIND netselect FILE\!\! \033[0m"
    echo -e "\033[41;37m CAN NOT FIND netselect FILE\!\! \033[0m"
    exit 127
else
    sudo dpkg -i netselect_0.3.ds1-26_amd64.deb
fi

############################################################################################
##                      Ubuntu Source List Modification
############################################################################################
export OLDSOURCE=$(cat /etc/apt/sources.list | egrep  "(deb|# deb)" | sed "s/^# //g" | grep "deb " | cut -d " " -f2 | sort | uniq -c | sort -rn | sed  's/  */ /g;s/^ //g' | cut -d " " -f2 | head -1)
export NEWSOURCE=$(sudo netselect -s1 `wget -q -O- https://launchpad.net/ubuntu/+archivemirrors | grep -P -B8 "statusUP|statusSIX" | grep -o -P "(f|ht)tp.*\"" | tr '"\n' '  '` | sed  's/  */ /g;s/^ //g' | cut -d " " -f2 )

if [ ! -f /etc/apt/sources.list.bak ]; then
    sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
fi

sudo sed -i "s|$OLDSOURCE|$NEWSOURCE|g" /etc/apt/sources.list
sudo apt-get update

############################################################################################
##                      Common Software
############################################################################################
sudo apt install vim net-tools zsh git gcc unzip gcc ack-grep tmux wget autojump

############################################################################################
##                      Share Resource
############################################################################################
if [ ! -f ./sharerc ]; then
    echo -e "\033[41;37m CAN NOT FIND SHARERC FILE\!\! \033[0m"
    echo -e "\033[41;37m CAN NOT FIND SHARERC FILE\!\! \033[0m"
    echo -e "\033[41;37m CAN NOT FIND SHARERC FILE\!\! \033[0m"
    exit 127
else
    sudo cp ./sharerc /etc/sharerc
fi

############################################################################################
##                      Python & Pip
############################################################################################
sudo apt-get install python-pip python-dev build-essential python3-pip
sudo apt-get install python2.7 python2.7-dev python3.5 python3.5-dev
sudo apt-get install build-essential libssl-dev libevent-dev libjpeg-dev libxml2-dev libxslt-dev

echo "[global]\ntimeout = 60\nindex-url = http://pypi.douban.com/simple" > ~/.pip/pip.conf
mkdir ~/.pip/
sudo pip install --upgrade pip $PIPDO
sudo pip install sklearn $PIPDO

############################################################################################
##                      Zsh
############################################################################################
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
sed -i 's|^ZSH_THEME="robbyrussell"|ZSH_THEME="rkj-repos"|g' ~/.zshrc
echo "set -o ignoreeof\nsource /usr/share/autojump/autojump.zsh" >> ~/.zshrc
sed -i '3 a source /etc/sharerc' ~/.zshrc