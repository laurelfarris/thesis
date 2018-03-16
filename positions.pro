;; Last modified:   05 March 2018 17:27:30

;; Returns position in INCHES.
;; Need to multiply by dpi, and set /device keyword.



;; Need a better way to set up default values...


function POSITIONS, $
    layout=layout, $
    margin=margin, $
    width=width, height=height, $
    xgap=xgap, $
    ygap=ygap, $
    dpi=dpi


    if not keyword_set(layout) then begin
        cols=1
        rows=1
    endif else begin
        cols=layout[0]
        rows=layout[1]
    endelse


    ;; Margins
    if not keyword_set(margin) then margin=make_array(4, value=1.0)
    if n_elements(margin) eq 1 then margin=make_array(4, value=margin)
    left = margin[0]
    bottom = margin[1]
    right = margin[2]
    top = margin[3]

;    if not keyword_set(width) then width=6.0 & height=width


    ;; Position array(s)
    x1 = fltarr( rows*cols )
    y1 = fltarr( rows*cols )

    if not keyword_set(dpi) then dpi = 72

    i = 0
    ;; y in reverse to put layout in same order as default.
    for x = 0, cols-1 do begin
        for y = rows-1, 0, -1 do begin
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

    return, pos


end
