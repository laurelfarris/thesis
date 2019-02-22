;+
;- LAST MODIFIED: Wed Feb 20 06:04:41 MST 2019
;-
;- PURPOSE:
;-   Simple function to create window with properties I use
;-   most often (so don't have to type same lines over and over).
;-
;- INPUT:
;-   None required
;-
;- KEYWORDS:
;-   Any of IDL's keywords available for WINDOW function.
;-
;- OUTPUT:
;-   window object
;-
;- TO DO:
;-  buffer default should be 1, but I'm being lazy for now
;-    since still in LC...
;-  This routine has to be manually edited depending on if you
;-    want window location to increase in x or y direction.
;-    Should do better, but works for now.


function WIN_QUICK, $
    _EXTRA=e


    common defaults

    wx = 18.0
    wy = 5.0


    lx = 0
    ly = 0

    win = GetWindows()
    current_win = GetWindows(/current)

    if current_win ne !NULL then begin
        width = (current_win.dimensions)[0]
        height = (current_win.dimensions)[1]
        ii = n_elements(win)
    endif else begin
        width = 0.0
        height = 0.0
        ii = 0
    endelse


    ;loc = [lx,ly] + ii*[width,0]

    loc = [lx,ly] + ii*[0,height+10]
    ;- added a few pixels to height because of extra space
    ;-  used up by window title/menu bars, or whatever they're called.

    win = window( $
        dimensions=[wx,wy]*dpi, $
        location=loc, $
        buffer=0, $
        _EXTRA=e )



    return, win

end
