set tabstop=4
set shiftwidth=4
set softtabstop=4
set tw=78
set columns=132
set lines=200
set expandtab
set noerrorbells
set bs=2
set autoindent
set nowrap
set nobackup
set autowrite
set hidden
set lazyredraw
set nrformats=hex
set hlsearch
set shiftround
set nojoinspaces
set mousehide
set listchars=tab:>-,trail:.,extends:>
set shm=atI
set incsearch
set showmatch
set complete=.,b,u,i
set ruler
set gdefault
let g:clj_highlight_builtins=1
set viminfo='50,\"1000,:0,n$HOME/_viminfo
set updatetime=1000
set previewheight=10
set titlestring=%t\ %(%r\ %m%)\ %F
set makeef=c:/tmp/vim##.err
set backupdir=c:/tmp
set directory=c:/tmp

"set tags+=c:/devkitPro/libnds/include/tags
"set tags+=c:/code/twinisles/src/tags
"set tags+=c:\\Program\\\ Files\\\Microsoft\\\ Visual\\\ Studio\\\ .NET\\Vc7\\PlatformSDK\\Include\\tags
"set path+=c:\\code\\twinisles\\src\\**
set tags+=c:/work/packages/easharptest/dev/src/tags
set tags+=c:/work/packages/easharp/dev/runtime/tags
set tags+=c:/work/packages/euclideancombat/dev/src/tags
set tags+=c:/code/packages/tags
set tags+=c:/program\\\ files\\\ (x86)/microsoft\\\ visual\\\ studio\\\ 8/vc/tags
set tags+=D:/nhl/nhl10/easharp-dev/packages/internal/nhl/dev/source
set path+=c:/work/packages/easharptest/dev/**
set path+=c:/work/packages/easharp/dev/**

map L $
map H ^
map <silent> <Right> :bnext<CR>
imap <silent> <Right> <ESC>:bnext<CR>
map <silent> <Left> :bprev<CR>
imap <silent> <Left> <ESC>:bprev<CR>
map <Home> [[k0zt
imap <Home> <ESC>[[k0zt
map <End> j]]k0zt
imap <End> <ESC>j]]k0zt
imap <F1> <ESC>
cmap <F1> <ESC>
map <F1> <ESC>
map <Del> :bd<CR>
map <Ins> :A<CR>

" project.vim
let g:proj_flags="mstvcg"

map ,sws :set list!<cr>

map <F9> [(
map <F10> ])
nnoremap <silent> <F11> :YRShow<CR>
map <F8> :cn<CR>zz
map <S-F8> :cp<CR>zz
map ,ev :e! $HOME/_vimrc<CR>
map ,sv :so $HOME/_vimrc<CR>
map g, [[/^[ \t]*$<CR>O
map ,q /\*\/<CR>o<ESC>?\/\*<CR>O<ESC>jgqapdd??<CR>kdd
map ,i0 dO#if 0<CR>#endif<ESC>kp
map ,u0 %dddd
map ,ld :silent! !latex %<CR>:silent! !cmd /c start %:r.dvi<CR>
map ,lp :silent! !pdflatex %:r<CR>:silent! !cmd /c start %:r.pdf<CR>
map ,, O//--------------------------------------------<esc>H:s/\s*//<cr>
"imap ` <ESC>
" i'd really prefer perforce.vim but i can never get it working right
map <F1> :!p4 edit %<CR>
noremap <silent> <ESC><ESC> :ccl<cr>
noremap <M-l> guiww
noremap <M-u> gUiww
noremap! <M-l> <Esc>guiw`]a
noremap! <M-u> <Esc>gUiw`]a
noremap <silent> <M-f> :FuzzyFinderFile<cr>
noremap <silent> <M-t> :FuzzyFinderTag<cr>
noremap <silent> <M-g> :FuzzyFinderTaggedFile<cr>
noremap <silent> <M-b> :FuzzyFinderBuffer<cr>
noremap <silent> <M-d> :FuzzyFinderDir<cr>
inoremap <silent> <M-f> <Esc>:FuzzyFinderFile<cr>
inoremap <silent> <M-t> <Esc>:FuzzyFinderTag<cr>
inoremap <silent> <M-g> <Esc>:FuzzyFinderTaggedFile<cr>
inoremap <silent> <M-b> <Esc>:FuzzyFinderBuffer<cr>
inoremap <silent> <M-d> <Esc>:FuzzyFinderDir<cr>
map <silent> <C-F5> :if expand("%:p:h") != ""<CR>:!start explorer.exe %:p:h,/e<CR>:endif<CR><CR> 

