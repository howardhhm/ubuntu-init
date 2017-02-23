"这个档案的双引号 (") 是批注
set hlsearch "高亮度反白
set backspace=2 "可随时用退格键删除
"set autoindent "自动缩排
set ruler "可显示最后一行的状态
set showmode "左下角那一行的状态
set nu "可以在每一行的最前面显示行号啦！
set bg=dark "显示不同的底色色调
syntax on "进行语法检验，颜色显示。
set ts=4 "TAB 4个空格
set expandtab "把TAB转换成空格！！ :
set relativenumber
" 打开文件自动跳转到上次修改位置
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif"'")"'")"'")