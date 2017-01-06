#!/bin/bash
# @Author:       howardhhm
# @Email:        howardhhm@126.com
# @DateTime:     2017-01-06 17:02:11
# @Description:  Description

################################################################################
##                      Preparation
################################################################################
## remove the previous cache
rm -rvf ~/ubuntu-init-tmp
mkdir ~/ubuntu-init-tmp

if [ "$HHM_UBUNTUINIT_SERVER" = "" ]; then
    HHM_UBUNTUINIT_CLIENT="1"
fi

## whoami returns root all the time
# username=$(whoami)
username=$(echo $SUDO_USER)
wget --no-cache "https://raw.githubusercontent.com/howardhhm/ubuntu-init/"\
"master/netselect_0.3.ds1-26_amd64.deb" -P ~/ubuntu-init-tmp
sudo dpkg -i ~/ubuntu-init-tmp/netselect_0.3.ds1-26_amd64.deb

################################################################################
##                      Ubuntu Source List Modification
################################################################################
export OLDSOURCE=$(cat /etc/apt/sources.list | egrep  "(deb|# deb)" \
| sed "s/^# //g" | grep "deb " | cut -d " " -f2 | sort | uniq -c | sort -rn \
| sed  's/  */ /g;s/^ //g' | cut -d " " -f2 | head -1)
## not reliable
# export NEWSOURCE=$(sudo netselect -s1 `wget --no-cache -q -O- \
# https://launchpad.net/ubuntu/+archivemirrors \
# | grep -P -B8 "statusUP|statusSIX" | grep -o -P "(f|ht)tp.*\"" \
# | tr '"\n' '  '` | sed  's/  */ /g;s/^ //g' | cut -d " " -f2)
# change into aliyun source lists
export NEWSOURCE="http://mirrors.aliyun.com/ubuntu/"

if [ ! -f /etc/apt/sources.list.bak ]; then
    sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
fi

sudo sed -i "s|$OLDSOURCE|$NEWSOURCE|g" /etc/apt/sources.list

## get fast sources shellscript
if [ ! -f /usr/local/bin/getfastsources ]; then
    wget --no-cache "https://raw.githubusercontent.com/howardhhm/ubuntu-init/"\
"master/get_fast_sources.sh" -P ~/ubuntu-init-tmp
    chmod a+rx ~/ubuntu-init-tmp/get_fast_sources.sh
    sudo mv ~/ubuntu-init-tmp/get_fast_sources.sh /usr/local/bin/getfastsources
fi
sudo chown root:root /usr/local/bin/getfastsources

sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get install -y apt-file
sudo apt-file update

################################################################################
##                      Share Resource
################################################################################
wget --no-cache "https://raw.githubusercontent.com/howardhhm/ubuntu-init/"\
"master/sharerc" -P ~/ubuntu-init-tmp
sudo mv ~/ubuntu-init-tmp/sharerc /etc/sharerc
source /etc/sharerc

################################################################################
##                      Source code pro
##          https://github.com/adobe-fonts/source-code-pro/downloads
################################################################################
if [ ! -d /usr/share/fonts/SourceCodePro-1.013 ]; then
    wget --no-cache "http://7xvxlx.com1.z0.glb.clouddn.com/"\
"SourceCodePro-1.013.tar.gz" -P ~/ubuntu-init-tmp
    sudo tar zxvf ~/ubuntu-init-tmp/SourceCodePro-1.013.tar.gz -C \
        /usr/share/fonts
    sudo fc-cache
fi
sudo chown root:root -R /usr/share/fonts

################################################################################
##                      Common Software
################################################################################
sudo apt-get install -y ack-grep autojump byobu cmatrix ctags dfc dos2unix \
    build-essential git htop net-tools ntpdate openssh-server subversion tmux \
    unzip vim wget
if [ "$HHM_UBUNTUINIT_CLIENT" = "1" ]; then
    sudo apt-get install -y filezilla meld okular pandoc speedcrunch terminator
