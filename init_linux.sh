#!/bin/bash
# @Author:       howardhhm
# @Email:        howardhhm@126.com
# @DateTime:     2017-02-21 10:59:06
# @Description:  Description

################################################################################
##                      Preparation
################################################################################
## remove the previous cache
rm -rvf ~/debian-init-tmp
mkdir ~/debian-init-tmp

### the macros
## HHM_UBUNTU_INIT_CLIENT
## HHM_UBUNTU_INIT_SERVER
## HHM_DEBIAN_INIT_SERVER
## HHM_SKIP_SOURCES_SELECTION
## HHM_INTERNATIONAL
## HHM_FAST_INIT

## ubuntu client
if [ "$HHM_UBUNTU_INIT_SERVER" = "" -a "$HHM_DEBIAN_INIT_SERVER" = "" ]; then
    HHM_UBUNTU_INIT_CLIENT="1"
fi

## pip source
if [ "$HHM_INTERNATIONAL" = "1" ]; then
    HHM_PIP_TRUST_HOST=""
else
    HHM_PIP_TRUST_HOST="--trusted-host=mirrors.aliyun.com"
fi

## whoami returns root all the time
# username=$(whoami)
username=$(echo $SUDO_USER)
## a tool for source selection
wget --no-cache "https://raw.githubusercontent.com/howardhhm/ubuntu-init/"\
"master/netselect_0.3.ds1-26_amd64.deb" -P ~/debian-init-tmp
dpkg -i ~/debian-init-tmp/netselect_0.3.ds1-26_amd64.deb

################################################################################
##                      Ubuntu Source List Modification
################################################################################
if [ "$HHM_SKIP_SOURCES_SELECTION" = "" ]; then
    ## get old sources
    export OLDSOURCE=$(cat /etc/apt/sources.list | egrep  "(deb|# deb)" \
    | sed "s/^# //g" | grep "deb " | cut -d " " -f2 | sort | uniq -c | sort -rn \
    | sed  's/  */ /g;s/^ //g' | cut -d " " -f2 | head -1)
    ## not reliable
    # export NEWSOURCE=$(netselect -s1 `wget --no-cache -q -O- \
    # https://launchpad.net/ubuntu/+archivemirrors \
    # | grep -P -B8 "statusUP|statusSIX" | grep -o -P "(f|ht)tp.*\"" \
    # | tr '"\n' '  '` | sed  's/  */ /g;s/^ //g' | cut -d " " -f2)
    ## for debian or ubuntu
    if [ "$HHM_DEBIAN_INIT_SERVER" = "1" ]; then
        # change into 163 source lists
        export NEWSOURCE="http://mirrors.163.com/debian/"
    else
        # change into aliyun source lists
        export NEWSOURCE="http://mirrors.aliyun.com/ubuntu/"
    fi
    ## backup
    if [ ! -f /etc/apt/sources.list.bak ]; then
        cp /etc/apt/sources.list /etc/apt/sources.list.bak
    fi
    ## replacement
    sed -i "s|$OLDSOURCE|$NEWSOURCE|g" /etc/apt/sources.list
fi

## get fast sources shellscript
if [ ! -f /usr/local/bin/get_fast_sources ]; then
    wget --no-cache "https://raw.githubusercontent.com/howardhhm/ubuntu-init/"\
"master/get_fast_sources.sh" -P ~/debian-init-tmp
    chmod a+rx ~/debian-init-tmp/get_fast_sources.sh
    mv ~/debian-init-tmp/get_fast_sources.sh /usr/local/bin/get_fast_sources
fi
chown root:root /usr/local/bin/get_fast_sources

## update all pip packages
if [ ! -f /usr/local/bin/update_pip_all ]; then
    wget --no-cache "https://raw.githubusercontent.com/howardhhm/ubuntu-init/"\
"master/update_pip_all" -P ~/debian-init-tmp
    chmod a+rx ~/debian-init-tmp/update_pip_all
    mv ~/debian-init-tmp/update_pip_all /usr/local/bin/update_pip_all
fi
chown root:root /usr/local/bin/update_pip_all

## update
apt-get update
if [ "$HHM_FAST_INIT" = "" ]; then
    apt-get -y upgrade
fi
apt-get install -y apt-file
apt-file update

