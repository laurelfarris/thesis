; Last modified:   05 March 2018 17:27:30

; Returns position in INCHES,
;    as a 4 x N array (where N = rows * cols )

; Need to set /device keyword.


function GET_POSITION, $
    cols=cols, $
    rows=rows, $
    margin=margin, $
    width=width, $
    ;height=height, $
    ratio=ratio, $
    xgap=xgap, $
    ygap=ygap, $
    dpi=dpi


    ; width, height - dimensions of each graphic panel.
    ; Does NOT include space used by tick labels, axis titles, etc.

    height = width * ratio

    left = margin[0]
    bottom = margin[1]
    right = margin[2]
    top = margin[3]

    ; Position arrays, to make the following code easier to write.
    x1 = fltarr( rows*cols )
    y1 = fltarr( rows*cols )

    i = 0
    ;; y in reverse to put layout in same order as default.
    for y = rows-1, 0, -1 do begin
        for x = 0, cols-1 do begin
            x1[i] = x * (xgap+width)  + left
            y1[i] = y * (ygap+height) + bottom
            i = i + 1
        endfor
    endfor

    x2 = x1 + width
    y2 = y1 + height

    pos = fltarr(4, rows*cols)
    pos[0,*] = x1
    pos[1,*] = y1
    pos[2,*] = x2
    pos[3,*] = y2

    ; Hacky way to ensure position is 2D, even for one panel.
    ; Other routines may run into issues otherwise.
    if n_elements(size(pos, /dimensions)) le 1 then $
        pos = reform(pos, 4, 1)

    ;wy = 1050.
    ;wx = wy * ( max(pos[2,*]) / max(pos[3,*]) )
    ;if wx gt 1920 then begin
    ;    frac = 1920./wx
    ;    wx = 1920.
    ;    wy = wy * frac
    ;endif

    wx = max( pos[2,*] ) + margin[2]
    wy = max( pos[3,*] ) + margin[3]
    ;wx = max( pos[2,*] ) + min( pos[0,*] )
    ;wy = max( pos[3,*] ) + min( pos[1,*] )

    ; if there is already a window present, place this one in a different
    ; location so that both can be seen. See window methods, etc.
    ; Can I buffer this one at first, then show it later?
    ; Want to be able to call this without creating a window every time.
    ; Or set a keyword to make a window or not.
    win =  window( dimensions=[wx, wy]*dpi, location=[96,0])

    return, pos*dpi


end



function get_position2, layout=layout, _EXTRA=e


    ; dpi = 72 for printing to file, 96 for better viewing

    ; Margins
    ; User shouldn't have to set this... would like to automatically set
    ;  based on whether tick/axis labels, title, etc. are present.
    ; Ditto for inter-panel gaps.


    ;if not keyword_set(margin) then margin=make_array(4, value=1.0)
    ;if n_elements(margin) eq 1 then margin=make_array(4, value=margin)
    ; gap = 0.10 for panels right next to each other
    ; gap = 1.00 to leave room for tick/axis labels.

    if not keyword_set(layout) then layout=[1,1]

    cols = layout[0]
    rows = layout[1]

    pos = get_position( $
        cols=cols, $
        rows=rows, $
        width=5.0/cols, $
        ratio=1.0, $
        ;height=5.0/cols, $
        margin=[1.0,0.5,0.3,0.3], $
        xgap=1.0, $
        ygap=1.0, $
        dpi=72, $
        _EXTRA=e $
    )
    
    return, pos




end
