#!/usr/bin/python
# -*- coding: UTF-8 -*-

import readline
import rlcompleter
readline.parse_and_bind("tab: complete")  # tab auto complete


def igtk():
    globals()['gtk'] = __import__('gtk')
    globals()['thread'] = __import__('thread')
    gtk.gdk.threads_init()
    thread.start_new_thread(gtk.main, ())
    pass
