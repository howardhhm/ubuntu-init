#!/bin/sh

############################################################################################
##                      Preparation
############################################################################################
wget https://raw.githubusercontent.com/howardhhm/ubuntu-init/master/netselect_0.3.ds1-26_amd64.deb
if [ ! -f ./netselect_0.3.ds1-26_amd64.deb ]; then
    echo -e "\033[41;37m CAN NOT FIND netselect FILE\!\! \033[0m"
    echo -e "\033[41;37m CAN NOT FIND netselect FILE\!\! \033[0m"
    echo -e "\033[41;37m CAN NOT FIND netselect FILE\!\! \033[0m"
    exit 127
else
    sudo dpkg -i netselect_0.3.ds1-26_amd64.deb
    rm -f netselect_0.3.ds1-26_amd64.deb
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
sudo apt-get upgrade
sudo apt-get install apt-file
sudo apt-file update

############################################################################################
##                      Common Software
############################################################################################
sudo apt-get install vim net-tools zsh git gcc unzip gcc ack-grep tmux byobu wget autojump

############################################################################################
##                      Share Resource
############################################################################################
wget https://raw.githubusercontent.com/howardhhm/ubuntu-init/master/sharerc
if [ ! -f ./sharerc ]; then
    echo -e "\033[41;37m CAN NOT FIND sharerc FILE\!\! \033[0m"
    echo -e "\033[41;37m CAN NOT FIND sharerc FILE\!\! \033[0m"
    echo -e "\033[41;37m CAN NOT FIND sharerc FILE\!\! \033[0m"
    exit 127
else
    sudo mv ./sharerc /etc/sharerc
fi
source /etc/sharerc

############################################################################################
##                      Python & Pip
############################################################################################
sudo apt-get install python-pip python-dev build-essential python3-pip
sudo apt-get install python2.7 python2.7-dev python3.5 python3.5-dev
sudo apt-get install build-essential libssl-dev libevent-dev libjpeg-dev libxml2-dev libxslt-dev

mkdir ~/.pip/
echo "[global]\ntimeout = 60\nindex-url = http://pypi.douban.com/simple" > ~/.pip/pip.conf
sudo pip install --upgrade pip $PIPDO
sudo pip install sklearn numpy scipy $PIPDO
# sudo apt-get install libmysqlclient-dev
# sudo pip install MySQL-python $PIPDO

wget https://raw.githubusercontent.com/howardhhm/ubuntu-init/master/.pythonstartup.py
if [ ! -f ./.pythonstartup.py ]; then
    echo -e "\033[41;37m CAN NOT FIND pythonstartup.py FILE\!\! \033[0m"
    echo -e "\033[41;37m CAN NOT FIND pythonstartup.py FILE\!\! \033[0m"
    echo -e "\033[41;37m CAN NOT FIND pythonstartup.py FILE\!\! \033[0m"
    exit 127
else
    sudo mv ./.pythonstartup.py ~/.pythonstartup.py
fi

############################################################################################
##                      Zsh
############################################################################################
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
tmp=`grep 'ZSH_THEME="rkj-repos"' ~/.zshrc &>/dev/null;echo $?`

if [ $tmp -ne 0 ]; then
    sed -i 's|^ZSH_THEME="robbyrussell"|ZSH_THEME="rkj-repos"|g' ~/.zshrc
    echo "set -o ignoreeof\nsource /usr/share/autojump/autojump.zsh" >> ~/.zshrc
    echo "export PYTHONSTARTUP=~/.pythonstartup.py" >> ~/.zshrc
    sed -i '3 a source /etc/sharerc' ~/.zshrc
fi

