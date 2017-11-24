# ubuntu-init
A shell script for installing useful software and initializing relative settings automatically on Ubuntu

Just execute the command below
```shell
sudo sh -c "$(wget https://raw.githubusercontent.com/howardhhm/"`
`"ubuntu-init/master/init_linux.sh -O -)"
```
<!-- or
```shell
sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/howardhhm/ubuntu-init/master/Linux_init.sh)"
``` -->

## ubuntu-init for servers
some software are worthless for server
```shell
sudo sh -c "export HHM_UBUNTU_INIT_SERVER='1';"`
`"$(wget https://raw.githubusercontent.com/howardhhm/ubuntu-init/"`
`"master/init_linux.sh -O -)"
```

## Contents
* change the time zone
* Update the Ubuntu sources.list:Change the source to the fastest one
<!-- * get_fast_sources shellscript -->
* remove useless software
 - aisleriot brasero cheese deja-dup empathy gnome-mahjongg
 - gnome-mines gnome-orca gnome-sudoku landscape-client-ui-install
 - libreoffice-common onboard rhythmbox simple-scan thunderbird totem
 - transmission-common unity-webapps-common webbrowser-app
* apt-file
* /etc/sharerc:Useful alias settings
* update_pip_all shellscript
* Source Code Pro
* Common software (both on clients and servers)
 - ack-grep autojump
 - cmatrix:Just for fun
 - ctags curl wget dos2unix exuberant-ctags git htop java net-tools
 - numlock:Numlock on automatically when login
 - ntpdate openssh-server screenfetch speedtest subversion unzip vim zsh
* Only on clients
 - caffeine:Anti-lock screen when watching flash video
 - chrome
 - codeblocks
 - dfc
 - dia:Linux visio
 - filezilla
 - gparted
 - haroopad:Markdown editor
 - lantern
 - meld:Comparison
 - okular:pdf reader
 - pandoc:Convert docs
 - shutter:Screenshot
 - sogou
 - speedcrunch
 - ss:For surfing internet
 - sublime text 3
 - teamviewer
 - terminator
 - terminator config
 - variety:wallpapers
 - vlc:video player
 - wiz:A splendid note software
 - wps
 <!-- - exfat:To read exfat filesystem -->
 <!-- - vokoscreen:Video monitor -->
* python
 - python2, python3, pip and useful libraries
 - python command line auto completion
* powerline for
 - ipython
 - tmux
 - fonts
 - ~/.config/powerline
* Oh my zsh
 - powerline fonts
 - change theme
 - some necessarily additional settings
 - powerline
* modify sshd_config
* config ~/.vimrc
