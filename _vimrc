" _vimrc for use within GVim on Windows
" Used for fieldwork and borrowed computers

" Set folding to markers for .vimrc only 
" vim: foldmethod=marker

" vi compatibility
set nocompatible		

filetype off  " required 

filetype plugin indent on  " required

" Keybindings {{{ 

" map `A` (append at end of line) to `a` (append in place)
nnoremap a A

" Move by visual lines rather than actual lines with `k` `j`, but preserve
" moving by actual lines with bigger jumps like `6j`
nnoremap <expr> j v:count ? (v:count > 1 ? "m'" . v:count : '') . 'j' : 'gj'
nnoremap <expr> k v:count ? (v:count > 1 ? "m'" . v:count : '') . 'k' : 'gk'

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

" Open new split/vsplit/tab with netrw open
nnoremap <Leader>v :vnew<CR>:E<CR>
nnoremap <Leader>s :new<CR>:E<CR>
nnoremap <Leader>t :tabnew<CR>:E<CR>
nnoremap <Leader>n :E<CR>

" Send split to new tab
nnoremap <Leader>g :tabedit %<CR>

" Copy and paste
set clipboard=unnamed
vnoremap y "+y 
vnoremap p "+p
nnoremap p "+gp
vnoremap d "+d
nnoremap dd "+dd

" Open netrw
nnoremap <Leader>n :Vexplore<CR>

" Open new split/vsplit/tab with netrw open
nnoremap <Leader>t :tabnew<CR>:Explore<CR>

" Toggle spellcheck
nnoremap <Leader>s :set spell!<CR>

" }}}

" General Settings {{{

" Movement and resizing {{{

" Set mouse mode 
set mouse=n

" Don't reset cursor to start of line when moving around
set nostartofline

" Preserve indentation on wrapped lines and make proper tabs!
set breakindent
set autoindent

set tabstop=4
set noexpandtab
set shiftwidth=4

set copyindent
set preserveindent
set softtabstop=0

set textwidth=0

" Normal backspace behaviour 
set backspace=2

" Split to right by default
set splitright 

" }}}

" Appearance {{{

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

" Inherit iterm2 colour scheme
set t_Co=16

" Ragged right line break
set linebreak
set wrap

" Statusline {{{

" statusline always showing
set laststatus=2

" Map of modes and their codes for statusline
let g:currentmode={
    \ 'n'  : 'Normal',
    \ 'no' : 'N·Operator Pending',
    \ 'v'  : 'Visual',
    \ 'V'  : 'V�Line',
    \ '^V' : 'V�Block',
    \ 's'  : 'Select',
    \ 'S'  : 'S�Line',
    \ '^S' : 'S�Block',
    \ 'i'  : 'Insert',
    \ 'R'  : 'R',
    \ 'Rv' : 'V�Replace',
    \ 'c'  : 'Command',
    \ 'cv' : 'Vim Ex',
    \ 'ce' : 'Ex',
    \ 'r'  : 'Prompt',
    \ 'rm' : 'More',
    \ 'r?' : 'Confirm',
    \ '!'  : 'Shell',
    \ 't'  : 'Terminal'
    \}

" Change statusline colour based on mode 
function! ModeCurrent() abort
    let l:modecurrent = mode()
    let l:modelist = toupper(get(g:currentmode, l:modecurrent, 'V·Block'))
    let l:current_status_mode = l:modelist
    return l:current_status_mode
endfunction

function! ChangeStatuslineColor()
  if (mode() ==# 'i')
    exe 'hi StatusLine ctermbg=black ctermfg=032'
  elseif (mode() =~# '\v(v|V)' ||  ModeCurrent() == 'V·Block')
    exe 'hi StatusLine ctermbg=black ctermfg=172'
  else    
    exe 'hi Statusline ctermbg=white ctermfg=black'
  endif
  return ''
endfunction

" Statusline
" left side
set statusline=%{ChangeStatuslineColor()}	" Change colour
set statusline+=\ %-8.{ModeCurrent()} 	" Current mode
set statusline+=\ \|\  	" Vert-line and space   
set statusline+=%t	" File name
set statusline+=\ \|\  	" Vert-line and space   
set statusline+=%=	" Switch to right side

" right side
set statusline+=%m%r " Modified and read only flags
set statusline+=\ 		"Space
set statusline+=%y	" File type
set statusline+=\ \|\ 	" Space, Vert-line and space
set statusline+=%3.p%%	" Percentage through file - min size 3
set statusline+=\ \|\ 	" Vert-line and Space
set statusline+=%8.(%4.l:%-3.c%)	" Line and column number in group
set statusline+=\ 		" Space
" }}}
   
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

" netrw {{{

" Remove banner
let g:netrw_banner = 0

" Tree-like directory style
let g:netrw_liststyle = 3

" Open files in 'previous' pane
let g:netrw_browse_split = 4
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

" }}}

" Omni-completion {{{

" Ensure omni-completion menu stays open
set completeopt=longest,menuone 

" Autocompletion as Ctrl-Space
inoremap <C-Space> <C-x><C-o>
inoremap <C-@> <C-Space>
inoremap <Nul> <C-x><C-o>
" }}}

" vimdiff {{{

" Disable folding
set diffopt+=context:99999

" Disable diffing on whitespace
set diffopt+=iwhite

" Softwrap lines
au VimEnter * if &diff | execute 'windo set wrap' | endif

" Disable syntax highlighting
if &diff
    syntax off
endif

" Change highlight colours so they are less garish
hi DiffAdd      cterm=none ctermfg=NONE ctermbg=Red
hi DiffChange   cterm=none ctermfg=NONE ctermbg=Gray
hi DiffDelete   cterm=none ctermfg=NONE ctermbg=Red
hi DiffText     cterm=none ctermfg=NONE ctermbg=DarkGray

" }}}

" Stop creating swp and ~ files
set nobackup
set nowritebackup
set noswapfile

" Open vim in root 
cd ~

" Ignore case of `/` searches unless an upper case letter is used
set ignorecase
set smartcase

" }}}

