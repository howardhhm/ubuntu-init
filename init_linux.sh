#!/bin/bash
# @Author:       howardhhm
# @Email:        howardhhm@126.com
# @DateTime:     2017-02-21 10:59:06
# @Description:  fundamentally init ubuntu os

################################################################################
##                      Preparation
################################################################################
## remove the previous cache
rm -rvf ~/debian-init-tmp
mkdir ~/debian-init-tmp

### the macros
## HHM_UBUNTU_INIT_CLIENT
## HHM_UBUNTU_INIT_SERVER
## HHM_HOMEBREW
## HHM_VMWARE
## HHM_DEBIAN_INIT_SERVER
## HHM_SKIP_SOURCES_SELECTION
## HHM_INTERNATIONAL
## HHM_FAST_INIT
## HHM_MKSWAP
## HHM_BASE

## macros
GITFILES="https://raw.githubusercontent.com/howardhhm/ubuntu-init/master"
# CLOUDFILES="http://7xvxlx.com1.z0.glb.clouddn.com"
# change dash into bash
rm -rvf /bin/sh
ln -s /bin/bash /bin/sh
## ubuntu client
if [ "$HHM_UBUNTU_INIT_SERVER" = "" -a "$HHM_DEBIAN_INIT_SERVER" = "" ]; then
    HHM_UBUNTU_INIT_CLIENT="1"
else
    ## time zone
    rm -rvf /etc/localtime
    ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
fi

## ubuntu virturl server
if [ "$HHM_VMWARE" = "1" ]; then
    HHM_MKSWAP="1"
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
# ## a tool for source selection
# wget --no-cache "${GITFILES}/netselect_0.3.ds1-26_amd64.deb" -P \
#     ~/debian-init-tmp
# dpkg -i ~/debian-init-tmp/netselect_0.3.ds1-26_amd64.deb

## make swap
# if [ ! -f /opt/image/swap -a "$HHM_MKSWAP" = "1" ]; then
#     mkdir -p /opt/image/
#     dd if=/dev/zero of=/opt/image/swap bs=1024 count=2048000
#     mkswap /opt/image/swap
#     swapon /opt/image/swap
#     sed -i '$ a /opt/image/swap     swap      swap defaults 0 0' /etc/fstab
# fi

## set locale
if [ "$HHM_INTERNATIONAL" = "1" ]; then
    echo 'LANG="zh_CN.UTF-8"' >/etc/default/locale
    locale-gen zh_CN.UTF-8
    HHM_SKIP_SOURCES_SELECTION="1"
fi

## link rc.local.service
ln -fs /lib/systemd/system/rc-local.service \
    /etc/systemd/system/rc-local.service
touch /etc/rc.local
chmod 755 /etc/rc.local
LINE=$(wc -c /etc/rc.local | awk '{print $1}')
if [ $LINE -eq 0 ]; then
    echo '#!/bin/sh -e' >/etc/rc.local
    echo '#' >>/etc/rc.local
fi

################################################################################
##                      Ubuntu Source List Modification
################################################################################
if [ "$HHM_SKIP_SOURCES_SELECTION" = "" ]; then
    ## get old sources
    export OLDSOURCE=$(cat /etc/apt/sources.list | egrep "(deb|# deb)" |
        sed "s/^# //g" | grep "deb " | cut -d " " -f2 | sort | uniq -c |
        sort -rn | sed 's/  */ /g;s/^ //g' | cut -d " " -f2 | head -1)
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
    sed -i "s|deb http://security|#deb http://security|g" ~/sources.list
fi

# ## get fast sources shellscript
# if [ ! -f /usr/local/bin/get_fast_sources ]; then
#     wget --no-cache "${GITFILES}/get_fast_sources.sh" -P ~/debian-init-tmp
#     chmod a+rx ~/debian-init-tmp/get_fast_sources.sh
#     mv ~/debian-init-tmp/get_fast_sources.sh /usr/local/bin/get_fast_sources
# fi
# chown root:root /usr/local/bin/get_fast_sources

