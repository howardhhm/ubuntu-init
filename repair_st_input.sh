#!/bin/bash
# @Author:       howardhhm
# @Email:        howardhhm@126.com
# @DateTime:     2017-02-05 18:16:23
# @Description:  Description

wget --no-cache "https://raw.githubusercontent.com/howardhhm/"\
"ubuntu-init/master/libsublime-imfix.so" -P ~/debian-init-tmp
cp ~/debian-init-tmp/libsublime-imfix.so /opt/sublime_text
sed -i 's|exec /opt/sublime_text/sublime_text "$@"|LD_PRELOAD='\
'/opt/sublime_text/libsublime-imfix.so exec /opt/sublime_text/'\
'sublime_text "$@"|g' /usr/bin/subl
sed -i 's|Exec=/opt/sublime_text/sublime_text %F|Exec=bash -c '\
'"LD_PRELOAD=/opt/sublime_text/libsublime-imfix.so exec '\'
'/opt/sublime_text/sublime_text %F"|g' \
    /usr/share/applications/sublime_text.desktop
sed -i 's|Exec=/opt/sublime_text/sublime_text -n|Exec=bash -c '\
'"LD_PRELOAD=/opt/sublime_text/libsublime-imfix.so exec '\
'/opt/sublime_text/sublime_text -n"|g' \
    /usr/share/applications/sublime_text.desktop
sed -i 's|Exec=/opt/sublime_text/sublime_text --command '\
'new_file|Exec=bash -c "LD_PRELOAD=/opt/sublime_text/'
'libsublime-imfix.so exec /opt/sublime_text/sublime_text '\
'--command new_file"|g' /usr/share/applications/sublime_text.desktop
sed -i 's|Exec=/opt/sublime_text/sublime_text %F|Exec=bash -c '\
'"LD_PRELOAD=/opt/sublime_text/libsublime-imfix.so exec '\'
'/opt/sublime_text/sublime_text %F"|g' \
    ~/.config/autostart/sublime_text.desktop
sed -i 's|Exec=/opt/sublime_text/sublime_text -n|Exec=bash -c '\
'"LD_PRELOAD=/opt/sublime_text/libsublime-imfix.so exec '\
'/opt/sublime_text/sublime_text -n"|g' \
    ~/.config/autostart/sublime_text.desktop
sed -i 's|Exec=/opt/sublime_text/sublime_text --command '\
'new_file|Exec=bash -c "LD_PRELOAD=/opt/sublime_text/'
'libsublime-imfix.so exec /opt/sublime_text/sublime_text '\
'--command new_file"|g' ~/.config/autostart/sublime_text.desktop