fi
sudo ntpdate time.nist.gov
sudo apt-get install -y zsh
## To be solved
# sudo apt-get install -y chromium

## The commands below should be executed
## if the PC was installed windows and ubuntu
# sudo timedatectl set-local-rtc 1 --adjust-system-clock
# sudo timedatectl set-ntp 0
# sudo apt-get install -y ntpdate
# sudo ntpdate cn.pool.ntp.org

## haroopad (Markdown editor)
if [ "$HHM_UBUNTUINIT_CLIENT" = "1" ]; then
    if [ ! -f /usr/bin/haroopad ]; then
        wget --no-cache "http://7xvxlx.com1.z0.glb.clouddn.com/"\
"haroopad-v0.13.1-x64.deb" -P ~/ubuntu-init-tmp
        sudo dpkg -i ~/ubuntu-init-tmp/haroopad-v0.13.1-x64.deb
        sudo apt-get install -fy
    fi
fi

## java
# wget --no-cache --no-check-certificate --no-cookies --header \
# "Cookie: oraclelicense=accept-securebackup-cookie" \
# "http://download.oracle.com/otn-pub/java/jdk/"\
#"8u112-b15/jdk-8u112-linux-x64.tar.gz"
grep 'java' /etc/profile
if [ $? -eq 1 ]; then
    wget --no-cache "http://7xvxlx.com1.z0.glb.clouddn.com/"\
"jdk-8u112-linux-x64.tar.gz" -P ~/ubuntu-init-tmp
    sudo mkdir -p /usr/local/java/
    sudo tar -zxvf ~/ubuntu-init-tmp/jdk-8u112-linux-x64.tar.gz -P -C \
        /usr/local/java/
    sudo sed -i '$ a # java' /etc/profile
    sudo sed -i '$ a export JAVA_HOME=/usr/local/java/jdk1.8.0_112' \
        /etc/profile
    sudo sed -i '$ a export JAVA_BIN=$JAVA_HOME/bin' /etc/profile
    sudo sed -i '$ a export CLASSPATH=.:$JAVA_HOME/lib/dt.jar'\
':$JAVA_HOME/lib/tools.jar' /etc/profile
    sudo sed -i '$ a export PATH=$PATH:$JAVA_HOME/bin' /etc/profile
fi

## lantern
if [ "$HHM_UBUNTUINIT_CLIENT" = "1" ]; then
    if [ ! -f /usr/bin/lantern ]; then
        wget --no-cache "http://7xvxlx.com1.z0.glb.clouddn.com/"\
"lantern-installer-beta-64-bit.deb" -P ~/ubuntu-init-tmp
        sudo dpkg -i ~/ubuntu-init-tmp/lantern-installer-beta-64-bit.deb
        sudo apt-get install -fy
    fi
    ## remove the letter "#" in line "#/usr/bin/lantern",
    ## if you want start lantern automatically when you login
    grep 'lantern' /etc/rc.local
    if [ $? -eq 1 ]; then
        sudo sed -i "/exit 0/ i /usr/bin/lantern" /etc/rc.local
    fi
fi

## numlock
## method 1:
sudo apt-get -y install numlockx
grep 'numlockx' /usr/share/lightdm/lightdm.conf.d/50-unity-greeter.conf
if [ $? -eq 1 ]; then
    sudo sed -i '$ a greeter-setup-script=/usr/bin/numlockx on' \
        /usr/share/lightdm/lightdm.conf.d/50-unity-greeter.conf
fi
## method 2:
# sudo sed -i 's|^exit 0.*$|# Numlock enable\n[ -x /usr/bin/numlockx ]'\
#' \&\& numlockx on\n\nexit 0|' /etc/rc.local

## sogou
if [ "$HHM_UBUNTUINIT_CLIENT" = "1" ]; then
    if [ ! -f /usr/bin/sogou-diag ]; then
        wget --no-cache "http://7xvxlx.com1.z0.glb.clouddn.com/"\