if [ "$HHM_UBUNTU_INIT_CLIENT" = "1" ]; then
    # git config --global merge.tool vimdiff
    # git config --global merge.conflictstyle diff3
    ## git meld
    # git config --global merge.tool git_meld
    if [ ! -f /usr/local/bin/git_meld ]; then
        wget --no-cache "${GITFILES}/git_meld" -P ~/debian-init-tmp
        chmod a+rx ~/debian-init-tmp/git_meld
        mv ~/debian-init-tmp/git_meld /usr/local/bin/git_meld
    fi
    chown root:root /usr/local/bin/git_meld
    apt-get remove -y aisleriot brasero cheese deja-dup empathy gnome-mahjongg \
        gnome-mines gnome-orca gnome-sudoku libreoffice-common mycli onboard \
        simple-scan thunderbird totem transmission-common unity-webapps-common
    apt-get remove -y webbrowser-app
    apt-get remove -y rhythmbox
    apt-get remove -y landscape-client-ui-install
fi
## update
apt-get update
if [ "$HHM_FAST_INIT" = "" ]; then
    apt-get -y upgrade
fi
apt-get install -y iftop
apt-get install -y gnumeric
apt-get install -y apt-file
apt-file update

################################################################################
##                      Share Resource
################################################################################
wget --no-cache "${GITFILES}/sharerc" -P ~/debian-init-tmp
mv ~/debian-init-tmp/sharerc ~/.sharerc
source ~/.sharerc

################################################################################
##                      Source code pro
##          https://github.com/adobe-fonts/source-code-pro/downloads
################################################################################

################################################################################
##                      Common Software
################################################################################
# if [ "$HHM_VMWARE" = "1" ]; then
#     apt-get install -y open-vm-tools-desktop
# fi
apt-get install -y ack-grep
apt-get install -y clang
# apt-get install -y llvm
apt-get install -y astyle autoconf autojump autossh axel cloc cmake \
    cmatrix colordiff dos2unix exuberant-ctags feh gawk htop libtool lrzsz \
    most nbtscan net-tools ntpdate openssh-server p7zip pandoc ranger \
    shellcheck smartmontools sshfs subversion tig tmux tree uncrustify \
    unzip vim wget silversearcher-ag axel sloccount jq

apt-get install -y screenfetch
apt-get install -y multitail
apt-get install -y apache2
apt-get install -y pwgen
systemctl disable apache2

if [ "$HHM_DEBIAN_INIT_SERVER" = "" ]; then
    apt-get install -y dfc
fi
if [ "$HHM_UBUNTU_INIT_CLIENT" = "1" ]; then
    apt-get install -y dia filezilla geogebra gparted gpick krita meld mypaint \
        okular speedcrunch terminator thunar variety vlc
    apt-get install -fy
fi

## youtube-dl url-to-video
# apt-get install -y youtube-dl
apt-get install -y build-essential pkg-config
apt-get install -y libavcodec-dev libavformat-dev libdc1394-22-dev \
    libevent-dev libgtk2.0-dev libjpeg-dev libpng-dev \
    libssl-dev libswscale-dev libtbb-dev libtbb2 libtiff-dev libxml2-dev \
    libxslt-dev
apt-get install -y libopencv-dev
apt-get install -y libjasper-dev

ntpdate time.nist.gov
apt-get install -y git
apt-get install -y unrar
apt-get install -y rlwrap
apt-get install -y curl zsh convmv ruby speedtest-cli
apt-get install -y docker-compose
apt-get install -fy

## install docker-compose
curl -L "https://github.com/docker/compose/releases/download/1.23.1/"$(
)"docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
# ## syncthing
# if [ ! -f /usr/bin/syncthing ]; then
#     curl -s https://syncthing.net/release-key.txt | sudo apt-key add -
#     echo "deb https://apt.syncthing.net/ syncthing stable" |
#         tee /etc/apt/sources.list.d/syncthing.list
#     apt-get update
# fi

if [ "$HHM_UBUNTU_INIT_CLIENT" = "1" ]; then
    ## disable guest
    grep -q 'allow-guest' \
        /usr/share/lightdm/lightdm.conf.d/50-unity-greeter.conf
    if [ $? -ne 0 ]; then
        sed -i '$ a allow-guest=false' \
            /usr/share/lightdm/lightdm.conf.d/50-unity-greeter.conf
    fi
    ## numlock
    apt-get -y install numlockx
    grep -q 'numlockx' /usr/share/lightdm/lightdm.conf.d/50-unity-greeter.conf
    if [ $? -ne 0 ]; then
        sed -i '$ a greeter-setup-script=/usr/bin/numlockx on' \
            /usr/share/lightdm/lightdm.conf.d/50-unity-greeter.conf
    fi
    ## terminator config
    wget --no-cache "${GITFILES}/terminator_config" -P ~/debian-init-tmp
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
    sed -i "s/bg\[NORMAL\] = shade (1.02, @bg_color)/bg\[NORMAL\] = "$(
    )"shade (1.12, @bg_color)/g" /usr/share/themes/Ambiance/gtk-2.0/gtkrc
    # grep -F "bg[ACTIVE] = shade (0.97, @bg_color)"
    # /usr/share/themes/Ambiance/gtk-2.0/gtkrc
    sed -i "s/bg\[ACTIVE\] = shade (0.97, @bg_color)/bg\[ACTIVE\] = "$(
    )"shade (0.87, @bg_color)/g" /usr/share/themes/Ambiance/gtk-2.0/gtkrc
    ## apple green
    # grep -F "base_color:#ffffff" /usr/share/themes/Ambiance/gtk-2.0/gtkrc
    sed -i "s/base_color:#ffffff/base_color:#cce8cf/g" \
        /usr/share/themes/Ambiance/gtk-2.0/gtkrc

    ## delete old source lists
    cd /etc/apt/sources.list.d
    rm -rvf $(ls | grep -E "(atom|codeblocks|hzwhuang|"$(
    )"caffeine|shutter)")

    add-apt-repository -y ppa:nilarimogard/webupd8
    ## codeblocks
    ## wx-config --version
    ## 3.0.2
    add-apt-repository -y ppa:damien-moore/codeblocks
    ## atom
    add-apt-repository -y ppa:webupd8team/atom
    ## wiz
    # add-apt-repository -y ppa:wiznote-team
    ## ss
    # add-apt-repository -y ppa:hzwhuang/ss-qt5
    ## flash anti-lock new version
    add-apt-repository -y ppa:caffeine-developers/ppa
    ## vokoscreen (video monitor) a little problem
    # add-apt-repository -y ppa:vokoscreen-dev/vokoscreen
    ## shutter (screenshot)
    add-apt-repository -y ppa:shutter/ppa
    ### To be tested
    ### chrome
    if [ ! -f /etc/apt/sources.list.d/google-chrome.list ]; then
        wget --no-cache "${GITFILES}/google-chrome.list" -P \
            /etc/apt/sources.list.d/
    fi
    wget --no-cache -q -O - https://dl.google.com/linux/linux_signing_key.pub |
        apt-key add -

    ## update the sources
    apt-get update
    ## you can separately execute the following command
    # apt-get install -y caffeine

    ### To be tested
    ### chrome
    apt-get install -y google-chrome-stable

    ## shutdown annoying error messages when login
    sed -i "s/enabled=1/enabled=0/g" /etc/default/apport
fi

################################################################################
##                      Python & Pip
################################################################################
apt-get install -y python-dev python-pip python2.7 python2.7-dev python-numpy \
    python-tk
apt-get install -y python3-pip python3.7 python3.7-dev
apt-get install -y python-pyqt5 python-pyqt5.qtsvg python-pyqt5.qtwebkit
## if the command above does not work
## follow these commands
if [ ! -f /usr/pip -o ! -f /usr/pip3 ]; then
    curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py"
    mv get-pip.py ~/debian-init-tmp/get-pip.py
    rm -f ~/.pip/pip.conf
    python ~/debian-init-tmp/get-pip.py
    python3 ~/debian-init-tmp/get-pip.py
