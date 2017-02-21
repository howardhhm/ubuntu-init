# ubuntu-init
A shell script for installing common software and initializing relative settings automatically on Ubuntu

Just execute the command below
```shell
sudo sh -c "$(wget https://raw.githubusercontent.com/howardhhm/ubuntu-init/master/init_linux.sh -O -)"
```
<!-- or
```shell
sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/howardhhm/ubuntu-init/master/Linux_init.sh)"
``` -->

## ubuntu-init for server
Execute the command below
```shell
sudo sh -c "export HHM_UBUNTUINIT_SERVER='1';$(wget https://raw.githubusercontent.com/howardhhm/ubuntu-init/master/init_linux.sh -O -)"
```

## Contents
* Update the Ubuntu sources.list:Change the source to the fastest one
* getfastsources shellscript
* apt-file
* /etc/sharerc:Useful alias settings
* Source Code Pro
* Common software
 - ack-grep
 - autojump
 - byobu tmux
 - classicmenu-indicator            [not for server]
 <!-- - chromium -->
 - cmatrix:Just for fun
 - ctags
 - curl wget
 - dia:Linux visio                  [not for server]
 - dfc                              [not for debian]
 - dos2unix
 - exuberant-ctags
 - filezilla                        [not for server]
 - git
 - gparted                          [not for server]
 - htop
 - meld:Comparison                  [not for server]
 - net-tools
 - ntpdate
 - okular:pdf reader                [not for server]
 - openssh-server
 - pandoc:Convert docs              [not for server]
 - terminator                       [not for server]
 - screenfetch
 - speedcrunch                      [not for server]
 - subversion
 - unzip
 - variety:wallpapers               [not for server]
 - vim
 - vlc:video player                 [not for server]
 - zsh
* Other software
 - haroopad:Markdown editor         [not for server]
 - java
 - lantern                          [not for server]
 - numlock:Numlock on automatically when login
 - sogou                            [not for server]
 - speedtest
 - sublime text 3                   [not for server]
 - teamviewer                       [not for server]
 - terminator config                [not for server]
 - wps                              [not for server]
 - caffeine:Anti-lock screen when watching flash video  [not for server]
 - chrome                           [not for server]
 - codeblocks                       [not for server]
 <!-- - exfat:To read exfat filesystem -->
 - shutter:Screenshot               [not for server]
 - ss:For surfing internet          [not for server]
 <!-- - vokoscreen:Video monitor -->
 - wiz:A splendid note software     [not for server]
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