"sogoupinyin_2.1.0.0082_amd64.deb" -P ~/ubuntu-init-tmp
        sudo dpkg -i ~/ubuntu-init-tmp/sogoupinyin_2.1.0.0082_amd64.deb
        sudo apt-get install -fy
    fi
fi
## speedtest
if [ ! -f /usr/local/bin/speedtest ]; then
    wget --no-cache --no-check-certificate "https://raw.githubusercontent.com/"\
"sivel/speedtest-cli/master/speedtest.py"
    chmod a+rx speedtest.py
    sudo mv speedtest.py /usr/local/bin/speedtest
fi
sudo chown root:root /usr/local/bin/speedtest

if [ "$HHM_UBUNTUINIT_CLIENT" = "1" ]; then
    ## sublime text 3
    if [ ! -f /usr/bin/subl ]; then
        wget --no-cache "http://7xvxlx.com1.z0.glb.clouddn.com/"\
"sublime-text_build-3126_amd64.deb" -P ~/ubuntu-init-tmp
        sudo dpkg -i ~/ubuntu-init-tmp/sublime-text_build-3126_amd64.deb
        sudo apt-get install -fy
    fi
    ## teamviewer
    if [ ! -f /usr/bin/teamviewer ]; then
        wget --no-cache "http://7xvxlx.com1.z0.glb.clouddn.com/"\
"teamviewer_i386.deb" -P ~/ubuntu-init-tmp
        sudo dpkg -i ~/ubuntu-init-tmp/teamviewer_i386.deb
        sudo apt-get install -fy
    fi
    ## terminator config
    wget --no-cache "https://raw.githubusercontent.com/howardhhm/ubuntu-init/"\
"master/terminator_config" -P ~/ubuntu-init-tmp
    mkdir -p ~/.config/terminator/
    mv ~/ubuntu-init-tmp/terminator_config ~/.config/terminator/config
    sudo chown $username:$username -R ~/.config
    ## highlight terminator tab color
    # grep -F "bg[NORMAL] = shade (1.02, @bg_color)"
    # /usr/share/themes/Ambiance/gtk-2.0/gtkrc
    sudo sed -i "s/bg\[NORMAL\] = shade (1.02, @bg_color)/bg\[NORMAL\] = "\
"shade (1.12, @bg_color)/g" /usr/share/themes/Ambiance/gtk-2.0/gtkrc
    # grep -F "bg[ACTIVE] = shade (0.97, @bg_color)"
    # /usr/share/themes/Ambiance/gtk-2.0/gtkrc
    sudo sed -i "s/bg\[ACTIVE\] = shade (0.97, @bg_color)/bg\[ACTIVE\] = "\
"shade (0.87, @bg_color)/g" /usr/share/themes/Ambiance/gtk-2.0/gtkrc
    ## apple green
    # grep -F "base_color:#ffffff" /usr/share/themes/Ambiance/gtk-2.0/gtkrc
    sudo sed -i "s/base_color:#ffffff/base_color:#cce8cf/g" \
        /usr/share/themes/Ambiance/gtk-2.0/gtkrc
    ## wps
    if [ ! -f /usr/bin/wps ]; then
        wget --no-cache "http://7xvxlx.com1.z0.glb.clouddn.com/"\