fi
# env-update && source /etc/profile

## pip source
if [ "$HHM_INTERNATIONAL" = "" ]; then
    mkdir ~/.pip/
    echo "[global]" >~/.pip/pip.conf
    echo "trusted-host = mirrors.aliyun.com" >>~/.pip/pip.conf
    echo "index-url = https://mirrors.aliyun.com/pypi/simple" >>~/.pip/pip.conf
fi

chown $username:$username -R ~/.pip
pip2 install --upgrade pip $HHM_PIP_TRUST_HOST
pip3 install --upgrade pip $HHM_PIP_TRUST_HOST
# pip2 install html5lib==0.9999999 $HHM_PIP_TRUST_HOST
# pip3 install html5lib==0.9999999 $HHM_PIP_TRUST_HOST

## soft link pip2
# rm -f /usr/local/bin/pip
# ln -s /usr/local/bin/pip2 /usr/local/bin/pip
# cp $(ls /usr/local/bin/pip2.*) /usr/local/bin/pip2

if [ "$HHM_HOMEBREW" = "" ]; then
    ## packages for machine learning
    # gensim xgboost

    pip3 install --user autopep8 beautifulsoup4 beautysh flake8 \
        matplotlib nltk numpy pandas pylint requests scipy seaborn \
        setuptools sklearn yapf $HHM_PIP_TRUST_HOST
    pip3 install --user gensim jupyter_contrib_nbextensions jieba \
        bloom_filter xlsxwriter $HHM_PIP_TRUST_HOST
    pip2 install setuptools $HHM_PIP_TRUST_HOST
    ## use docker
    # pip2 install supervisor $HHM_PIP_TRUST_HOST
    pip3 install --user ipython $HHM_PIP_TRUST_HOST
    pip3 install --user glances $HHM_PIP_TRUST_HOST
    pip3 install --user jupyter jupyter_contrib_nbextensions \
        $HHM_PIP_TRUST_HOST
    pip3 install --user mycli $HHM_PIP_TRUST_HOST
    ## packages for powerline
    ## caution: svnstatus needs reboot
    pip3 install powerline-status powerline-gitstatus \
        powerline-svnstatus psutil $HHM_PIP_TRUST_HOST

fi
## mycli syntax
sed -i 's|^syntax_style = default|syntax_style = fruity|g' ~/.myclirc
## jupyter
if [ "$HHM_UBUNTU_INIT_SERVER" = "1" ]; then
    # pip3 install jupyter setuptools $HHM_PIP_TRUST_HOST
    pip3 install jupyter setuptools $HHM_PIP_TRUST_HOST
fi
## jupyter
if [ "$HHM_UBUNTU_INIT_CLIENT" = "1" -a "$HHM_HOMEBREW" = "" ]; then
    pip3 install spyder $HHM_PIP_TRUST_HOST
fi

## python commandline auto-completion
if [ ! -f ~/.pythonstartup.py ]; then
    wget --no-cache "${GITFILES}/.pythonstartup.py" -P ~/
fi
chown $username:$username ~/.pythonstartup.py
## tldr : man page
if [ ! -f /usr/local/bin/m ]; then
    wget --no-cache "https://raw.githubusercontent.com/raylee/tldr/"$(
    )"master/tldr" -P ~/debian-init-tmp
    mv ~/debian-init-tmp/tldr /usr/local/bin/m
fi
chmod +x /usr/local/bin/m

################################################################################
##                      Powerline
##       http://powerline.readthedocs.io/en/master/usage/other.html
################################################################################
## powerline for ipython
mkdir -p ~/.ipython/profile_default/
grep -q 'edit by howardhhm' ~/.ipython/profile_default/ipython_config.py
if [ $? -ne 0 ]; then
    wget --no-cache "${GITFILES}/ipython_config.py" -P ~/debian-init-tmp/
    mv ~/debian-init-tmp/ipython_config.py ~/.ipython/profile_default/
fi
chown $username:$username -R ~/.ipython/

