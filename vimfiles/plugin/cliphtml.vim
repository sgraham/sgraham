"
" For pasting highlighted code from gvim into Outlook.
"
" Put this file in your 'plugin' directory.
"
" You need to have +python and the win32 extensions installed.
" On Vim72 this is a quite old python 2.4. On Windows for whatever
" reason, Vim loads python via dll, so you''ll actually have to
" install python2.4 and pywin32-2.4, even if :ver is +python/dyn.
"
"
" Uses 2html to convert to html (same as :TOhtml), some python to
" stuff on to the Windows clipboard as html.
"
" The user command is :ClipHtml, and it optionally accepts a range.
" (i.e. you can visual select a block). A large file will take
" a while, 2html is quite slow, but a selection is normally OK.
"
"
" Scott Graham <scott.cliphtml@h4ck3r.net>
"
"



function! SelectionToClipboardAsHtml()
python <<ENDOFPYTHON
# Clipboard stuff from http://code.activestate.com/recipes/474121/
import re
import win32clipboard

#---------------------------------------------------------------------------
#  Convenience functions to do the most common operation

def HasHtml():
    """
    Return True if there is a Html fragment in the clipboard..
    """
    cb = HtmlClipboard()
    return cb.HasHtmlFormat()


def GetHtml():
    """
    Return the Html fragment from the clipboard or None if there is no Html in the clipboard.
    """
    cb = HtmlClipboard()
    if cb.HasHtmlFormat():
        return cb.GetFragment()
    else:
        return None


def PutHtml(fragment):
    """
    Put the given fragment into the clipboard.
    Convenience function to do the most common operation
    """
    cb = HtmlClipboard()
    cb.PutFragment(fragment)


#---------------------------------------------------------------------------

