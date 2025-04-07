" Mappings
nnoremap <silent> <leader> :WhichKey '<Space>'<CR>

nnoremap gb :bnext<CR>
nnoremap gB :bNext<CR>
nnoremap <Tab> <Plug>lightline#bufferline#go_next()
nnoremap <S-Tab> <Plug>lightline#bufferline#go_previous()

nnoremap ,, <plug>(lsp-hover)
nnoremap ,d <plug>(lsp-definition)
nnoremap ,D <plug>(lsp-declaration)
nnoremap ,i <plug>(lsp-implementation)
nnoremap ,t <plug>(lsp-type-definition)
nnoremap ,[ <plug>(lsp-previous-diagnostic)
nnoremap ,] <plug>(lsp-next-diagnostic)
nnoremap <expr><c-f> lsp#scroll(+4)
nnoremap <expr><c-d> lsp#scroll(-4)

nnoremap <silent> <expr> j (v:count > 0 ? 'j' : 'gj')
nnoremap <silent> <expr> k (v:count > 0 ? 'k' : 'gk')
vnoremap <silent> <expr> j (v:count > 0 ? 'j' : 'gj')
vnoremap <silent> <expr> k (v:count > 0 ? 'k' : 'gk')

" Remappings
imap jj <Esc>
tmap jj <C-W>N
nmap <C-H> <C-W>h
nmap <C-J> <C-W>j
nmap <C-K> <C-W>k
nmap <C-L> <C-W>l
vmap <silent> < <gv
vmap <silent> > >gv

" Leader mappings

let g:mapleader = " "

let g:nleadermap = {
    \ 'u': [':UndotreeToggle', 'undotree'],
    \ 'z': [':Goyo', 'zen'],
    \ '~': [':Startify', 'startify'],
    \ }

let g:nleadermap.g = {
    \ 'name': '+git',
    \ '<CR>': '<enter raw command>',
    \ 'c': [':Git commit', 'commit'],
    \ }
nnoremap <leader>g<CR> :Git

let g:nleadermap.s = {
    \ 'name': '+set',
    \ 'w': [':set wrap! wrap?', 'wrap'],
    \ }

let g:nleadermap.t = {
    \ 'name': '+term',
    \ 'h': [':execute "let prev_splitright = &splitright" | set nosplitright | execute "vertical terminal" | execute "let &splitright = prev_splitright"', 'term-left'],
    \ 'j': [':execute "let prev_splitbelow = &splitbelow" | set splitbelow   | execute "terminal"          | execute "let &splitbelow = prev_splitbelow"', 'term-below'],
    \ 'k': [':execute "let prev_splitbelow = &splitbelow" | set nosplitbelow | execute "terminal"          | execute "let &splitbelow = prev_splitbelow"', 'term-above'],
    \ 'l': [':execute "let prev_splitright = &splitright" | set splitright   | execute "vertical terminal" | execute "let &splitright = prev_splitright"', 'term-right'],
    \ }

let g:nleadermap.w = {
    \ 'name': '+win',
    \ 'h': [':execute "let prev_splitright = &splitr,ght" | set nosplitright | execute "vsplit" | execute "let &splitright = prev_splitright"', 'split-left'],
    \ 'j': [':execute "let prev_splitbelow = &splitbelow" | set splitbelow   | execute "split"  | execute "let &splitbelow = prev_splitbelow"', 'split-below'],
    \ 'k': [':execute "let prev_splitbelow = &splitbelow" | set nosplitbelow | execute "split"  | execute "let &splitbelow = prev_splitbelow"', 'split-above'],
    \ 'l': [':execute "let prev_splitright = &splitright" | set splitright   | execute "vsplit" | execute "let &splitright = prev_splitright"', 'split-right'],
    \ 'H': [':execute "let prev_splitright = &splitright" | set nosplitright | execute "vnew" | execute "let &splitright = prev_splitright"', 'new-left'],
    \ 'J': [':execute "let prev_splitbelow = &splitbelow" | set splitbelow   | execute "new"  | execute "let &splitbelow = prev_splitbelow"', 'new-below'],
    \ 'K': [':execute "let prev_splitbelow = &splitbelow" | set nosplitbelow | execute "new"  | execute "let &splitbelow = prev_splitbelow"', 'new-above'],
    \ 'L': [':execute "let prev_splitright = &splitright" | set splitright   | execute "vnew" | execute "let &splitright = prev_splitright"', 'new-right'],
    \ 'q': [':quit', 'quit-window'],
    \ }

let g:nleadermap.b = {
    \ 'name': '+buf',
    \ 'n': [':enew', 'new-buffer'],
    \ 'q': [':Bw', 'quit-buffer'],
    \ 'Q': [':Bw!', 'quit-buffer'],
    \ 'a': [':unhide', 'all-loaded'],
    \ 'A': [':ball', 'all'],
    \ '<Tab>': ['<Plug>lightline#bufferline#go_next_category()', 'next-category'],
    \ '<S-Tab>': ['<Plug>lightline#bufferline#go_previous_category()', 'previous-category'],
    \ }

let g:nleadermap.f = {
    \ 'name': '+find',
    \ 'f': [':FuzzyFiles', 'files'],
    \ 'g': [':FuzzyGitFiles', 'git-files'],
    \ 'r': [':FuzzyGrep', 'ripgrep'],
    \ 'l': [':FuzzyInBuffer', 'lines'],
    \ 'b': [':FuzzyBuffers', 'buffers'],
    \ 'v': [':FuzzyCommands', 'vim-commands'],
    \ '?': [':FuzzyHelps', 'help'],
    \ }

let g:nleadermap.l = {
    \ 'name': '+lsp',
    \ 'a': ['<plug>(lsp-code-action)', 'actions'],
    \ 'l': ['<plug>(lsp-code-lens)', 'lens'],
    \ 'f': ['<plug>(lsp-document-format)', 'format'],
    \ 'c': ['<plug>(lsp-rename)', 'rename'],
    \ 'd': ['<plug>(lsp-document-diagnostics)', 'diagnostics'],
    \ 's': ['<plug>(lsp-document-symbol)', 'symbols'],
    \ 't': ['<plug>(lsp-type-hierarchy)', 'type-hierarchy'],
    \ 'S': ['<plug>(lsp-workspace-symbol)', 'workspace-symbols'],
    \ 'r': ['<plug>(lsp-references)', 'references'],
    \ }

call which_key#register('<Space>', "g:nleadermap", 'n')

