#!/bin/sh
# @Author:       howardhhm
# @Email:        howardhhm@126.com
# @DateTime:     2016-12-14 10:59:48
# @Description:  Description

############################################################################################
##                      Preparation
############################################################################################
mkdir ~/tmp
wget https://raw.githubusercontent.com/howardhhm/ubuntu-init/master/netselect_0.3.ds1-26_amd64.deb -P ~/tmp
if [ ! -f ~/tmp/netselect_0.3.ds1-26_amd64.deb ]; then
    echo -e "\033[41;37m CAN NOT FIND netselect FILE\!\! \033[0m"
    echo -e "\033[41;37m CAN NOT FIND netselect FILE\!\! \033[0m"
    echo -e "\033[41;37m CAN NOT FIND netselect FILE\!\! \033[0m"
    exit 127
else
    sudo dpkg -i ~/tmp/netselect_0.3.ds1-26_amd64.deb
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
sudo apt-get install -y apt-file
sudo apt-file update

############################################################################################
##                      Share Resource
############################################################################################
wget https://raw.githubusercontent.com/howardhhm/ubuntu-init/master/sharerc -P ~/tmp
if [ ! -f ~/tmp/sharerc ]; then
    echo -e "\033[41;37m CAN NOT FIND sharerc FILE\!\! \033[0m"
    echo -e "\033[41;37m CAN NOT FIND sharerc FILE\!\! \033[0m"
    echo -e "\033[41;37m CAN NOT FIND sharerc FILE\!\! \033[0m"
    exit 127
else
    sudo mv ~/tmp/sharerc /etc/sharerc
fi
source /etc/sharerc

############################################################################################
##                      Source code pro
############################################################################################
wget http://7xvxlx.com1.z0.glb.clouddn.com/SourceCodePro_FontsOnly-1.013.tar.gz -P ~/tmp
sudo tar zxvf ~/tmp/SourceCodePro_FontsOnly-1.013.tar.gz -C /usr/share/fonts
sudo fc-cache

############################################################################################
##                      Common Software
############################################################################################
sudo apt-get install -y ack-grep autojump byobu chromium cmatrix ctags dfc filezilla gcc git htop meld net-tools ntpdate okular pandoc speedcrunch subversion terminator tmux unzip vim wget zsh
sudo ntpdate time.nist.gov
## The commands below should be executed
## if the PC was installed windows and ubuntu
# sudo timedatectl set-local-rtc 1 --adjust-system-clock
# sudo timedatectl set-ntp 0
# sudo apt install ntpdate
# sudo ntpdate cn.pool.ntp.org

## exfat
# mount sdX to /mnt
# sudo mount -t exfat /dev/sdX /mnt
sudo add-apt-repository -y ppa:relan/exfat
sudo apt-get update
sudo apt-get install -y exfat-utils
## codeblocks
## wx-config --version
## 3.0.2
sudo add-apt-repository -y ppa:damien-moore/codeblocks
sudo apt-get update
sudo apt-get install -y codeblocks libwxgtk3.0-dev wx-common codeblocks-contrib
## wiz
sudo add-apt-repository -y ppa:wiznote-team
sudo apt-get update
sudo apt-get install -y wiznote
## ss
sudo add-apt-repository -y ppa:hzwhuang/ss-qt5
sudo apt-get update
sudo apt-get install -y shadowsocks-qt5
## flash anti-lock new version
sudo add-apt-repository -y ppa:caffeine-developers/ppa
sudo apt-get update
sudo apt-get install -y caffeine
## sublime text 3
wget http://7xvxlx.com1.z0.glb.clouddn.com/sublime-text_build-3126_amd64.deb -P ~/tmp
sudo dpkg -i ~/tmp/sublime-text_build-3126_amd64.deb
## vokoscreen (video monitor)
sudo add-apt-repository -y ppa:vokoscreen-dev/vokoscreen
sudo apt-get update
sudo apt-get install -y vokoscreen
## numlock
## method 1:
sudo apt-get -y install numlockx
tmp=`grep 'numlockx' /usr/share/lightdm/lightdm.conf.d/50-unity-greeter.conf &>/dev/null;echo $?`
if [ $tmp -ne 0 ]; then
    sudo sed -i '$ a greeter-setup-script=/usr/bin/numlockx on' /usr/share/lightdm/lightdm.conf.d/50-unity-greeter.conf
