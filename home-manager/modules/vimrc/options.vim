set encoding=UTF-8
set nomodeline
set number
" enable mouse support
set mouse=a
" use 24-bit color
set termguicolors
" disable the --MODE-- message in lastline
set noshowmode
" show partial command in lastline
set showcmd showcmdloc=last
" make whitespace visible
set list
set listchars=trail:◦,multispace:◦,leadmultispace:\ ,nbsp:⍽,tab:-->,precedes:«,extends:»
" disable line wrapping, turn on graduated scrolling
set nowrap sidescroll=5
" wrap at word boundaries
set linebreak
" indicate word wraps in the gutter
set showbreak=\ ++\ … cpoptions+=n
" yank to clipboard
set clipboard=unnamedplus
" case-insensitive searching except when uppercase characters present
set ignorecase smartcase
" hide buffers when they are unloaded, instead of closing them
set hidden
" new splits are created at right and bottom, instead of left and top
set splitbelow splitright
" show tabline all the time, even when there's only one tabpage
set showtabline=2
"
" persist undo history
if has("persistent_undo")
   let target_path = expand('~/.local/state/vim/undo')

    " create the directory and any parent directories
    " if the location does not exist.
    if !isdirectory(target_path)
        call mkdir(target_path, "p", 0700)
    endif

    let &undodir=target_path
    set undofile
endif

let g:highlightedyank_highlight_duration = 200
let g:highlightedyank_highlight_in_visual = 0

let g:scroll_factor = 1

let g:smalls_jump_trigger = '<CR>'
let g:smalls_auto_jump = 1
let g:smalls_auto_jump_min_input_length = 2
let g:smalls_auto_set_min_input_length = 2

let g:undotree_WindowLayout = 3
let g:undotree_DiffAutoOpen = 0
let g:undotree_SetFocusWhenToggle = 1
let g:undotree_ShortIndicators = 1

let g:ctrlp_regexp = 1
let g:ctrlp_match_window = 'top,order:ttb'
let g:ctrlp_lazy_update = 200

let g:limelight_priority = -1
let g:goyo_width = 80
let g:goyo_height = "65%"
let g:goyo_linenr = 1

let g:tmpl_search_paths = [ '~/.vim/templates' ]

let g:enable_fuzzyy_keymaps = 0

let g:easyjump_two_chars = 1

let g:ale_floating_preview = 1
let g:ale_floating_window_border = ['│', '─', '╭', '╮', '╯', '╰', '│', '─']

" auto resize windows when terminal is resized
augroup resizewindows
    autocmd!
    autocmd VimResized * tabdo wincmd =
augroup END

" auto toggle between absolute and relative line numbers:
augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
    autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
augroup END

" highlight current line in insert mode
augroup cursorline-insert
    autocmd!
    autocmd InsertEnter * set cursorline
    autocmd InsertLeave * set nocursorline

" live update what is being search
augroup incsearch-highlight
    autocmd!
    autocmd CmdlineEnter /,\? :set hlsearch
    autocmd CmdlineLeave /,\? :set nohlsearch
augroup END

autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!

