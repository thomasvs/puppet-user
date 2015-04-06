set si
set et
set sw=2
set sts=2
set ts=2

" map ts to automatically run syntax check using parseonly
map ts :w<CR>:! puppet parser validate %<CR>

