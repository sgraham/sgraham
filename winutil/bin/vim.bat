@echo off
if %1'==' goto noargs
start gvim --servername GVIMLOCAL --remote-silent %*
goto done

:noargs
start gvim --servername GVIMLOCAL --remote-silent "<scratch>"
:done