class HtmlClipboard:

    CF_HTML = None

    MARKER_BLOCK_OUTPUT = \
        "Version:1.0\r\n" \
        "StartHTML:%09d\r\n" \
        "EndHTML:%09d\r\n" \
        "StartFragment:%09d\r\n" \
        "EndFragment:%09d\r\n" \
        "StartSelection:%09d\r\n" \
        "EndSelection:%09d\r\n" \
        "SourceURL:%s\r\n"

    MARKER_BLOCK_EX = \
        "Version:(\S+)\s+" \
        "StartHTML:(\d+)\s+" \
        "EndHTML:(\d+)\s+" \
        "StartFragment:(\d+)\s+" \
        "EndFragment:(\d+)\s+" \
        "StartSelection:(\d+)\s+" \
        "EndSelection:(\d+)\s+" \
        "SourceURL:(\S+)"
    MARKER_BLOCK_EX_RE = re.compile(MARKER_BLOCK_EX)

    MARKER_BLOCK = \
        "Version:(\S+)\s+" \
        "StartHTML:(\d+)\s+" \
        "EndHTML:(\d+)\s+" \
        "StartFragment:(\d+)\s+" \
        "EndFragment:(\d+)\s+" \
           "SourceURL:(\S+)"
    MARKER_BLOCK_RE = re.compile(MARKER_BLOCK)

    DEFAULT_HTML_BODY = \
        "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\">" \
        "<HTML><HEAD></HEAD><BODY><!--StartFragment-->%s<!--EndFragment--></BODY></HTML>"

    def __init__(self):
        self.html = None
        self.fragment = None
        self.selection = None
        self.source = None
        self.htmlClipboardVersion = None


    def GetCfHtml(self):
        """
        Return the FORMATID of the HTML format
        """
        if self.CF_HTML is None:
            self.CF_HTML = win32clipboard.RegisterClipboardFormat("HTML Format")

        return self.CF_HTML


    def GetAvailableFormats(self):
        """
        Return a possibly empty list of formats available on the clipboard
        """
        formats = []
        try:
            win32clipboard.OpenClipboard(0)
            cf = win32clipboard.EnumClipboardFormats(0)
            while (cf != 0):
                formats.append(cf)
                cf = win32clipboard.EnumClipboardFormats(cf)
        finally:
            win32clipboard.CloseClipboard()

        return formats


    def HasHtmlFormat(self):
        """
        Return a boolean indicating if the clipboard has data in HTML format
        """
        return (self.GetCfHtml() in self.GetAvailableFormats())


    def GetFromClipboard(self):
        """
        Read and decode the HTML from the clipboard
        """

        try:
            win32clipboard.OpenClipboard(0)
            src = win32clipboard.GetClipboardData(self.GetCfHtml())
            #print src
            self.DecodeClipboardSource(src)
        finally:
            win32clipboard.CloseClipboard()


    def DecodeClipboardSource(self, src):
        """
        Decode the given string to figure out the details of the HTML that's on the string
        """
                    # Try the extended format first (which has an explicit selection)
        matches = self.MARKER_BLOCK_EX_RE.match(src)
        if matches:
            self.prefix = matches.group(0)
            self.htmlClipboardVersion = matches.group(1)
            self.html = src[int(matches.group(2)):int(matches.group(3))]
            self.fragment = src[int(matches.group(4)):int(matches.group(5))]
            self.selection = src[int(matches.group(6)):int(matches.group(7))]
            self.source = matches.group(8)
        else:
                    # Failing that, try the version without a selection
            matches = self.MARKER_BLOCK_RE.match(src)
            if matches:
                self.prefix = matches.group(0)
                self.htmlClipboardVersion = matches.group(1)
                self.html = src[int(matches.group(2)):int(matches.group(3))]
                self.fragment = src[int(matches.group(4)):int(matches.group(5))]
                self.source = matches.group(6)
                self.selection = self.fragment


    def GetHtml(self, refresh=False):
        """
        Return the entire Html document
        """
        if not self.html or refresh:
            self.GetFromClipboard()
        return self.html


    def GetFragment(self, refresh=False):
        """
        Return the Html fragment. A fragment is well-formated HTML enclosing the selected text
        """
        if not self.fragment or refresh:
            self.GetFromClipboard()
        return self.fragment


    def GetSelection(self, refresh=False):
        """
        Return the part of the HTML that was selected. It might not be well-formed.
        """
        if not self.selection or refresh:
            self.GetFromClipboard()
        return self.selection


    def GetSource(self, refresh=False):
        """
        Return the URL of the source of this HTML
        """
        if not self.selection or refresh:
            self.GetFromClipboard()
        return self.source


    def PutFragment(self, fragment, selection=None, html=None, source=None):
        """
        Put the given well-formed fragment of Html into the clipboard.

        selection, if given, must be a literal string within fragment.
        html, if given, must be a well-formed Html document that textually
        contains fragment and its required markers.
        """
        if selection is None:
            selection = fragment
        if html is None:
            html = self.DEFAULT_HTML_BODY % fragment
        if source is None:
            source = "file://cliphtml.vim"

        fragmentStart = html.index(fragment)
        fragmentEnd = fragmentStart + len(fragment)
        selectionStart = html.index(selection)
        selectionEnd = selectionStart + len(selection)
        self.PutToClipboard(html, fragmentStart, fragmentEnd, selectionStart, selectionEnd, source)


    def PutToClipboard(self, html, fragmentStart, fragmentEnd, selectionStart, selectionEnd, source="None"):
        """
        Replace the Clipboard contents with the given html information.
        """

        try:
            win32clipboard.OpenClipboard(0)
            win32clipboard.EmptyClipboard()
            src = self.EncodeClipboardSource(html, fragmentStart, fragmentEnd, selectionStart, selectionEnd, source)
            #print src
            win32clipboard.SetClipboardData(self.GetCfHtml(), src)
        finally:
            win32clipboard.CloseClipboard()


    def EncodeClipboardSource(self, html, fragmentStart, fragmentEnd, selectionStart, selectionEnd, source):
        """
        Join all our bits of information into a string formatted as per the HTML format specs.
        """
                    # How long is the prefix going to be?
        dummyPrefix = self.MARKER_BLOCK_OUTPUT % (0, 0, 0, 0, 0, 0, source)
        lenPrefix = len(dummyPrefix)

        prefix = self.MARKER_BLOCK_OUTPUT % (lenPrefix, len(html)+lenPrefix,
                        fragmentStart+lenPrefix, fragmentEnd+lenPrefix,
                        selectionStart+lenPrefix, selectionEnd+lenPrefix,
                        source)
        return (prefix + html)


if __name__ == '__main__':
    import vim
    str = '\n'.join(vim.current.buffer)
    PutHtml(str)
    
ENDOFPYTHON
endfunction

command! -range=% ClipHtml :call ConvertToClipHtml(<line1>, <line2>)
function! ConvertToClipHtml(line1, line2)

    if exists("g:html_use_css")
        unlet g:html_use_css
    endif
    let g:html_font="consolas, courier new"
    if a:line2 >= a:line1
        let g:html_start_line = a:line1
        let g:html_end_line = a:line2
    else
        let g:html_start_line = a:line2
        let g:html_end_line = a:line1
    endif

    runtime syntax/2html.vim

    " move background colour to a wrapping table instead of the body (gets lost in outlook otherwise)
    %g/<body/normal k$dgg
    %s/<body\s*\(bgcolor="[^"]*"\)\s*text=\("[^"]*"\)\s*>/<table \1 cellPadding=0><tr><td><font color=\2><font size="2">/
    %s#</body>\(.\|\n\)*</html>#\='</font></font></td></tr><tr><td></td></tr></table>'#i

    " stick on clipboard
    call SelectionToClipboardAsHtml()

    bdelete!

    unlet g:html_start_line
    unlet g:html_end_line
    unlet g:html_font
endfunc

" vim: set ft=python:
