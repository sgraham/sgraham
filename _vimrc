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
set modeline
set incsearch
set showmatch
set complete=.,b,u,i
set ruler
set gdefault
set viminfo='50,\"1000,:0,n$HOME/_viminfo
set updatetime=1000
set previewheight=10
set titlestring=%t\ %(%r\ %m%)\ %F
set wildmenu
set wildignore+=*.log,*.pdf,*.swp,*.o,*.py[co],*~

"set tags+=c:/devkitPro/libnds/include/tags
"set tags+=c:/code/twinisles/src/tags
"set tags+=c:\\Program\\\ Files\\\Microsoft\\\ Visual\\\ Studio\\\ .NET\\Vc7\\PlatformSDK\\Include\\tags
"set path+=c:\\code\\twinisles\\src\\**
set tags+=c:/work/packages/easharptest/dev/src/tags
set tags+=c:/work/packages/easharp/dev/runtime/tags
set tags+=c:/work/packages/euclideancombat/dev/src/tags
set tags+=c:/code/packages/tags
set tags+=c:/program\\\ files\\\ (x86)/microsoft\\\ visual\\\ studio\\\ 8/vc/tags
set tags+=../tags,../../tags,../../../tags,../../../../tags,../../../../../tags
set path+=c:/work/packages/easharptest/dev/src
set path+=c:/work/packages/easharp/dev/runtime/**

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
map <silent> <PageUp> :set nowrapscan<cr>?<cr>zt:noh<cr>:set wrapscan<cr>
map <silent> <PageDown> :set nowrapscan<cr>/<cr>zt:noh<cr>:set wrapscan<cr>
nnoremap <silent> <ESC> :noh<CR><ESC>
map <F12> :BufExplorer<cr>

map ,sws :set list!<cr>

map ,cd :cd %:p:h<cr>
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
"noremap <silent> <ESC><ESC> :ccl<cr>
noremap <M-l> guiww
noremap <M-u> gUiww
noremap! <M-l> <Esc>guiw`]a
noremap! <M-u> <Esc>gUiw`]a
noremap <silent> <M-f> :FuzzyFinderFile<cr>
noremap <silent> <M-t> :FuzzyFinderTag<cr>
noremap <silent> <M-g> :FuzzyFinderTaggedFile<cr>
noremap <silent> <M-b> :FuzzyFinderBuffer<cr>
noremap <silent> <M-d> :FuzzyFinderDir<cr>
if has("unix")
    map <silent> <C-F5> :if expand("%:p:h") != ""<CR>:!start explorer.exe %:p:h,/e<CR>:endif<CR><CR> 
else
    map <silent> <C-F5> :if expand("%:p:h") != ""<CR>:!nautilus %:p:h<CR>:endif<CR><CR> 
endif
map <F12> :BufExplorer<cr>

" for the wrap nazis
"au BufWinEnter *.py,*.cpp,*.c,*.h,*.cs if &textwidth > 4
"\ | let w:m1=matchadd('MatchParen', printf('\%%<%dv.\%%>%dv', &textwidth+1, &textwidth-4), -1)
"\ | let w:m2=matchadd('ErrorMsg', printf('\%%>%dv.\+', &textwidth), -1)
"\ | endif


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
autocmd BufRead,BufNewFile,BufEnter *.json set ft=json
autocmd BufNewFile,BufRead,BufEnter *.boo,*.module setf boo 
autocmd BufNewFile,BufRead,BufEnter *.ls setf lisp
autocmd FileType mail set tw=72
autocmd BufRead,BufNewFile,BufEnter *.lisp,*.clj so ~/vimfiles/lisp/lisp.vim
autocmd BufRead,BufNewFile,BufEnter *.sk set ft=python ts=4 shiftwidth=4 expandtab
autocmd BufRead,BufNewFile,BufEnter *.j setf objj
autocmd BufRead,BufNewFile,BufEnter *.arc setf arc 
autocmd BufEnter * cd %:p:h

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
set guioptions=ai
if has("unix")
    set guifont=Consolas\ 9
else
    set guifont=Lucida\ Console:h9:w5
    "depending on dpi and time of day (!)
    "set guifont=Consolas:h8
    "set guifont=Consolas:h10
endif

syntax on


augroup filetype
    au! BufRead,BufNewFile *.ll     set filetype=llvm
    au! BufRead,BufNewFile *.llx    set filetype=llvm
augroup END

gui
set lines=87

colo darkblue

if filereadable(expand("~/_vimrc.local"))
  source ~/_vimrc.local
endif


"function! DoRope()
    "source ~/vimfiles/rope/ropevim/ropevim.vim
    "noremap <silent> <M-f> :RopeFindFile<cr>
    "inoremap <silent> <M-f> <Esc>:RopeFindFile<cr>
    "noremap <silent> <M-j> :RopeShowCalltip<cr>
    "inoremap <silent> <M-j> <Esc>:RopeShowCalltip<cr>
    "noremap <silent> <M-r> :RopeRename<cr>
    "inoremap <silent> <M-d> <Esc>:RopeRename<cr>
    "noremap <silent> <M-d> :RopeGotoDefinition<cr>
    "inoremap <silent> <M-r> <Esc>:RopeGotoDefinition<cr>
"endfunction
"let $PYTHONPATH.="/home/sgraham/vimfiles/rope/rope:/home/sgraham/vimfiles/rope/ropemode:/home/sgraham/vimfiles/rope/ropevim"
"autocmd BufRead,BufNewFile,BufEnter *.py call DoRope()