fi
## method 2:
# sudo sed -i 's|^exit 0.*$|# Numlock enable\n[ -x /usr/bin/numlockx ] \&\& numlockx on\n\nexit 0|' /etc/rc.local

## speedtest
wget --no-check-certificate https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py
chmod a+rx speedtest.py
sudo mv speedtest.py /usr/local/bin/speedtest
sudo chown root:root /usr/local/bin/speedtest
## shutter (screenshot)
sudo add-apt-repository -y ppa:shutter/ppa
sudo apt-get update
sudo apt-get install -y shutter
## haroopad (Markdown editor)
wget http://7xvxlx.com1.z0.glb.clouddn.com/haroopad-v0.13.1-x64.deb -P ~/tmp
sudo dpkg -i ~/tmp/haroopad-v0.13.1-x64.deb
## chrome
sudo wget http://www.linuxidc.com/files/repo/google-chrome.list -P /etc/apt/sources.list.d/
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub  | sudo apt-key add -
sudo apt-get update
sudo apt-get install -y google-chrome-stable
## wps
wget http://7xvxlx.com1.z0.glb.clouddn.com/wps-office_10.1.0.5672~a21_amd64.deb -P ~/tmp
sudo dpkg -i ~/tmp/wps-office_10.1.0.5672~a21_amd64.deb
## sogou
wget http://7xvxlx.com1.z0.glb.clouddn.com/sogoupinyin_2.1.0.0082_amd64.deb -P ~/tmp
sudo dpkg -i ~/tmp/sogoupinyin_2.1.0.0082_amd64.deb

############################################################################################
##                      Python & Pip
############################################################################################
sudo apt-get install build-essential libevent-dev libjpeg-dev libssl-dev libxml2-dev libxslt-dev python-dev python-pip python2.7 python2.7-dev python3-pip python3.5 python3.5-dev python-tk

mkdir ~/.pip/
echo "[global]\ntimeout = 60\nindex-url = http://pypi.douban.com/simple" > ~/.pip/pip.conf
sudo pip install --upgrade pip $PIPDO
sudo pip install matplotlib sklearn numpy scipy $PIPDO
## Install MySQL-python
# sudo apt-get install -y libmysqlclient-dev
# sudo pip install MySQL-python $PIPDO

wget https://raw.githubusercontent.com/howardhhm/ubuntu-init/master/.pythonstartup.py -P ~/

############################################################################################
##                      Zsh
############################################################################################
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
## add the following code into ~/.zshrc
# ZSH_THEME="rkj-repos"
## source /etc/sharerc
## [AT THE END OF THE FILE]
## For python pressing Ctrl-D to exit
# set -o ignoreeof
## enable control-s and control-q
# stty start undef
# stty stop undef
# setopt noflowcontrol
# source /usr/share/autojump/autojump.zsh
## For python automatic completion
# export PYTHONSTARTUP=~/.pythonstartup.py
tmp=`grep 'ZSH_THEME="rkj-repos"' ~/.zshrc &>/dev/null;echo $?`
if [ $tmp -ne 0 ]; then
    sed -i 's|^ZSH_THEME="robbyrussell"|ZSH_THEME="rkj-repos"|g' ~/.zshrc
    sed -i '3 a source /etc/sharerc' ~/.zshrc
    echo "stty start undef\nstty stop undef\nsetopt noflowcontrol\n" >> ~/.zshrc
    echo "set -o ignoreeof\nsource /usr/share/autojump/autojump.zsh" >> ~/.zshrc
    echo "export PYTHONSTARTUP=~/.pythonstartup.py" >> ~/.zshrc
fi