################################################################################
##                      Share Resource
################################################################################
wget --no-cache "https://raw.githubusercontent.com/howardhhm/ubuntu-init/"\
"master/sharerc" -P ~/debian-init-tmp
mv ~/debian-init-tmp/sharerc /etc/sharerc
source /etc/sharerc

################################################################################
##                      Source code pro
##          https://github.com/adobe-fonts/source-code-pro/downloads
################################################################################
if [ ! -d /usr/share/fonts/source-code-pro-2.030R-ro-1.050R-it ]; then
    wget --no-cache "http://7xvxlx.com1.z0.glb.clouddn.com/"\
"source-code-pro-2.030R-ro-1.050R-it.tar.gz" -P ~/debian-init-tmp
    tar zxvf ~/debian-init-tmp/source-code-pro-2.030R-ro-1.050R-it.tar.gz -C \
        /usr/share/fonts
    fc-cache
fi
chown root:root -R /usr/share/fonts

################################################################################
##                      Common Software
################################################################################
apt-get install -y ack-grep autojump cmatrix dos2unix \
    exuberant-ctags htop net-tools ntpdate openssh-server \
    subversion tmux unzip vim wget
apt-get install -y screenfetch

if [ "$HHM_DEBIAN_INIT_SERVER" = "" ]; then
    apt-get install -y dfc
fi
if [ "$HHM_UBUNTU_INIT_CLIENT" = "1" ]; then
    apt-get install -y filezilla meld okular pandoc speedcrunch terminator
    apt-get install -y classicmenu-indicator dia gparted variety vlc
    apt-get install -y mypaint
    apt-get install -y geogebra
fi
ntpdate time.nist.gov
apt-get install -y git
apt-get install -y curl
apt-get install -y zsh
## To be solved
# apt-get install -y chromium

## The commands below should be executed
## if the PC was installed windows and ubuntu
# timedatectl set-local-rtc 1 --adjust-system-clock
# timedatectl set-ntp 0
# apt-get install -y ntpdate
# ntpdate cn.pool.ntp.org

## haroopad (Markdown editor)
if [ "$HHM_UBUNTU_INIT_CLIENT" = "1" ]; then
    if [ ! -f /usr/bin/haroopad ]; then
        wget --no-cache "http://7xvxlx.com1.z0.glb.clouddn.com/"\
"haroopad-v0.13.1-x64.deb" -P ~/debian-init-tmp
        dpkg -i ~/debian-init-tmp/haroopad-v0.13.1-x64.deb
        apt-get install -fy
    fi
fi

## java
# wget --no-cache --no-check-certificate --no-cookies --header \
# "Cookie: oraclelicense=accept-securebackup-cookie" \
# "http://download.oracle.com/otn-pub/java/jdk/"\
#"8u112-b15/jdk-8u112-linux-x64.tar.gz"
grep 'java' /etc/profile
if [ $? -ne 0 ]; then
    wget --no-cache "http://7xvxlx.com1.z0.glb.clouddn.com/"\
"jdk-8u112-linux-x64.tar.gz" -P ~/debian-init-tmp
    apt-get autoremove -y openjdk-6-jre openjdk-7-jre
    mkdir -p /usr/local/java/
    tar -zxvf ~/debian-init-tmp/jdk-8u112-linux-x64.tar.gz -P -C \
        /usr/local/java/
    ## add envs into /etc/profile
    sed -i '$ a # java' /etc/profile
    sed -i '$ a export JAVA_HOME=/usr/local/java/jdk1.8.0_112' \
        /etc/profile
    sed -i '$ a export JAVA_BIN=$JAVA_HOME/bin' /etc/profile
    sed -i '$ a export CLASSPATH=.:$JAVA_HOME/lib/dt.jar'\
':$JAVA_HOME/lib/tools.jar' /etc/profile
    sed -i '$ a export PATH=$PATH:$JAVA_HOME/bin' /etc/profile
fi

## lantern
if [ "$HHM_UBUNTU_INIT_CLIENT" = "1" ]; then
    if [ ! -f /usr/bin/lantern ]; then
        wget --no-cache "http://7xvxlx.com1.z0.glb.clouddn.com/"\
