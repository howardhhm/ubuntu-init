# ubuntu-init
A shell script for installing common software and initializing relative settings automatically on Ubuntu

Just execute the command below
```shell
sudo sh -c "$(wget https://raw.githubusercontent.com/howardhhm/ubuntu-init/master/Linux_init.sh -O -)"
```
<!-- or
```shell
sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/howardhhm/ubuntu-init/master/Linux_init.sh)"
``` -->

## ubuntu-init for server
Execute the command below
```shell
sudo sh -c "export HHM_UBUNTUINIT_SERVER='1';$(wget https://raw.githubusercontent.com/howardhhm/ubuntu-init/master/Linux_init.sh -O -)"
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
 <!-- - chromium -->
 - cmatrix:Just for fun
 - ctags
 - curl wget
 - dfc
 - dos2unix
 - filezilla                        only for client
 - gcc
 - git
 - htop
 - meld:Comparison                  only for client
 - net-tools
 - ntpdate
 - okular                           only for client
 - openssh-server
 - pandoc:Convert docs              only for client
 - terminator                       only for client
 - speedcrunch                      only for client
 - subversion
 - unzip
 - vim
 - zsh
* Other software
 - haroopad:Markdown editor         only for client
 - java
 - lantern                          only for client
 - numlock:Numlock on automatically when login
 - sogou                            only for client
 - speedtest
 - sublime text 3                   only for client
 - teamviewer                       only for client
 - terminator config                only for client
 - wps                              only for client
 - caffeine:Anti-lock screen when watching flash video  only for client
 - chrome                           only for client
 - codeblocks                       only for client
 <!-- - exfat:To read exfat filesystem -->
 - shutter:Screenshot               only for client
 - ss:For surfing internet          only for client
 <!-- - vokoscreen:Video monitor -->
 - wiz:A splendid note software     only for client
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