fun! s:DetectNode()
    if getline(1) == '#!/usr/bin/env zsh'
        set ft=sh
    endif
endfun

autocmd BufNewFile,BufRead * call s:DetectNode()