"lantern-installer-beta-64-bit.deb" -P ~/debian-init-tmp
        dpkg -i ~/debian-init-tmp/lantern-installer-beta-64-bit.deb
        apt-get install -fy
    fi
    ## remove the letter "#" in line "#/usr/bin/lantern",
    ## if you want start lantern automatically when you login
    grep 'lantern' /etc/rc.local
    if [ $? -ne 0 ]; then
        sed -i "/exit 0/ i /usr/bin/lantern" /etc/rc.local
    fi
fi

if [ "$HHM_DEBIAN_INIT_SERVER" = "" ]; then
    ## numlock
    ## method 1:
    apt-get -y install numlockx
    grep 'numlockx' /usr/share/lightdm/lightdm.conf.d/50-unity-greeter.conf
    if [ $? -ne 0 ]; then
        sed -i '$ a greeter-setup-script=/usr/bin/numlockx on' \
            /usr/share/lightdm/lightdm.conf.d/50-unity-greeter.conf
    fi
    ## method 2:
    # sed -i 's|^exit 0.*$|# Numlock enable\n[ -x /usr/bin/numlockx ]'\
    #' \&\& numlockx on\n\nexit 0|' /etc/rc.local
fi

## sogou
if [ "$HHM_UBUNTU_INIT_CLIENT" = "1" ]; then
    if [ ! -f /usr/bin/sogou-diag ]; then
        wget --no-cache "http://7xvxlx.com1.z0.glb.clouddn.com/"\
"sogoupinyin_2.1.0.0082_amd64.deb" -P ~/debian-init-tmp
        dpkg -i ~/debian-init-tmp/sogoupinyin_2.1.0.0082_amd64.deb
        apt-get install -fy
    fi
fi
## speedtest
if [ ! -f /usr/local/bin/speedtest ]; then
    wget --no-cache --no-check-certificate "https://raw.githubusercontent.com/"\
"sivel/speedtest-cli/master/speedtest.py"
    chmod a+rx speedtest.py
    mv speedtest.py /usr/local/bin/speedtest
fi
chown root:root /usr/local/bin/speedtest

if [ "$HHM_UBUNTU_INIT_CLIENT" = "1" ]; then
    ## sublime text 3
    if [ ! -f /usr/bin/subl ]; then
        wget --no-cache "http://7xvxlx.com1.z0.glb.clouddn.com/"\
"sublime-text_build-3126_amd64.deb" -P ~/debian-init-tmp
        dpkg -i ~/debian-init-tmp/sublime-text_build-3126_amd64.deb
        apt-get install -fy
    fi
    ## teamviewer
    if [ ! -f /usr/bin/teamviewer ]; then
        wget --no-cache "http://7xvxlx.com1.z0.glb.clouddn.com/"\
"teamviewer_i386.deb" -P ~/debian-init-tmp
        dpkg -i ~/debian-init-tmp/teamviewer_i386.deb
        apt-get install -fy
    fi
    ## terminator config
    wget --no-cache "https://raw.githubusercontent.com/howardhhm/ubuntu-init/"\
"master/terminator_config" -P ~/debian-init-tmp
    mkdir -p ~/.config/terminator/
    mv ~/debian-init-tmp/terminator_config ~/.config/terminator/config
    chown $username:$username -R ~/.config

    ## backup gtkrc
    if [ ! -f /usr/share/themes/Ambiance/gtk-2.0/gtkrc.bak ]; then
        cp /usr/share/themes/Ambiance/gtk-2.0/gtkrc \
            /usr/share/themes/Ambiance/gtk-2.0/gtkrc.bak
    fi
    ## highlight terminator tab color
    # grep -F "bg[NORMAL] = shade (1.02, @bg_color)"
    # /usr/share/themes/Ambiance/gtk-2.0/gtkrc
    sed -i "s/bg\[NORMAL\] = shade (1.02, @bg_color)/bg\[NORMAL\] = "\
"shade (1.12, @bg_color)/g" /usr/share/themes/Ambiance/gtk-2.0/gtkrc
    # grep -F "bg[ACTIVE] = shade (0.97, @bg_color)"
    # /usr/share/themes/Ambiance/gtk-2.0/gtkrc
    sed -i "s/bg\[ACTIVE\] = shade (0.97, @bg_color)/bg\[ACTIVE\] = "\