"wps-office_10.1.0.5672~a21_amd64.deb" -P ~/ubuntu-init-tmp
        sudo dpkg -i ~/ubuntu-init-tmp/wps-office_10.1.0.5672~a21_amd64.deb
        sudo apt-get install -fy
    fi

    ## delete old source lists
    cd /etc/apt/sources.list.d
    # sudo rm -rvf $(ls | grep -E "(exfat|codeblocks"\
    #"|wiznote|hzwhuang|caffeine|vokoscreen|shutter)")
    # sudo rm -rvf $(ls | grep -E "(codeblocks"\
    #"|wiznote|hzwhuang|caffeine|vokoscreen|shutter)")
    sudo rm -rvf $(ls | grep -E "(codeblocks|wiznote|hzwhuang|"\
"caffeine|shutter)")
    cd
    ## exfat something wrong
    # mount sdX to /mnt
    # sudo mount -t exfat /dev/sdX /mnt
    # sudo add-apt-repository -y ppa:relan/exfat

    ## codeblocks
    ## wx-config --version
    ## 3.0.2
    sudo add-apt-repository -y ppa:damien-moore/codeblocks
    ## wiz
    sudo add-apt-repository -y ppa:wiznote-team
    ## ss
    sudo add-apt-repository -y ppa:hzwhuang/ss-qt5
    ## flash anti-lock new version
    sudo add-apt-repository -y ppa:caffeine-developers/ppa
    ## vokoscreen (video monitor) a little problem
    # sudo add-apt-repository -y ppa:vokoscreen-dev/vokoscreen
    ## shutter (screenshot)
    sudo add-apt-repository -y ppa:shutter/ppa
    ### To be tested
    ### chrome
    if [ ! -f /etc/apt/sources.list.d/google-chrome.list ]; then
        sudo wget --no-cache "https://raw.githubusercontent.com/howardhhm/"\
"ubuntu-init/master/google-chrome.list" -P /etc/apt/sources.list.d/
    fi
    wget --no-cache -q -O - https://dl.google.com/linux/linux_signing_key.pub \
        | sudo apt-key add -

    ## update the sources
    sudo apt-get update
    ## you can separately execute the following command
    # sudo apt-get install -y caffeine

    ### To be tested
    ### chrome
    sudo apt-get install -y google-chrome-stable

    # sudo apt-get install -y codeblocks libwxgtk3.0-dev wx-common \
    #   codeblocks-contrib
    # sudo apt-get install -y exfat-utils
    # sudo apt-get install -y shutter
    # sudo apt-get install -y shadowsocks-qt5
    # sudo apt-get install -y vokoscreen
    # sudo apt-get install -y wiznote

    # sudo apt-get install -y caffeine codeblocks libwxgtk3.0-dev \
    #   wx-common codeblocks-contrib exfat-utils shutter shadowsocks-qt5 \
    #   vokoscreen wiznote
    sudo apt-get install -y caffeine codeblocks libwxgtk3.0-dev wx-common \
        codeblocks-contrib shutter shadowsocks-qt5 wiznote
fi

################################################################################
##                      Python & Pip
################################################################################
sudo apt-get install -y build-essential libevent-dev libjpeg-dev libssl-dev \
    libxml2-dev libxslt-dev python-dev python-pip python2.7 python2.7-dev \
    python3-pip python3.5 python3.5-dev python-tk

mkdir ~/.pip/
echo "[global]\ntimeout = 60\nindex-url = http://pypi.douban.com/simple" \
    > ~/.pip/pip.conf
sudo chown $username:$username -R ~/.pip
sudo pip2 install --upgrade pip --trusted-host=pypi.douban.com
sudo pip3 install --upgrade pip --trusted-host=pypi.douban.com
sudo
sudo pip2 install ipython matplotlib sklearn numpy scipy \
    --trusted-host=pypi.douban.com
sudo pip2 install powerline-status powerline-gitstatus psutil \
    --trusted-host=pypi.douban.com
sudo rm -f /usr/local/bin/pip
sudo ln -s /usr/local/bin/pip2 /usr/local/bin/pip
## Install MySQL-python
# sudo apt-get install -y libmysqlclient-dev
# sudo pip2 install MySQL-python $PIPDO

## python commandline auto-completion
if [ ! -f ~/.pythonstartup.py ]; then
    wget --no-cache "https://raw.githubusercontent.com/howardhhm/ubuntu-init/"\
"master/.pythonstartup.py" -P ~/
fi
sudo chown $username:$username ~/.pythonstartup.py