" current top-level form to clipboard
map <silent> <F7> ma99[("+y%`a:let @+ .= "\n"<CR>

" for the wrap nazis
map <silent> ,80 :call EightyToggle()<cr>
function! EightyToggle()
    if exists("w:m1")
        call matchdelete(w:m1)
        call matchdelete(w:m2)
        unlet w:m1
        unlet w:m2
    else
        if &textwidth > 4
            let w:m1=matchadd('MatchParen', printf('\%%<%dv.\%%>%dv', &textwidth+1, &textwidth-4), -1)
            let w:m2=matchadd('ErrorMsg', printf('\%%>%dv.\+', &textwidth), -1)
        endif
    endif
endfunction
function! EightyOff()
endfunction



set gcr=a:blockCursor-blinkwait600-blinkoff700-blinkon600
set go=a

highlight Normal guibg=black
highlight Normal guifg=grey60
filetype plugin on
filetype indent on

autocmd BufRead,BufEnter *.metel set tw=0
autocmd BufRead,BufEnter _vimrc set nocindent tw=0
autocmd BufRead,BufNewFile *.vsm,*.dsm call PS2ASMEdit()
autocmd BufLeave *.vsm,*.dsm set virtualedit=
autocmd BufNewFile,BufRead *.as setf actionscript 
"autocmd CursorHold *.[ch],*.cc,*.cpp nested exe "silent! ptag " . expand("<cword>")
autocmd BufReadPost quickfix :nm <CR> <Tab>zz
"autocmd BufReadPost quickfix :g/Binary\ file.*matches/:.d
"autocmd BufReadPost quickfix :g/\\fifa\\ps2\\src\/tags/:d
"autocmd BufReadPost quickfix :g/\\fifa\\cmn\\src\/tags/:d
autocmd GUIEnter * winpos 525 0
autocmd BufRead,BufEnter *.goo set lisp tabstop=2 shiftwidth=2
autocmd BufRead,BufEnter *.sculpt set lisp tabstop=2 shiftwidth=2 expandtab
autocmd BufRead,BufEnter *.scm set expandtab lisp tabstop=8 shiftwidth=8 lispwords+=module lispwords+=with-output-to-file lispwords+=define-macro
autocmd BufRead,BufEnter *.scm set makeprg=c:\\progra~1\\plt\mzscheme\ --version\ --mute-banner\ --case-sens\ --load\ %:p
autocmd BufRead,BufEnter *.scm set errorformat=%f:%l:%c:%m
autocmd BufRead,BufEnter *.scm map <F7> :silent! :make<CR>:20cope<cr>
autocmd BufRead,BufEnter *.scm map <F8> :let $oldmp=&makeprg<cr>:set makeprg=c:\\progra~1\\plt\\mzscheme\ --version\ --mute-banner\ --case-sens\ --load\ tests.scm<cr>:make<CR>:20cope<cr>:let &makeprg=$oldmp
autocmd BufRead,BufNewFile,BufEnter *.ml,*.mli,*.mll set ft=ocaml
autocmd BufRead,BufNewFile,BufEnter *.build set ft=xml
autocmd BufRead,BufNewFile,BufEnter sconstruct set ft=python
autocmd BufRead,BufEnter *.nfo set guifont=Terminal
autocmd BufRead,BufEnter,BufNewFile *.sc set ic syntax=scheme tabstop=8 shiftwidth=8 autoindent comments=:; define=^\\s*(def\\k* formatoptions-=t iskeyword+=+,-,*,/,%,<,=,>,:,$,?,!,@-@,94 lisp
autocmd BufRead blog.xml exe "normal jo\<CR>\<ESC>,id\<ESC>kkko"
autocmd BufRead,BufNewFile,BufEnter *.cs,*.cpp,*.h,*.tup,*.inl,*.cc,*.c,*.hh set expandtab ts=4 sw=4 cindent formatoptions=croq

" :wq and :q
cab Lwq wq
cab Lq q
cab Wq wq
cab Q q
cab o find

ab shoudl should
ab fro for
ab teh the
ab fo of
ab importatn important
ab typdef typedef
ab highets highest

set gcr=a:block
set guioptions=a
set guifont=Lucida\ Console:h9:w5
"depending on dpi and time of day (!)
"set guifont=Consolas:h8
"set guifont=Consolas:h10

syntax on


augroup filetype
    au! BufRead,BufNewFile *.ll     set filetype=llvm
    au! BufRead,BufNewFile *.llx    set filetype=llvm
augroup END

gui
set lines=100

colo darkblue

if filereadable(expand("~/_vimrc.local"))
  source ~/_vimrc.local
endif