"shade (0.87, @bg_color)/g" /usr/share/themes/Ambiance/gtk-2.0/gtkrc
    ## apple green
    # grep -F "base_color:#ffffff" /usr/share/themes/Ambiance/gtk-2.0/gtkrc
    sed -i "s/base_color:#ffffff/base_color:#cce8cf/g" \
        /usr/share/themes/Ambiance/gtk-2.0/gtkrc
    ## wps
    if [ ! -f /usr/bin/wps ]; then
        wget --no-cache "http://7xvxlx.com1.z0.glb.clouddn.com/"\
"wps-office_10.1.0.5672~a21_amd64.deb" -P ~/debian-init-tmp
        dpkg -i ~/debian-init-tmp/wps-office_10.1.0.5672~a21_amd64.deb
        apt-get install -fy
    fi

    ## a screen shot app developed by deepin
    if [ ! -f /usr/bin/deepin-scrot ]; then
        wget --no-cache "http://7xvxlx.com1.z0.glb.clouddn.com/"\
"deepin-scrot_2.0-0deepin_all.deb" -P ~/debian-init-tmp
        dpkg -i ~/debian-init-tmp/deepin-scrot_2.0-0deepin_all.deb
        apt-get install -fy
    fi

    ## delete old source lists
    cd /etc/apt/sources.list.d
    # rm -rvf $(ls | grep -E "(exfat|codeblocks"\
    #"|wiznote|hzwhuang|caffeine|vokoscreen|shutter)")
    # rm -rvf $(ls | grep -E "(codeblocks"\
    #"|wiznote|hzwhuang|caffeine|vokoscreen|shutter)")
    rm -rvf $(ls | grep -E "(codeblocks|wiznote|hzwhuang|"\
"caffeine|shutter)")
    cd
    ## exfat something wrong
    # mount sdX to /mnt
    # mount -t exfat /dev/sdX /mnt
    # add-apt-repository -y ppa:relan/exfat

    ## codeblocks
    ## wx-config --version
    ## 3.0.2
    add-apt-repository -y ppa:damien-moore/codeblocks
    ## wiz
    add-apt-repository -y ppa:wiznote-team
    ## ss
    add-apt-repository -y ppa:hzwhuang/ss-qt5
    ## flash anti-lock new version
    add-apt-repository -y ppa:caffeine-developers/ppa
    ## vokoscreen (video monitor) a little problem
    # add-apt-repository -y ppa:vokoscreen-dev/vokoscreen
    ## shutter (screenshot)
    add-apt-repository -y ppa:shutter/ppa
    ### To be tested
    ### chrome
    if [ ! -f /etc/apt/sources.list.d/google-chrome.list ]; then
        wget --no-cache "https://raw.githubusercontent.com/howardhhm/"\
"ubuntu-init/master/google-chrome.list" -P /etc/apt/sources.list.d/
    fi
    wget --no-cache -q -O - https://dl.google.com/linux/linux_signing_key.pub \
        | apt-key add -

    ## update the sources
    apt-get update
    ## you can separately execute the following command
    # apt-get install -y caffeine

    ### To be tested
    ### chrome
    apt-get install -y google-chrome-stable

    # apt-get install -y codeblocks libwxgtk3.0-dev wx-common \
    #   codeblocks-contrib
    # apt-get install -y exfat-utils
    # apt-get install -y shutter
    # apt-get install -y shadowsocks-qt5
    # apt-get install -y vokoscreen
    # apt-get install -y wiznote

    # apt-get install -y caffeine codeblocks libwxgtk3.0-dev \
    #   wx-common codeblocks-contrib exfat-utils shutter shadowsocks-qt5 \
    #   vokoscreen wiznote
    apt-get install -y caffeine codeblocks libwxgtk3.0-dev wx-common \
        codeblocks-contrib shutter shadowsocks-qt5 wiznote

    ## shutdown annoying error messages when login
    sed -i "s/enabled=1/enabled=0/g" /etc/default/apport
fi

################################################################################
##                      Python & Pip
################################################################################
apt-get install -y build-essential libevent-dev libjpeg-dev libssl-dev \
    libxml2-dev libxslt-dev
