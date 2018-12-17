
;- Fri Dec 14 11:08:09 MST 2018

;- To Do:
;-   Need convenient way to change wx and wy.
;-   Combine with mess in Graphics/window2.pro.


wx = 5.0
wy = 5.0

;win = GetWindows(/current)
win = GetWindows()

win = window( $
    dimensions=[wx,wy]*dpi, $
    location=[400,0]*n_elements(win) )


;if win eq !NULL then begin
;    win = window( dimensions=[wx,wy]*dpi, location=[400,0] )
;    ;win = window( dimensions=[wx,wy]*dpi, buffer=1 )
;endif else begin


;endelse

;endif else begin
;    win.erase
;endelse


;win = window( $
;    dimensions=[wx,wy]*dpi, $
;    buffer = 0, $
;    location=[600,0] )
