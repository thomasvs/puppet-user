set si
set et
set sw=4
set sts=4
set ts=4

" map ts to automatically run syntax check using parseonly
map ts :w<CR>:! puppet parser validate %<CR>