apt-get install -y python-dev python-pip python2.7 python2.7-dev
apt-get install -y python3-pip python3.5 python3.5-dev python-tk
## if the command above does not work
## follow these commands
if [ ! -f /usr/pip -o ! -f /usr/pip3 ]; then
    curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py"
    mv get-pip.py ~/debian-init-tmp/get-pip.py
    rm -f ~/.pip/pip.conf
    python ~/debian-init-tmp/get-pip.py
    python3 ~/debian-init-tmp/get-pip.py
fi
env-update && source /etc/profile

## pip source
if [ "$HHM_INTERNATIONAL" = "" ]; then
    mkdir ~/.pip/
    echo "[global]\ntrusted-host = mirrors.aliyun.com\n"\
"index-url = http://mirrors.aliyun.com/pypi/simple\n" \
        > ~/.pip/pip.conf
fi

chown $username:$username -R ~/.pip
pip2 install --upgrade pip $HHM_PIP_TRUST_HOST
pip3 install --upgrade pip $HHM_PIP_TRUST_HOST

## jupyter
if [ "$HHM_UBUNTU_INIT_SERVER" = "1" ]; then
    pip3 install jupyter setuptools $HHM_PIP_TRUST_HOST
fi

## soft link pip2
rm -f /usr/local/bin/pip
ln -s /usr/local/bin/pip2 /usr/local/bin/pip
cp $(ls /usr/local/bin/pip2.*) /usr/local/bin/pip2

## packages for machine learning
pip2 install ipython matplotlib numpy scipy setuptools sklearn requests pylint\
    flake8 pandas spyder supervisor $HHM_PIP_TRUST_HOST
## packages for powerline
## caution: svnstatus needs reboot
pip2 install powerline-status powerline-gitstatus powerline-svnstatus psutil \
    flake8 $HHM_PIP_TRUST_HOST

## Install MySQL-python
# apt-get install -y libmysqlclient-dev
# pip2 install MySQL-python $PIPDO

## python commandline auto-completion
if [ ! -f ~/.pythonstartup.py ]; then
    wget --no-cache "https://raw.githubusercontent.com/howardhhm/ubuntu-init/"\
"master/.pythonstartup.py" -P ~/
fi
chown $username:$username ~/.pythonstartup.py

################################################################################
##                      Powerline
##       http://powerline.readthedocs.io/en/master/usage/other.html
################################################################################
## powerline for ipython
mkdir -p ~/.ipython/profile_default/
wget --no-cache "https://raw.githubusercontent.com/howardhhm/ubuntu-init/"\
"master/ipython_config.py" -P ~/debian-init-tmp/
mv ~/debian-init-tmp/ipython_config.py ~/.ipython/profile_default/
chown $username:$username -R ~/.ipython/

## Install fonts for powerline
wget --no-cache http://7xvxlx.com1.z0.glb.clouddn.com/fonts.tar.gz \
    -P ~/debian-init-tmp
tar zxvf ~/debian-init-tmp/fonts.tar.gz -C ~/debian-init-tmp
cd ~/debian-init-tmp/fonts
./install.sh
## ~/.config/powerline
if [ ! -d ~/.config/powerline ]; then
    wget --no-cache "http://7xvxlx.com1.z0.glb.clouddn.com/"\
"powerline_configuration.tar.gz" -P ~/debian-init-tmp
    mkdir ~/.config
    tar zxvf ~/debian-init-tmp/powerline_configuration.tar.gz -C ~/.config
fi
chown $username:$username -R ~/.config
chown $username:$username -R ~/debian-init-tmp
################################################################################
##                      tmux
################################################################################
## powerline for tmux
grep 'powerline' ~/.tmux.conf
if [ $? -ne 0 ]; then
    ## for ubuntu
    echo "source /usr/local/lib/python2.7/dist-packages/powerline/bindings/"\
"tmux/powerline.conf" >> ~/.tmux.conf
    ## for mac
    # echo "source /usr/local/lib/python2.7/site-packages/powerline/bindings/"\
#"tmux/powerline.conf" >> ~/.tmux.conf
    ## enable ctrl+left/right in tmux
    echo "set-window-option -g xterm-keys on" >> ~/.tmux.conf
