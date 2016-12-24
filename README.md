# ubuntu-init
A shell script for installing common software and initializing relative settings automatically on Ubuntu

Just execute the command  below
```shell
sudo sh -c "$(wget https://raw.githubusercontent.com/howardhhm/ubuntu-init/master/Linux_init.sh -O -)"
```
or
```shell
sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/howardhhm/ubuntu-init/master/Linux_init.sh)"
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
 - filezilla
 - gcc
 - git
 - htop
 - meld:Comparison
 - net-tools
 - ntpdate
 - okular
 - openssh-server
 - pandoc:Convert docs
 - terminator
 - speedcrunch
 - subversion
 - unzip
 - vim
 - zsh
* Other software
 - java
 - sublime text 3
 - numlock:Numlock on automatically when login
 - speedtest
 - haroopad:Markdown editor
 - wps
 - sogou
 - teamviewer
 - terminator config
 <!-- - exfat:To read exfat filesystem -->
 - codeblocks
 - wiz:A splendid note software
 - ss:For surfing internet
 - caffeine:Anti-lock screen when watching flash video
 <!-- - vokoscreen:Video monitor -->
 - shutter:Screenshot
 - chrome
* python
 - python2, python3, pip and useful libraries
 - python command line auto completion
* powerline for
 - ipython
 - tmux
 <!-- - zsh -->
 - fonts
* Oh my zsh
 - powerline fonts
 - change theme
 - some necessarily additional settings