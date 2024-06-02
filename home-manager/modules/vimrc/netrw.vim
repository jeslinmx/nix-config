set wildignore=*.swp

let g:netrw_banner = 0
let g:netrw_preview = 1
let g:netrw_alto = &sb
let g:netrw_altv = &spr
let g:netrw_localcopydircmd = 'cp -r'

augroup netrw_init
  autocmd!
  autocmd filetype netrw call NetrwInit()
augroup END

function! NetrwInit()
    " show dotfiles with .
    nmap <buffer> . gh
    " switch buffers and tabs with tab
    nnoremap <buffer> <Tab> :bnext<CR>
    nnoremap <buffer> <S-Tab> :bNext<CR>
    nnoremap <buffer> <C-Tab> gt
    nnoremap <buffer> <C-S-Tab> gT
    " preview and un-preview with p
    nmap <buffer> P <C-W>z
    " navigate history with h/l
    nmap <buffer> h u
    nmap <buffer> l U
    " vi-like rename/change, mark/yank, open/new
    nmap <buffer> C R
    nmap <buffer> y mf
    nmap <buffer> Y mF
    nmap <buffer> o %
    " sneak
    nmap <buffer> s <Plug>(smalls)
    " fix for lightline
    call lightline#enable()
endfunction
