" taken from Limp: http://mikael.jansson.be/hacking/limp/docs/
" It did a bunch of stuff that I didn't like, so it's a hacked up version.

" Format Current:     reindent/format
" Format Top:    
nnoremap <buffer> ,fc [(=%`'
nnoremap <buffer> ,ft 99[(=%`'

" next/prev
nnoremap <buffer> <silent> ( :call Sexp_Previous()<CR>
nnoremap <buffer> <silent> ) :call Sexp_Next()<CR>
" next/prev at same level
nnoremap <buffer> { [(
nnoremap <buffer> } ])

" Sexp Comment:      comment all the way from the top level
nnoremap <buffer> <silent> ,ct 99[(%a\|#<ESC>hh%i#\|<ESC>

" Sexp Comment Current:    comment current form
nnoremap <buffer> <silent> ,cc [(%a\|#<ESC>hh%i#\|<ESC>

nnoremap <buffer> <silent> ,hd :call Lisp_send_to_lisp("(describe '".expand("<cword>").")")<CR>

nnoremap <buffer> ,lf :call Lisp_send_to_lisp( "(load \"" . expand( "%:p" ) . "\")")<cr>

" open new line before/after current sexp
nmap <buffer> ,o {%a(
nmap <buffer> ,O {i<esc>(a(

nnoremap <buffer> <silent> <F7> :wa<cr>:silent call Lisp_eval_top_form()<CR>
nnoremap <buffer> <silent> <C-F7> :call Screen_Vars()<cr>
nnoremap <buffer> <silent> <S-F7> :call Lisp_eval_current_form()<CR>

" debugger interactions
nnoremap <buffer> <silent> <F12> :call Lisp_send_to_lisp("ABORT")<cr>
nnoremap <buffer> <silent> <C-F12> :call Lisp_send_to_lisp("")<cr>
nnoremap <buffer> <silent> <M-Down> :call Lisp_send_to_lisp("DOWN")<cr>
nnoremap <buffer> <silent> <M-Up> :call Lisp_send_to_lisp("UP")<cr>
nnoremap <buffer> <silent> <M-l> :call Lisp_send_to_lisp("LIST")<cr>
nnoremap <buffer> <silent> <M-b> :call Lisp_send_to_lisp("BACKTRACE")<cr>
nnoremap <buffer> <silent> <M-p> :call Lisp_send_to_lisp("PRINT")<cr>
nnoremap <buffer> <silent> <M-a> :call Lisp_send_to_lisp("SOURCE 2")<cr>
nnoremap <buffer> <silent> <M-s> :call Lisp_send_to_lisp("SOURCE 4")<cr>
nnoremap <buffer> <silent> <M-d> :call Lisp_send_to_lisp("SOURCE 999")<cr>
nnoremap <buffer> <silent> <M-e> :call Lisp_send_to_lisp("ERROR")<cr>

nnoremap <buffer> <silent> <F11> :wa<cr>:call Lisp_run_tests()<cr>
nnoremap <buffer> <silent> <C-F11> :call Lisp_toggle_to_from_tests()<cr>

setlocal nocompatible nocursorline
setlocal lisp syntax=lisp
setlocal ls=2 bs=2 si et sw=2 ts=2 tw=0 
setlocal iskeyword=&,*,+,45,/,48-57,:,<,=,>,@,A-Z,a-z,_
setlocal cpoptions-=mp
 
" This allows gf and :find to work. Fix path to your needs
setlocal suffixesadd=.lisp,cl path=/home/sgraham/**

" This allows [d [i [D [I work across files if an ASDF buffer is opened
" If I used load, it would be there too.
setlocal include=(:file\

setlocal complete+=s~/vimfiles/lisp/thesaurus


fun! Sexp_Next()
    let [l, c] = Sexp_get_Next()
    call cursor(l, c)
endfun

fun! Sexp_Previous()
    let [l, c] = Sexp_get_Previous()
    if l == 0 && c == 0
        return
    endif
    call cursor(l, c)
    return
endfun

" return the position of the next s-exp
fun! Sexp_get_Next()
    return searchpos('(', 'nW')
endfun

" return the position of the previous s-exp
fun! Sexp_get_Previous()
    let p = getpos(".")

    " If outside of *any* s-exps, move to the previous s-exp first.
    let [l, c] = searchpairpos('(', '', ')', 'bnW')
    if l == 0 && c == 0
        call searchpos(')', 'Wb')
    endif

    " now, move to the start of this s-exp, wherever it may be.
    let [l, c] = searchpos('(', 'Wnb')

    call setpos(".", p)

    return [l, c]
endfun

function! Lisp_get_pos()
  " what buffer are we in?
  let bufnr = bufnr( "%" )

  " get current position
  let c_cur = virtcol( "." )
  let l_cur = line( "." )
  normal! H
  let l_top = line( "." )

  let pos = bufnr . "|" . l_top . "," . l_cur . "," . c_cur

  " go back
  exe "normal! " l_cur . "G" . c_cur . "|"

  return( pos )
endfunction

function! Lisp_yank( motion )
  let value = ''

  let p = Lisp_get_pos()
  silent! exec 'normal!' a:motion
  let new_p = Lisp_get_pos()

  " did we move?
  if p != new_p
      " go back
      silent! exec 'normal!' a:motion

      let old_l = @l
      exec 'normal! "ly' . a:motion
      let value = @l
      let @l = old_l
  endif

  call Lisp_goto_pos( p )

  return( value )
endfunction

function! Lisp_goto_pos( pos )
  let mx = '\(\d\+\)|\(\d\+\),\(\d\+\),\(\d\+\)'
  let bufnr = substitute( a:pos, mx, '\1', '' )
  let l_top = substitute( a:pos, mx, '\2', '' )
  let l_cur = substitute( a:pos, mx, '\3', '' )
  let c_cur = substitute( a:pos, mx, '\4', '' )

  silent exe "hide bu" bufnr
  silent exe "normal! " . l_top . "Gzt" . l_cur . "G" . c_cur . "|"
endfunction

" Actually evals current top level form
function! Lisp_eval_top_form()
  " save position
  let p = Lisp_get_pos()

  silent! exec "normal! 99[("
  call Lisp_send_to_lisp( Lisp_yank( "%" ) )

  " fix cursor position, in case of error below
  call Lisp_goto_pos( p )
endfunction


function! Lisp_eval_current_form()
  " save position
  let pos = Lisp_get_pos()

  " find & yank current s-exp
  normal! [(
  let sexp = Lisp_yank( "%" )
  call Lisp_send_to_lisp( sexp )
  call Lisp_goto_pos( pos )
endfunction


function! Lisp_send_to_lisp(text)
  if !exists("g:screen_sessionname") || !exists("g:screen_windowname")
    call Screen_Vars()
  end
  echo system("screen -S " . g:screen_sessionname . " -p " . g:screen_windowname . " -X stuff '" . substitute(a:text, "'", "'\\\\''", 'g') . "'")
endfunction

silent! function! Lisp_toggle_to_from_tests()
    exe "cd " . expand("%:h")
    let curfn = expand("%:p")
    if match(curfn, '-test.lisp') == -1
        let testfn = substitute(curfn, ".lisp", '', '') . "-test.lisp"
        silent exe "edit " . testfn
    else
        let nontest = substitute(curfn, "-test.lisp", '.lisp', '')
        silent exe "edit " . nontest
    endif
endfunction

silent! function! Lisp_run_tests()
    exe "cd " . expand("%:h")
    let testfn = expand("%:p")
    if match(testfn, '-test.lisp') == -1
        let testfn = substitute(testfn, ".lisp", '', '') . "-test.lisp"
    endif
    call Lisp_send_to_lisp( "(load \"" . testfn . "\")\n")
endfunction

function! Screen_Session_Names(A,L,P)
  return system("screen -ls | awk '/Attached/ {print $1}'")
endfunction

function! Screen_Vars()
  if !exists("g:screen_sessionname") || !exists("g:screen_windowname")
    let g:screen_sessionname = ""
    let g:screen_windowname = "0"
  end

  let g:screen_sessionname = input("session name: ", "", "custom,Screen_Session_Names")
  let g:screen_windowname = input("window name: ", g:screen_windowname)
endfunction

