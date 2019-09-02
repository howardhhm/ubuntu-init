" =========== added by hhm ===========
" in case of the display problem in tmux
set term=screen
set hlsearch " hightlight search
set backspace=2 " enable backspace
"set autoindent " auto indent
set ruler " locate the coord
set showmode " status line
set nu " display line number
set bg=dark
set mouse=a
syntax on
set ts=4 "TAB 4 spaces
set expandtab "convert TABs to spaces
set relativenumber
" jump to the location where edited at last time
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif
" ===================================
"        << Ctrl + Shift + k ： move up the line >>
"        << Ctrl + Shift + j ： move down the line >>
" ===================================
nnoremap <C-S-j> :m .+1<CR>==
nnoremap <C-S-k> :m .-2<CR>==
inoremap <C-S-j> <Esc>:m .+1<CR>==gi
inoremap <C-S-k> <Esc>:m .-2<CR>==gi
vnoremap <C-S-j> :m '>+1<CR>gv=gv
vnoremap <C-S-k> :m '<-2<CR>gv=gv
" =========== added by hhm ===========