################################################################################
##                      Powerline
##       http://powerline.readthedocs.io/en/master/usage/other.html
################################################################################
## powerline for ipython
mkdir -p ~/.ipython/profile_default/
wget --no-cache "https://raw.githubusercontent.com/howardhhm/ubuntu-init/"\
"master/ipython_config.py" -P ~/ubuntu-init-tmp/
mv ~/ubuntu-init-tmp/ipython_config.py ~/.ipython/profile_default/
sudo chown $username:$username -R ~/.ipython/
## powerline for tmux
grep 'powerline' ~/.tmux.conf
if [ $? -eq 1 ]; then
    ## for ubuntu
    echo "source /usr/local/lib/python2.7/dist-packages/powerline/bindings/"\
"tmux/powerline.conf" >> ~/.tmux.conf
    ## for mac
    # echo "source /usr/local/lib/python2.7/site-packages/powerline/bindings/"\
#"tmux/powerline.conf" >> ~/.tmux.conf
fi
sudo chown $username:$username ~/.tmux.conf
## Install fonts for powerline
wget --no-cache http://7xvxlx.com1.z0.glb.clouddn.com/fonts.tar.gz \
    -P ~/ubuntu-init-tmp
tar zxvf ~/ubuntu-init-tmp/fonts.tar.gz -C ~/ubuntu-init-tmp
cd ~/ubuntu-init-tmp/fonts
sudo ./install.sh
## ~/.config/powerline
if [ ! -d ~/.config/powerline ]; then
    wget --no-cache "http://7xvxlx.com1.z0.glb.clouddn.com/"\
"powerline_config.tar.gz" -P ~/ubuntu-init-tmp
    tar zxvf ~/ubuntu-init-tmp/powerline_config.tar.gz -C ~/.config
fi
sudo chown $username:$username -R ~/.config
sudo chown $username:$username -R ~/ubuntu-init-tmp
################################################################################
##                      Zsh
################################################################################
# change the default shell
sudo chsh -s /bin/zsh

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/"\
"oh-my-zsh/master/tools/install.sh)"

## add the following code into ~/.zshrc
# ZSH_THEME="agnoster"
## source /etc/sharerc
## [AT THE END OF THE FILE]
## For python pressing Ctrl-D to exit and prevent from closing the terminator
# set -o ignoreeof
## enable control-s and control-q
# stty start undef
# stty stop undef
# setopt noflowcontrol
# source /usr/share/autojump/autojump.zsh
## For python automatic completion
# export PYTHONSTARTUP=~/.pythonstartup.py
grep 'ZSH_THEME="agnoster"' ~/.zshrc
if [ $? -eq 1 ]; then
    sed -i 's|^ZSH_THEME="robbyrussell"|ZSH_THEME="agnoster"|g' ~/.zshrc
    if [ "$HHM_UBUNTUINIT_CLIENT" = "1" ]; then
        sed -i '2 a export HHM_UBUNTUINIT_CLIENT="1"' ~/.zshrc
    fi
    if [ "$HHM_UBUNTUINIT_SERVER" = "1" ]; then
        sed -i '2 a export HHM_UBUNTUINIT_SERVER="1"' ~/.zshrc
    fi
    sed -i '3 a source /etc/sharerc' ~/.zshrc
    echo "stty start undef\nstty stop undef\nsetopt noflowcontrol\n" >> ~/.zshrc
    echo "set -o ignoreeof\nsource /usr/share/autojump/autojump.zsh" >> ~/.zshrc
    echo "export PYTHONSTARTUP=~/.pythonstartup.py" >> ~/.zshrc
fi
## powerline for zsh
grep 'powerline' ~/.zshrc
if [ $? -eq 1 ]; then
    echo "powerline-daemon -q" >> ~/.zshrc
    ## for ubuntu
    echo "source /usr/local/lib/python2.7/dist-packages/powerline/bindings/"\
"zsh/powerline.zsh" >> ~/.zshrc
    ## for mac
    # echo "#source /usr/local/lib/python2.7/site-packages/powerline/bindings/"\
#"zsh/powerline.zsh" >> ~/.zshrc
fi
################################################################################
##                      Last update
################################################################################
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y autoremove
