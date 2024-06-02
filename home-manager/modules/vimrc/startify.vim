function! s:formatVersion(version)
    let l:verstr = string(a:version)
    let l:vercomponents = ( strlen(l:verstr) >= 7 )
        \ ? [l:verstr[:-7],l:verstr[-6:-5],l:verstr[-4:]]
        \ : [l:verstr[:-3],l:verstr[-2:]]
    return l:vercomponents
        \ ->map({idx, val -> trim(val[:-2], '0', 1) . val[-1:]})
        \ ->join('.')
endfunction

let g:startify_custom_header = startify#center([
    \ "           d8,              ",
    \ "          `8P               ",
    \ "                            ",
    \ "?88   d8P  88b  88bd8b,d88b ",
    \ "d88  d8P'  88P  88P'`?8P'?8b",
    \ "?8b ,88'  d88  d88  d88  88P",
    \ "`?888P'  d88' d88' d88'  88b",
    \ ])
    \ + ['']
    \ + startify#center(['version ' . s:formatVersion(v:version)])
let g:startify_custom_footer = startify#center(startify#fortune#cowsay())
let g:startify_change_to_dir = 1
let g:startify_change_to_vcs_root = 1
let g:startify_use_env = 1
let g:startify_custom_indices = map(range(1,100), 'string(v:val)')
let g:startify_lists = [
    \ { 'type': 'dir',       'header': ['   MRU ' . getcwd() . ' ' . system('git log -1 --format="(%h %s)" -z 2> /dev/null')->trim()] },
    \ { 'type': 'sessions',  'header': ['   Sessions']       },
    \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
    \ { 'type': 'commands',  'header': ['   Commands']       },
    \ ]