# ## Install fonts for powerline
# wget --no-cache ${GITFILES}/fonts.tar.gz -P ~/debian-init-tmp
# tar zxvf ~/debian-init-tmp/fonts.tar.gz -C ~/debian-init-tmp
# cd ~/debian-init-tmp/fonts
# ./install.sh
## ~/.config/powerline
if [ ! -d ~/.config/powerline ]; then
    wget --no-cache "${GITFILES}/powerline_user_config.tar.gz" -P \
        ~/debian-init-tmp
    mkdir ~/.config
    tar zxvf ~/debian-init-tmp/powerline_user_config.tar.gz -C ~/.config
fi
chown $username:$username -R ~/.config
chown $username:$username -R ~/debian-init-tmp

## ~/.oh-my-zsh/custom/themes/powerlevel10k
if [ ! -d ~/.oh-my-zsh/custom/themes/powerlevel10k ]; then
    git clone https://github.com/romkatv/powerlevel10k.git \
        ~/.oh-my-zsh/custom/themes/powerlevel10k
fi

## ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
if [ ! -d ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
        ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
fi

## ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
if [ ! -d ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions \
        ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
fi

# ## ~/.fzf/install
# if [ ! -d ~/.fzf/install ]; then
#     git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf &&
#         ~/.fzf/install
#     chown $username:$username -R ~/.fzf
# fi

# chown $username:$username -R ~/.oh-my-zsh

################################################################################
##                      tmux
################################################################################
## configuration for tmux

RUBY_VERSION=$(gem environment | grep 'USER INSTALLATION DIRECTORY' |
    awk -F':' '{print $2}' | awk -F'/' '{print $NF}')

wget --no-cache "${GITFILES}/.tmux.conf" -P ~/
chown $username:$username ~/.tmux.conf
mkdir ~/.tmuxinator
gem install --user tmuxinator
ln -s "../.gem/ruby/${RUBY_VERSION}/gems/tmuxinator-1.1.1/completion/"$(
)"tmuxinator.zsh" ~/.tmuxinator
chown $username:$username -R ~/.gem
# fi
chown $username:$username -R ~/.tmuxinator
################################################################################
##                      Zsh
################################################################################
# change the default shell
lineno="$(grep "^${username}" /etc/passwd -n | cut -d ":" -f1)"
sed -i "${lineno}s|bash|zsh|g" /etc/passwd

# install oh_my_zsh
sh -c "$(wget ${GITFILES}/install_oh_my_zsh.sh -O -)"

cd $HOME

## add the following code into ~/.zshrc
grep -q 'ZSH_THEME="agnoster"' ~/.zshrc
if [ $? -ne 0 ]; then
    ## change oh_my_zsh theme
    sed -i 's|^ZSH_THEME="robbyrussell"|ZSH_THEME="agnoster"\n'$(
    )'#ZSH_THEME="powerlevel10k/powerlevel10k"|g' ~/.zshrc
    ## add env into ~/.hhmrc
    if [ "$HHM_UBUNTU_INIT_CLIENT" = "1" ]; then
        sed -i '2 a export HHM_UBUNTU_INIT_CLIENT="1"' ~/.zshrc
    fi
    if [ "$HHM_UBUNTU_INIT_SERVER" = "1" ]; then
        sed -i '2 a export HHM_UBUNTU_INIT_SERVER="1"' ~/.zshrc
    fi
    if [ "$HHM_INTERNATIONAL" = "1" ]; then
        sed -i '3 a export HHM_INTERNATIONAL="1"' ~/.zshrc
    fi
    ## source ~/.hhmrc and /etc/sharerc
    sed -i '4 a source $HOME/.sharerc' ~/.zshrc
    # sed -i '5 a source ~/.hhmrc' ~/.zshrc
    ## enable oh_my_zsh "x" and "wd" command
    sed -i 's|^plugins=(git)|'$(
    )'plugins=(git extract wd svn pip pyenv pylint python '$(
    )'zsh-syntax-highlighting docker zsh-autosuggestions dnf)|g' \
        ~/.zshrc
    ### [AT THE END OF THE FILE]
    ## enable control-s and control-q
    echo "stty start undef" >>~/.zshrc
    echo "stty stop undef" >>~/.zshrc
    echo "setopt noflowcontrol" >>~/.zshrc
    ## For python pressing Ctrl-D to exit and prevent
    ## from closing the terminator
    ## zsh autojump
    echo "# set -o ignoreeof" >>~/.zshrc
    ## ipython auto-completion
    echo "export PYTHONSTARTUP=~/.pythonstartup.py" >>~/.zshrc
    ## tmux color problem
    echo "export TERM=xterm-256color" >>~/.zshrc
    ## path problem of powerline
    echo 'export PATH=$HOME/.local/bin:$PATH' >>~/.zshrc
    ## path of tmuxinator
    echo "export PATH=\$HOME/.gem/ruby/${RUBY_VERSION}/bin:\$PATH" >>~/.zshrc
    ## the fuck
    # echo 'eval "$(thefuck --alias)"' >> ~/.zshrc
    ## tmuxinator
    echo "export EDITOR='vim'" >>~/.zshrc
    echo 'source $HOME/.tmuxinator/tmuxinator.zsh' >>~/.zshrc
    if [ "$HHM_HOMEBREW" = "" ]; then
        echo 'source /usr/share/autojump/autojump.zsh' >>~/.zshrc
    fi
    ## path for zsh-syntax-highlighting
    echo 'source $HOME/.config/zsh-syntax-highlighting/'$(
    )'zsh-syntax-highlighting.zsh' >>~/.zshrc
fi
## powerline for zsh
grep -q 'powerline' ~/.zshrc
if [ $? -ne 0 ]; then
    echo "powerline-daemon -q" >>~/.zshrc
    if [ "$HHM_HOMEBREW" = "" ]; then
        echo "source /usr/local/lib/python3.6/dist-packages/powerline/"$(
        )"bindings/zsh/powerline.zsh" >>~/.zshrc
    fi
fi
chown $username:$username ~/.zshrc
chown $username:$username ~/.hhmrc
chown $username:$username -R ~/.oh-my-zsh
chown $username:$username -R ~/.local

## modify sshd_config
sh -c "$(wget ${GITFILES}/modify_sshd_config.sh -O -)"

## config ~/.vimrc
sh -c "$(wget ${GITFILES}/config_vimrc.sh -O -)"
################################################################################
##                      Others
################################################################################
su $username -c "ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa"
su $username -c "touch ~/.ssh/authorized_keys && chmod 700 ~/.ssh "$(
)"&& chmod 600 ~/.ssh/* && cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys"

## install docker
apt-get install -y apt-transport-https ca-certificates \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg |
    sudo apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository -y "deb [arch=amd64] https://download.docker.com/"$(
)"linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get install -y docker-ce

## install go
add-apt-repository -y ppa:longsleep/golang-backports
apt-get update
apt-get install -y golang-go

echo "*********Please install the following software by yourself*********"
if [ "$HHM_UBUNTU_INIT_CLIENT" = "1" ]; then
    export LANG=en_US
    mkdir ~/.config/autostart
    chown $username:$username ~/.config/autostart
    su $username -c "export LANG=en_US;xdg-user-dirs-gtk-update"
    # cp "/usr/share/applications/{sublime_text.desktop,variety.desktop,"`
    # `"shadowsocks-qt5.desktop,albert.desktop}" ~/.config/autostart
    # chown $username:$username ~/.config/autostart
    # typora wiznote
    echo "sudo apt-get install -y albert atom caffeine codeblocks shutter "$(
    )"syncthing"
fi

echo "sudo apt-get install -y oracle-java8-installer oracle-java8-set-default"
echo "*********Please install the above software by yourself*********"

################################################################################
##                      Last update
################################################################################
chown $username:$username -R $HOME/.local/share/autojump

apt-get update
if [ "$HHM_FAST_INIT" = "" ]; then
    apt-get -y upgrade
    apt-get -y autoremove
fi
