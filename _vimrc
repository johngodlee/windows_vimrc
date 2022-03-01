" vimrc for use within gVimPortable on Windows

" Set folding to markers for vimrc only 
" vim: foldmethod=marker

" General Settings {{{

" vi compatibility
set nocompatible		

filetype off  " required 

filetype plugin indent on  " required

" Set mouse mode to always
set mouse=a

" Don't reset cursor to start of line when moving around
set nostartofline

" Preserve indentation on wrapped lines and make proper tabs
set breakindent
set autoindent

set tabstop=4
set shiftwidth=4
set softtabstop=4
set noexpandtab

" Maintain indents on copy and new line
set copyindent
set preserveindent

" Normal backspace behaviour 
set backspace=2

" Split to right by default
set splitright 
set splitbelow

" Disable search highlighting
set nohlsearch

" Stop creating swp and ~ files
set nobackup
set nowritebackup
set noswapfile

" Automatically cd to directory of current file
set autochdir

" Ignore case of `/` searches unless an upper case letter is used
set ignorecase
set smartcase

" Open maximised
au GUIEnter * simalt ~x

" Set color scheme to a comfortable default 
colorscheme gruvbox
let g:gruvbox_italic = 0

" enable syntax highlighting
syntax on

" Remove ugly vertlines in split bar (Note space after `\ `)
set fillchars+=vert:\ 

" Make end of file `~` the same colour as background
highlight EndOfBuffer ctermfg=none ctermbg=none

" enable line numbers, relative except current line
set number relativenumber

" Add cursorline
set cursorline

" Remove background
hi Normal ctermbg=none

" Ragged right line break
set linebreak
set wrap

" Show statusline always
set laststatus=2

" Autocomplete with tab
set completeopt=longest,menuone,noselect
" }}}

" Keybindings {{{ 

" Move by visual lines unless line numbers supplied
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')
nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')

" Resize splits more conveniently using the leader key
nnoremap <Leader>h <C-W>>
nnoremap <Leader>j <C-W>+
nnoremap <Leader>k <C-W>-
nnoremap <Leader>l <C-W><

" Change layout of splits
nnoremap <Leader>] <C-w>H
nnoremap <Leader>[ <C-w>J

" Easier save and quit with `;`
noremap ;w :w<CR>
noremap ;q :q<CR>

" Don't exit visual mode when tab indenting
vnoremap > >gv
vnoremap < <gv

" Send split to new tab
nnoremap <Leader>G :tabedit %<CR>

" Disable Ex Mode
map Q <Nop>

" Copy and paste
set clipboard=unnamed
vnoremap y "+y 
vnoremap p "+p
nnoremap p "+gp
vnoremap d "+d
nnoremap dd "+dd

" Don't add overwritten text to register
xnoremap <expr> p 'pgv"'.v:register.'y`>'
xnoremap <expr> P 'Pgv"'.v:register.'y`>'

" Show whitespace characters
nnoremap <Leader>m :set list!<CR>
set listchars=tab:?\ ,eol:?,nbsp:?,trail:•,extends:?,precedes:?
set showbreak=\ ? 

" Open netrw
nnoremap <Leader>n :Vexplore<CR>

" Toggle spellcheck
nnoremap <Leader>s :set spell!<CR>
" }}}

" Folding {{{

" Make folds with indent
set foldmethod=indent

" Open files with folds open
autocmd BufRead * normal zR

" Show folds in gutter
set foldcolumn=1

" Disable indent folding in certain filetypes
autocmd Filetype tex setlocal nofoldenable
autocmd Filetype bib setlocal nofoldenable
autocmd Filetype markdown setlocal nofoldenable

" Set folding for markdown headers
function! MarkdownLevel()
    if getline(v:lnum) =~ '^# .*$'
        return ">1"
    endif
    if getline(v:lnum) =~ '^## .*$'
        return ">2" 
    endif
    if getline(v:lnum) =~ '^### .*$'
        return ">3"
    endif
    if getline(v:lnum) =~ '^#### .*$'
        return ">4"
    endif
    if getline(v:lnum) =~ '^##### .*$'
        return ">5"
    endif
    if getline(v:lnum) =~ '^###### .*$'
        return ">6"
    endif
    return "=" 
endfunction
au BufEnter *.md setlocal foldexpr=MarkdownLevel()  
au BufEnter *.md setlocal foldmethod=expr   
" }}}

" Statusline {{{
" Modes and their codes for statusline
let g:currentmode={
    \ 'n'  : 'Normal',
    \ 'no' : 'N·Operator Pending',
    \ 'v'  : 'Visual',
    \ 'V'  : 'V·Line',
    \ "\<C-V>" : 'V·Block',
    \ 's'  : 'Select',
    \ 'S'  : 'S·Line',
    \ "\<C-S>" : 'S·Block',
    \ 'i'  : 'Insert',
    \ 'R'  : 'Replace',
    \ 'Rv' : 'V·Replace',
    \ 'c'  : 'Command',
    \ 'cv' : 'Vim Ex',
    \ 'ce' : 'Ex',
    \ 'r'  : 'Prompt',
    \ 'rm' : 'More',
    \ 'r?' : 'Confirm',
    \ '!'  : 'Shell',
    \ 't'  : 'Terminal'
    \}

" Get filesize
function! FileSize()
  let bytes = getfsize(expand('%:p'))
  if (bytes >= 1024)
    let kbytes = bytes / 1024
  endif
  if (exists('kbytes') && kbytes >= 1000)
    let mbytes = kbytes / 1000
  endif
  if bytes <= 0
    return '0'
  endif
  if (exists('mbytes'))
    return mbytes . 'MB'
  elseif (exists('kbytes'))
    return kbytes . 'KB'
  else
    return bytes . 'B'
  endif
endfunction

" left side
set statusline=
set statusline+=%#LineNr#
set statusline+=\ %-8.{toupper(g:currentmode[mode()])} 	" Current mode
set statusline+=\ \|\  	" Vert-line and space   
set statusline+=%t	" File name
set statusline+=\ \|	" Vert-line and space   
set statusline+=%=	" Switch to right side

" right side
set statusline+=%m%r " Modified and read only flags
set statusline+=\ 		"Space
set statusline+=%y	" File type
set statusline+=\ \|\ 	" Space, Vert-line and space
set statusline+=%{FileSize()}
set statusline+=\ \|\ 	" Space, Vert-line and space
set statusline+=%3.p%%	" Percentage through file - min size 3
set statusline+=\ \|\ 	" Vert-line and Space
set statusline+=%8.(%4.l:%-3.c%)	" Line and column number in group
set statusline+=\ 		" Space
" }}}

" netrw {{{

" Remove banner
let g:netrw_banner = 0

" Tree-like directory style
let g:netrw_liststyle = 3

" Open files in 'previous' pane
let g:netrw_browse_split = 0
let g:netrw_preview = 1
let g:netrw_altv = 1

" Column width of Vexplore
let g:netrw_winsize = 20

" Disable opening files with left click
let g:netrw_mousemaps = 0

" Human readable file sizes
let g:netrw_sizestyle = "H"

" Maintain current directory when opening netrw
let g:netrw_keepdir = 0

" Stop creating history in .netrwhist
let g:netrw_dirhistmax = 1
" }}}

" Spell check {{{

" Set language
set spelllang=en_gb

" Set spellfile
set spellfile=$HOME/.vim/spell/en.utf-8.add

" Highlighting of spelling 
hi clear SpellBad
hi SpellBad cterm=underline,bold ctermbg=red ctermfg=black
" }}}
