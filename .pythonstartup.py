#!/usr/bin/python
# -*- coding: UTF-8 -*-

import readline, rlcompleter;
readline.parse_and_bind("tab: complete"); # 启用Tab补全

def igtk():
   globals()['gtk'] = __import__('gtk');
   globals()['thread'] = __import__('thread');
   gtk.gdk.threads_init();
   thread.start_new_thread(gtk.main, ());
   pass;
