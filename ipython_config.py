#------------------------------------------------------------------------------
#                           edit by howardhhm
#------------------------------------------------------------------------------
c = get_config()
c.InteractiveShellApp.extensions = [
    'powerline.bindings.ipython.post_0_11'
]

c.InteractiveShellApp.exec_lines = ['import numpy as np']
c.InteractiveShellApp.exec_lines += ['import tensorflow as tf']
c.InteractiveShellApp.exec_lines += ['%load_ext autoreload']
c.InteractiveShellApp.exec_lines += ['%autoreload 2']

#------------------------------------------------------------------------------
#                           edit by howardhhm
#------------------------------------------------------------------------------