fi
chown $username:$username ~/.tmux.conf
# tmuxinator
gpg --keyserver hkp://keys.gnupg.net --recv-keys \
    409B6B1796C275462A1703113804BB82D39DC0E3
curl -sSL https://get.rvm.io | bash -s stable
rvm install 2.4
gem sources --add https://gems.ruby-china.org/ --remove https://rubygems.org/
gem install tmuxinator
################################################################################
##                      Zsh
################################################################################
# change the default shell
lineno="$(grep "^${username}" /etc/passwd -n | cut -d ":" -f1)"
sed -i "${lineno}s|bash|zsh|g" /etc/passwd

# install oh_my_zsh
sh -c "$(wget https://raw.githubusercontent.com/howardhhm/ubuntu-init/"\
"master/install_oh_my_zsh.sh -O -)"

## add the following code into ~/.zshrc
grep 'ZSH_THEME="agnoster"' ~/.zshrc
if [ $? -ne 0 ]; then
    ## change oh_my_zsh theme
    sed -i 's|^ZSH_THEME="robbyrussell"|ZSH_THEME="agnoster"|g' ~/.zshrc
    ## add env into ~/.hhmrc
    if [ "$HHM_UBUNTU_INIT_CLIENT" = "1" ]; then
        echo 'export HHM_UBUNTU_INIT_CLIENT="1"' >> ~/.hhmrc
    fi
    if [ "$HHM_UBUNTU_INIT_SERVER" = "1" ]; then
        echo 'export HHM_UBUNTU_INIT_SERVER="1"' >> ~/.hhmrc
    fi
    ## source ~/.hhmrc and /etc/sharerc
    sed -i '2 a source ~/.hhmrc' ~/.zshrc
    sed -i '3 a source /etc/sharerc' ~/.zshrc
    ## enable oh_my_zsh "x" and "wd" command
    sed -i 's|^plugins=(git)|plugins=(git extract wd)|g' ~/.zshrc
    ### [AT THE END OF THE FILE]
    ## enable control-s and control-q
    echo "stty start undef\nstty stop undef\nsetopt noflowcontrol\n" >> ~/.zshrc
    ## For python pressing Ctrl-D to exit and prevent
    ## from closing the terminator
    ## zsh autojump
    echo "set -o ignoreeof\nsource /usr/share/autojump/autojump.zsh" >> ~/.zshrc
    ## ipython auto-completion
    echo "export PYTHONSTARTUP=~/.pythonstartup.py" >> ~/.zshrc
    ## tmux color problem
    echo "export TERM=xterm-256color" >> ~/.zshrc
    ## tmuxinator
    echo "export EDITOR='vim'" >> ~/.zshrc
    echo "source $(dirname $(which tmuxinator))/../gems/tmuxinator-0.9.0/"\
"completion/tmuxinator.zsh" >> ~/.zshrc
fi
## powerline for zsh
grep 'powerline' ~/.zshrc
if [ $? -ne 0 ]; then
    echo "powerline-daemon -q" >> ~/.zshrc
    ## for ubuntu
    echo "source /usr/local/lib/python2.7/dist-packages/powerline/bindings/"\
"zsh/powerline.zsh" >> ~/.zshrc
    ## for CentOS
    # echo "/usr/lib/python2.7/site-packages/powerline/bindings/"\
# "zsh/powerline.zsh" >> ~/.zshrc
    ## for mac
    # echo "#source /usr/local/lib/python2.7/site-packages/powerline/bindings/"\
#"zsh/powerline.zsh" >> ~/.zshrc
fi
chown $username:$username ~/.zshrc
chown $username:$username ~/.hhmrc
chown $username:$username -R ~/.oh-my-zsh
chown $username:$username -R ~/.local

## modify sshd_config
sh -c "$(wget https://raw.githubusercontent.com/howardhhm/"\
"ubuntu-init/master/modify_sshd_config.sh -O -)"

## config ~/.vimrc
sh -c "$(wget https://raw.githubusercontent.com/howardhhm/"\
"ubuntu-init/master/config_vimrc.sh -O -)"
################################################################################
##                      Last update
################################################################################
apt-get update
if [ "$HHM_FAST_INIT" = "" ]; then
    apt-get -y upgrade
    apt-get -y autoremove
fi
