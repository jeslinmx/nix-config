let g:lightline = {
    \ 'colorscheme': 'catppuccin_mocha',
    \ 'active': {
        \ 'left': [
            \ [ 'mode', 'paste', 'cmd' ],
            \ [ 'fugitive' ],
            \ [ 'filename', 'filestatus', 'filetype' ]
        \ ],
        \ 'right': [
            \ [ 'lineinfo' ],
            \ [ 'percent' ],
            \ [ 'fileformat', 'encoding?' ]
        \ ]
    \ },
    \ 'inactive': {
        \ 'left': [
            \ [ 'fugitive' ],
            \ [ 'filename' , 'filestatus' ]
        \ ],
        \ 'right': [
            \ [ 'lineinfo' ],
            \ [ 'percent' ],
            \ [ 'fileformat', 'encoding?' ]
        \ ]
    \ },
    \ 'subseparator': {
        \ 'left': ''
    \ },
    \ 'tabline': {
        \ 'left': [ [ 'tabs' ] ],
        \ 'right': [ [ 'buffers' ] ]
    \ },
    \ 'mode_map': {
        \ 'n': '',
        \ 'i': '󰙏',
        \ 'c': '',
        \ 'R': '󰯍',
        \ 'v': '󰈈',
        \ 'V': '󱀦',
        \ "\<C-v>": '󰡫',
        \ 's': '󰒉',
        \ 'S': '',
        \ "\<C-s>": '󰩭',
        \ 't': '',
    \ },
    \ 'component': {
        \ 'cmd': '%S',
    \ },
    \ 'component_expand': {
        \ 'buffers': 'lightline#bufferline#buffers'
    \ },
    \ 'component_type': {
        \ 'buffers': 'tabsel'
    \ },
    \ 'component_function': {
        \ 'filetype': 'IconFiletype',
        \ 'fileformat': 'IconFileformat',
        \ 'fugitive': 'LightlineFugitive',
        \ 'filestatus': 'LightlineFileStatus',
        \ 'encoding?': 'LightlineNondefaultEncoding',
    \ },
\ }

let g:lightline#bufferline#right_aligned = 1
let g:lightline#bufferline#show_number = 0
let g:lightline#bufferline#modified = '󰏫'
let g:lightline#bufferline#read_only = '󰏯'
let g:lightline#bufferline#more_buffers = '…'
let g:lightline#bufferline#buffer_number_map = {
    \ 0: '⁰', 1: '¹', 2: '²', 3: '³', 4: '⁴',
    \ 5: '⁵', 6: '⁶', 7: '⁷', 8: '⁸', 9: '⁹'
\ }
let g:lightline#bufferline#enable_devicons = 1
let g:lightline#bufferline#enable_nerdfont = 1
let g:lightline#bufferline#icon_position = 'left'
let g:lightline#bufferline#filter_by_tabpage = 1
let g:lightline#bufferline#buffer_filter = "LightlineBufferlineFilter"

function! IconFiletype()
    return WebDevIconsGetFileTypeSymbol() . ( winwidth(0) > 70 ? ' ' . ( strlen(&filetype) ? &filetype : 'unknown' ) : '' )
endfunction

function! IconFileformat()
    return winwidth(0) > 70 ? { 'dos': '⏎', 'unix': '␊', 'mac': '␍' }[&fileformat] : ''
endfunction

function! LightlineNondefaultEncoding()
    let l:encoding = &fenc !=# '' ? &fenc : &enc
    return l:encoding ==# 'utf-8' ? '' : l:encoding
endfunction

function! LightlineFileStatus()
    return (
        \ &ft ==# 'help' ? '󰣯'
        \ : &modified ? '󰏫'
        \ : &readonly ? '󰏯'
        \ : !&modifiable ? '󰌾'
        \ : '' )
endfunction

function! LightlineFugitive()
    try
        if expand('%t') !~? 'Tagbar\|Gundo\|NERD' && &ft !~? 'vimfiler' && exists('*FugitiveHead')
            let branch = FugitiveHead()
            return branch !=# '' ? ' ' . branch : ''
        endif
    catch
    endtry
    return ''
endfunction

function LightlineBufferlineFilter(buffer)
    let ft = getbufvar(a:buffer, "&filetype")
    let bt = getbufvar(a:buffer, "&buftype")
    if ft == 'netrw' || ft == 'help'
        return ft
    else
        return bt != '' ? bt : 'default'
    endif
endfunction
