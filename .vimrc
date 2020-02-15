" Turn on line numbers
set number

" Turn on syntax highlighting
syntax on
try
    colorscheme candyfang
catch
    try
        colorscheme torte
    catch
    endtry
endtry
" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Linebreak on 500 characters
set lbr
set tw=500

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines

set listchars=tab:‣\ ,trail:·,nbsp:␣,precedes:«,extends:»,eol:¬

"
" Automatically toggle paste mode
"
try
    let &t_SI .= "\<Esc>[?2004h"
    let &t_EI .= "\<Esc>[?2004l"

    inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

    function! XTermPasteBegin()
        set pastetoggle=<Esc>[201~
        set paste
        return ""
    endfunction
catch
endtry

"
" W to sudo save file when not root
" 
try
    command W :execute ':silent w !sudo tee % > /dev/null' | :edit!
catch
endtry
