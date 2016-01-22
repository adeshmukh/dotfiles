" number: Display line numbers
set number

" ignorecase: case insensitive search
set ignorecase

" Do not emulate bugs/limitations of original vi
set nocompatible

" autoindent: Use the current line's indent level to set the indent level of new lines.
" smartindent: intelligently guess the indent level of any new line based on the previous line, 
"  assuming the source file is in a C-like language.
set autoindent
set smartindent

" tabstop: Sets up 4-space tabs,
" shiftwidth: Use 4 spaces when text is indented.
set tabstop=4
set shiftwidth=4
set expandtab

" showmatch: Briefly jump to a brace/parenthese/bracket's
"  'match' whenever you type a closing or opening brace/parenthese/bracket.
set showmatch

" This setting prevents vi from making its annoying beeps when a command doesn't work.
"  Instead, it briefly flashes the screen -- much less annoying.
set vb t_vb=

" ruler: Ensures that each window contains a statusline that displays the current cursor position.
set ruler

" nohls: Turns off search highlighting. You can always turn it back on with :set hls.
set nohls


" incsearch: Incremental search. Press Enter to stay at the currently matched
" position.
set incsearch

"  virtualedit=all: Allows the cursor to freely roam anywhere it likes in command mode.
set virtualedit=all

" Type :help options within vim to get a complete list of options.


" colorscheme wombat
" colorscheme blue
" colorscheme darkblue
" colorscheme default
" colorscheme delek
colorscheme desert
" colorscheme elflord
" colorscheme evening
" colorscheme koehler
" colorscheme morning
" colorscheme murphy
" colorscheme pablo
" colorscheme peachpuff
" colorscheme ron
" colorscheme shine
" colorscheme slate
" colorscheme torte
" colorscheme zellner




" Syntax highlighter for javascript
au BufRead,BufNewFile *.js set filetype=javascript
au! Syntax javascript source $HOME/.vim/syntax/javascript.vim
syntax on
