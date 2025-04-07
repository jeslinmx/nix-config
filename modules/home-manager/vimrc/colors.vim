autocmd! ColorScheme * call s:apply_highlight_groups()

function! s:apply_highlight_groups()
    hi link SpecialKey NonText
    hi HighlightedyankRegion cterm=reverse gui=reverse
    hi GitGutterAdd NONE ctermfg=2
    hi GitGutterChange NONE ctermfg=4
    hi GitGutterDelete NONE ctermfg=3
    hi EndOfBuffer ctermfg=0 guifg=bg
endfunction
